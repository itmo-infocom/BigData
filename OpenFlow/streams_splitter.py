#!/usr/bin/python

# Copyright (C) 2014 Oleg Sadov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import requests
import sys
import imp
import os.path

def simple_path(url, sw, inp, outp, priority):
    url += '/stats/flowentry/add'
    r = requests.post(url, data="""
{"dpid":"%d", "priority": %d, "actions": [{"type":"OUTPUT", "port":"%s"}],
 "match": {"in_port": %s}}
""" % (sw, priority, outp, inp))
    return r.status_code

def ip_path(url, sw, inp, outp, priority,
             nw_src=None, tp_src=None, nw_dst=None, tp_dst=None):
    url += '/stats/flowentry/add'
    data = '{"dpid":"%d", "priority": %d, "actions": [{"type":"OUTPUT", "port":"%d"}], "match": {"dl_type": 0x0800, "nw_proto": 6, "in_port": %d' % (sw, priority, outp, inp)

    if nw_src:
        data += ' ,"nw_src": "%s"' % nw_src
    if tp_src:
        data += ' ,"tp_src": "%s"' % tp_src
    if nw_dst:
        data += ' ,"nw_dst": "%s"' % nw_dst
    if tp_dst:
        data += ' ,"tp_dst": "%s"' % tp_dst

    data += '}}'

    print data

    r = requests.post(url, data)
    return r.status_code

def del_flow(url, sw, inp, priority,
             nw_src=None, tp_src=None,
             nw_dst=None, tp_dst=None):
    url += '/stats/flowentry/delete_strict'
    data = '{"dpid":"%d", "priority": %d, "match": {"dl_type": 0x0800, "nw_proto": 6, "in_port": %d' % (sw, priority, inp)

    if nw_src:
        data += ' ,"nw_src": "%s"' % nw_src
    if tp_src:
        data += ' ,"tp_src": "%s"' % tp_src
    if nw_dst:
        data += ' ,"nw_dst": "%s"' % nw_dst
    if tp_dst:
        data += ' ,"tp_dst": "%s"' % tp_dst

    data += '}}'

    print data

    r = requests.post(url, data)
    return r.status_code

def basic_topo(url, priority, path):
    for sw in path.keys():
        if simple_path(url, sw, path[sw][0], path[sw][1], priority) != 200:
            return 1
        if simple_path(url, sw, path[sw][1], path[sw][0], priority) != 200:
            return 1

    return 0

def path(url, priority, path, nw_src=None, tp_src=None,
         nw_dst=None, tp_dst=None):
    for sw in path.keys():
        if ip_path(url, sw, path[sw][0], path[sw][1], priority, \
                       nw_src, tp_src, nw_dst, tp_dst) != 200:
            return 1
        if ip_path(url, sw, path[sw][1], path[sw][0], priority, \
                       nw_dst, tp_dst, nw_src, tp_src) != 200:
            return 1

    return 0

def del_path(url, priority, path, nw_src=None, tp_src=None,
         nw_dst=None, tp_dst=None):
    for sw in path.keys():
        if del_flow(url, sw, path[sw][0], priority, \
                       nw_src, tp_src, nw_dst, tp_dst) != 200:
            return 1
        if del_flow(url, sw, path[sw][1], priority, \
                       nw_dst, tp_dst, nw_src, tp_src) != 200:
            return 1

    return 0

def monitor(url, priority, paths=[],
            topo_file='/tmp/streams_splitter_topo.py',
            streams_file='/tmp/streams_splitter'):
    flows = []
    topo_time = 0
    while 1:
        t_time = os.path.getmtime(topo_file)
        if topo_time != t_time:
            topo = imp.load_source('', topo_file)
            for sw in topo.clean:
                requests.delete(url + '/stats/flowentry/clear/%d' % sw)
            if basic_topo(url, 3301, topo.base):
                print ":("
                sys.exit(-1)
            paths = topo.paths
            print "new topo: "
            print "clean=" + `topo.clean`
            print "base=" + `topo.base`
            print "paths=" + `topo.paths`

            topo_time = t_time
            flows = []

        f=open(streams_file,'r')
        n = len(paths)
        i = 0
        tmp_flows = []
        # Add new flows
        for s in f.readlines():
            tmp_flows.append(s)
            if s not in flows:
                src, dst = s.split()
                nw_src, tp_src = src.split(':')[-2:]
                nw_dst, tp_dst = dst.split(':')[-2:]
                if path(url, priority, paths[i],
                        nw_src, tp_src, nw_dst, tp_dst):
                    print ":(("
                    sys.exit(-1)
                i += 1
                if i >= n:
                    i = 0
        # Remove old flows
        for s in flows:
            if s not in tmp_flows:
                src, dst = s.split()
                nw_src, tp_src = src.split(':')[-2:]
                nw_dst, tp_dst = dst.split(':')[-2:]
                if del_path(url, priority, paths[i],
                            nw_src, tp_src, nw_dst, tp_dst):
                    print ":(("
                    sys.exit(-1)
        flows = tmp_flows
        f.close()


if __name__ == "__main__":

    if len(sys.argv) < 2:
        print "Usage: %s OF_controller_url"
        sys.exit(-1)
    monitor(sys.argv[1], 3331)

    print ":)"
    sys.exit(0)
