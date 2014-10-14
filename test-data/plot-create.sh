#!/bin/bash

# Initial version has been created by Arsen Kairkanov  14 October 2014

function print_usage() {
    cat <<EOF
        "-h"|"--help"        ) print_usage
        "-t"|"--title"       ) Title=./data
        "-l"|"--logdir"      ) Path_to_Logs=./
        "-d"|"--data"        ) Path_to_Data_File=./data
        "-o"|"--output"      ) Path_to_Output_File=./plot.`date +%x-%T`
        "-x"|"--xlabel"      ) XLabel_Name=Number of measurement
        "-y"|"--ylabel"      ) YLabel_Name=Average transfer speed
        "-i"|"--ymin"        ) YLabel_Min=0
        "-a"|"--ymax"        ) YLabel_Max=500000
        
Example: ./plot-create.sh -o /home/arsen/test.plot -i 300000 -a 700000 --title BigData -x number -y speed

EOF
}


Path_to_Logs='./'
Path_to_Data_File='./data'
Path_to_Output_File='./plot.`date +%x-%H-%M-%S`'
XLabel_Name='Number of measurement'
YLabel_Name='Average transfer speed'
YLabel_Min=0
YLabel_Max=500000
Title=${Path_to_Data_File}

while [[ $# -gt 0 ]]; do
    opt="$1"
    shift;
    current_arg="$1"
    case "$opt" in
        "-h"|"--help"        ) print_usage; exit 1;;
        "-t"|"--title"       ) Title="$1"; shift;;
        "-l"|"--logdir"      ) Path_to_Logs="$1";  shift;;
        "-d"|"--data"        ) Path_to_Data_File="$1";  shift;;
        "-o"|"--output"      ) Path_to_Output_File="$1"; shift;;
        "-x"|"--xlabel"      ) XLabel_Name="$1"; shift;;
        "-y"|"--ylabel"      ) YLabel_Name="$1"; shift;;
        "-i"|"--ymin"        ) YLabel_Min="$1"; shift;;
        "-a"|"--ymax"        ) YLabel_Max="$1"; shift;;
        *                    ) echo "ERROR: Invalid option: \""$opt"\"" >&2
                               print_usage; exit 1;;
    esac
done

grep -r 'Average transfer speed' ${Path_to_Logs} | awk '{print $6}' | cat > ${Path_to_Data_File}

gnuplot <<HERE
set terminal postscript landscape color "Times-Roman" 18 linewidth 2 
set timestamp "%d/%m/%y %H:%M"                             
set output "${Path_to_Output_File}.ps"
set grid back  lt 0 lw 1
set xlabel "${XLabel_Name}" 
set bmargin 4
set ylabel "${YLabel_Name}" 
set yrange [${YLabel_Min}:${YLabel_Max}]
set key top left
set style line 1 lt 1 pt 9
plot "${Path_to_Data_File}" using 1 title "${Title}" with linespoints linestyle 1
HERE
