BigData
=======
2 bash scripts for testing BigData tranfer systems.

Each script create a directory that contain many different files that will be transfered in our tests.
File sizes is normally distributed.
User can set the average value and dispersion (or sigma - in the different script).
Filenames is sipmle - 1, 2, 3, etc.
dd command copies bytes from sample to new files in directory.

Each script has 5 parameters, that must be entered:
1 - directory name - select or create new directoty in current directory.
2 - directory size - summary size of all files in directory (the real size may be a little smaller).
3 - average size of files that will be created in our directory.
4 - dispersion - setting sigma or dispersion value of file sizes.
5 - sample - setting the path to sample-file (any compressed file like .zip or .mp4). 

Example stdout of script:

$ ./create-test-file-sigma.sh NewDirectory 1000 100 20  ~/MAQ01437.MP4

120+0 records in
120+0 records out
122880 bytes (123 kB) copied, 0.000306745 s, 401 MB/s

110+0 records in
110+0 records out
112640 bytes (113 kB) copied, 0.000366169 s, 308 MB/s

83+0 records in
83+0 records out
84992 bytes (85 kB) copied, 0.000219377 s, 387 MB/s

73+0 records in
73+0 records out
74752 bytes (75 kB) copied, 0.000202047 s, 370 MB/s

99+0 records in
99+0 records out
101376 bytes (101 kB) copied, 0.000251424 s, 403 MB/s

96+0 records in
96+0 records out
98304 bytes (98 kB) copied, 0.000233547 s, 421 MB/s

89+0 records in
89+0 records out
91136 bytes (91 kB) copied, 0.000227776 s, 400 MB/s

93+0 records in
93+0 records out
95232 bytes (95 kB) copied, 0.000230028 s, 414 MB/s

67+0 records in
67+0 records out
68608 bytes (69 kB) copied, 0.000215069 s, 319 MB/s

120+0 records in
120+0 records out
122880 bytes (123 kB) copied, 0.000304942 s, 403 MB/s

103+0 records in
103+0 records out
105472 bytes (105 kB) copied, 0.000263974 s, 400 MB/s

total 948

-rw-rw-r--. 1 test test 110 Apr 23 21:39 1

-rw-rw-r--. 1 test test 103 Apr 23 21:39 10

-rw-rw-r--. 1 test test  83 Apr 23 21:39 2

-rw-rw-r--. 1 test test  73 Apr 23 21:39 3

-rw-rw-r--. 1 test test  99 Apr 23 21:39 4

-rw-rw-r--. 1 test test  96 Apr 23 21:39 5

-rw-rw-r--. 1 test test  89 Apr 23 21:39 6

-rw-rw-r--. 1 test test  93 Apr 23 21:39 7

-rw-rw-r--. 1 test test  67 Apr 23 21:39 8

-rw-rw-r--. 1 test test 120 Apr 23 21:39 9

$
