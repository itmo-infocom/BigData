#!/bin/bash

. ./settings

cat << END
set size 1.0,1.0;
set terminal postscript landscape color "Times-Roman" 14 linewidth 2
set timestamp "%d/%m/%y %H:%M" 

set key left top Left noreverse enhanced box linetype -1 linewidth 1.000 samplen 4 spacing 1 width 0 height 0 autotitles
set grid back  lt 0 lw 1
set xlabel 'TCP Window Size (B); [plotfile = "DataSpeed-$TEST.$DATE.plot"]' 
set ylabel "Bandwidth (KB/s)"

set title "$TITLE $DATE" 

set xtics ("131072" 1,"262144" 2,"524288" 3,"1048576" 4,"2097152" 5, "4194304" 6,"8388608" 7,"16777216" 8,"33554432" 9,"67108864" 10,"134217728" 11,"268435456" 12,"536870912" 13)
set xtics rotate

set xrange [$X]
set yrange [$Y]

plot 'DataSpeed-$TEST.s1' with linespoints t 'streams=1', 'DataSpeed-$TEST.s2' with linespoints t 'streams=2', 'DataSpeed-$TEST.s3' with linespoints t 'streams=3', 'DataSpeed-$TEST.s4' with linespoints t 'streams=4', 'DataSpeed-$TEST.s18' with linespoints t 'streams=18', 'DataSpeed-$TEST.s26' with linespoints t 'streams=26', 'DataSpeed-$TEST.s50' with linespoints t 'streams=50', 'DataSpeed-$TEST.s64' with linespoints t 'streams=64'
END
