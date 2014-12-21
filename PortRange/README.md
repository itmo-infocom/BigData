PortRange
----------------

This bash script is to test what ports are used by utility-to-test

  for CopyData.bbftp    such utility is bbftp
  for CopyData.bbcp     such utility is bbcp
  for CopyData.gridftp  such utility is globus-url-copy

If <utility-to-test> is not specifyed all processes which have
tcp-connection with port range specified are listed

Creation date: Thu Dec 18 19:18:40 MSK 2014

by Vladimir Titov   email:  tit@astro.spbu.ru


This script is run with the following input parameters:

PortRange  <port-range> [<utility-to-test>]

where:

    port-range       -- specifies a range of port to test
    utility-to-test  -- what utilityto test

