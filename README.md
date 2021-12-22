# gpx2plot
Convert gpx files to a data format more suitable for plotting the gpx data with gnuplot or other such software.
Use "gpx2plot.pl route.gpx" to supply the gpx file from cli. Will output data into nice columns that can be read
by gnuplot, other plotting software or import into spreadsheets. With the data out of the prison of the horrid
XML file, you are free to use the data in any way you want.

The smooth column is the average value of five data points, in orded to clean up the usually very noisy
speed data from the gps device.

Prints out nice statistics of the gpx route at the end of output, commented out, so it is not read by
your plotting software. Happy GPS-hacking!
