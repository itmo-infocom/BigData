RunTop.sh
---------

This bash script  is  a script which calls unix command 'top -ibn 1' to get CPU & Memory utilization.   
The script is invoked by bigdata scripts and designed to write output of command ' top -ibn 1' to <logfile> every <interval> seconds.

The script is run with the following input parameters:

RunTop.sh <Toplog> <Interval>

where:

      Toplog --  a log file for command 'top'
      Interval --  interval in seconds(default), suffix may be 'm' for minutes,'h' for hours,  'd' for days

