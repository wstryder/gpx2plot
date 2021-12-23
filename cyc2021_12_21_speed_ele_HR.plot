set terminal png
set output "cyc2021_12_21_speed_ele_HR.png"
set title "My awesome workout"
set xlabel "Seconds"
set ylabel "km/h"
set y2label "bmp / meters"
set y2tics
set grid
set key right bottom
# set xrange [0:1000]
plot "cyc2021_12_21.dat" using 1:8 with lines title "Speed", "cyc2021_12_21.dat" using 1:5 with lines title "Elevation" axes x1y2, "cyc2021_12_21.dat" using 1:4 with lines title "Heart rate" axes x1y2

