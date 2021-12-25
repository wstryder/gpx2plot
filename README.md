# gpx2plot
## Summary
Convert gpx files to a data format more suitable for plotting the gpx data with gnuplot or other such software. Will output data into nice columns that can be read by gnuplot, other plotting software or import into spreadsheets. With the data out of the prison of the horrid XML file, you are free to use the data in any way you want.
## Usage
Type "gpx2plot.pl route.gpx" to supply the gpx file. Type "gpx2plot.pl route.gpx CSV" to output to a CSV file. The default is whitespace delimited data, with the CSV option the data is separated as the name suggest by a comma.
## Example output
``` 
 The columns in the output are:
 seconds latitude longitude heartRate elevation distance speed smooth
0 60.815768 24.789088 70 83.8 0 0 0
1 60.8158 24.789102 70 83.8 3.63867198298186 13.0992191387347 0
2 60.81582 24.78912 70 83.8 2.42887493520275 8.74394976672989 0
5 60.815827 24.78918 70 83.8 3.34539788978481 4.01447746774177 0
6 60.81584 24.789218 70 83.6 2.51714786671194 9.06173232016298 0
7 60.815858 24.789252 70 83.6 2.72140163756689 9.79704589524082 6.98387573867387
9 60.815878 24.78931 70 83.4 3.85207120154498 6.93372816278097 6.98387573867387
11 60.815897 24.789343 70 83.8 2.76885879619844 4.98394583315719 6.98387573867387
...
3670 60.815807 24.78929 98 87.2 3.85403033333252 1.98207274285672 2.62952530428833

 gpx2plot 0.1 by Ozfir Izmgzoz, 2021, late@sapatti.fi 

 File name: suuntoapp-Walking-2021-12-24T06-57-22Z
 Author: Lauri Rantala

 Start time: 2021-12-24 08:57:27
 End time: 2021-12-24 09:58:37

 Start location: 60.815768, 24.789088
 End location: 60.815807, 24.78929

 Duration: 1h, 1min, 10secs
 Distance: 4.58km

 Max speed: 23.99km/h
 Average speed: 4.49km/h

 Max heart rate: 124bpm
 Min heart rate: 70bpm
 Average heart rate: 109.21bpm

 Max elevation: 93.0m
 Min elevation: 82.2m
 Max uphill: 2.6m
 Max downhill: 1.8m

 Max latitude: 60.819622
 Min latitude: 60.80885
 Max longitude: 24.791695
 Min longitude: 24.767845
``` 
## Details
The smooth column is the average value of five data points, in orded to clean up the usually very noisy
speed data from the gps device. The output statistics are commented, so they are not read by your plotting or other software.
## More info
I have written a very short guide for beginners who want to understand the gpx format here: http://kristitty.net/blog/how-to-access-suunto-raw-gpx-data-with-perl/
For some info on this project see this: http://kristitty.net/blog/gpx2plot-convert-gpx-files-to-data-suitable-for-gnuplot/
