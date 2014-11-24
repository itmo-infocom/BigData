perfSONAR-API
=============
perfsonar API for SDN BigData

Usage: http://perfsonar.vuztc.ru:9911/psAPI?cmd=throughput&chan=perfs.pnpi.spb.ru&dt=86400

perfsonar.vuztc.ru -- host with perfSONAR and this daemon

9911 -- TCP port to which the daemon listens

/psAPI -- directory

cmd -- throughput | tracert for this version

chan -- perfs.pnpi.spb.ru | perfs.iwan.ru -- only two channels

dt -- interval monitoring from now, in seconds
