CopyData.gridftp
----------------

This bash script  is designed to test transfer of big size data (BigData)
from local host to remote host using service 'gridftp'
and utility 'globus-url-copy' over Internet.
Detailed description of globus-gridftp-server and globus-url-copy can be found
on the page http://toolkit.globus.org/toolkit/docs/3.2/gridftp

This script is run with the following input parameters:

CopyData.gridftp [<globus-url-copy options>] <gridftp_config_file> \
    <BaseDir> <SourceDirectory> <RemoteHost> <DestinationDirectory> [<Comments>]

where:

    globus-url-copy options  -- list of options for globus-url-copy,
              for example: -vb -dbg -p 3
    gridftp_config_file  -- gridftp configuration file. Example: gridftp.conf
    BaseDir              -- directory (full path) where the script creates
                            subdirectory to store input and logging information
    SourceDirectory      -- directory or single file containing files to be
                            transferred to remote host. This directory is created
                            using script 'create-test-file-dispersion.sh'
                            (or create-test-file-sigma.sh).
                            Files sizes are normally distributed.
                            Script 'create-test-file-dispersion.sh' can be found
                            on the page https://github.com/itmo-infocom/BigData/
    RemoteHost           -- remote host that data to be transferred to
    DestinationDirectory -- directory (full path) on remote host where
                            transferred data to be written. This directory must
                             be created beforehand
    Comments             -- your comments, optional parameter


The script CopyData.gridftp creates under directory <BaseDir> subdirectory
with name CopyData.gridftp.<LocalHost>.<RemoteHost>.<date>_<time>
in which the following files are created:

 ABSTRACT.<LocalHost>.<RemoteHost>
 COMMENTS.<LocalHost>.<RemoteHost>
 LOG.BBCP.<LocalHost>.<RemoteHost>
 PING.<LocalHost>.<RemoteHost>
 TRACEROUTE.<LocalHost>.<RemoteHost>
 sosreport-<LocalHost>.<RemoteHost>-<date><time>-<hash>.tar.xz

The file ABSTRACT.<LocalHost>.<RemoteHost> has such content:

  Start time = <date time>
  Command line = <bbcp command line>
  Total data size to transfer(KB) = <value>
  Number of files = <value>
  Source directory with files = <value>
  Average file size(KB) = <value>
  File size dispersion = <value>
  Local host name = <value>
  Remote host name = <value>
  Remote host directory = <value>
  Data size transferred (KB) = <value>
  End time = <date time>
  Completion = YES/ABNORMAL
  Average transfer speed (KB/sec) = <value>

The file COMMENTS.<LocalHost>.<RemoteHost> is filled with <Comments> +
                                           content of <gridftp_config_file>
The file LOG.BBCP.<LocalHost>.<RemoteHost> is filled with the output (log) of
                                           globus-url-copy.
The file PING.<LocalHost>.<RemoteHost> is filled with the output of
                                           'ping -c 10 <RemoteHost>'
The file TRACEROUTE.<LocalHost>.<RemoteHost> is filled with the output of
                                           'traceroute <RemoteHost>'
The file sosreport-<LocalHost>.<RemoteHost>-<date><time>-<hash>.tar.xz is
                       created by command
sosreport --batch --tmp-dir \
           CopyData.gridftp.<LocalHost>.<RemoteHost>.<date>_<time> \
           --name <LocalHost>.<RemoteHost>

Now the script uses gridftp via ssh only. Use 'set-passwordless-ssh.sh'
to generate keys.

The description of parameters for gridftp configuration file and options
for globus-url-copy utility may be found in
globus-gridftp-server.hlp and globus-url-copy.hlp respectively.
