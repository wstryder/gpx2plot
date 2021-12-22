#!/usr/bin/perl
#
# gpx2plot 0.1 - Convert gpx files to a data file suitable for use with
# gnuplot, spreasheets and many other software that reads data of columns.
# Also gives you nice statistics of the gpx-route at the end of output.
# Sorry, imperial units are evil. Metric system only used here.
#
#    Copyright (C) 2021 Ozfir Izmgzoz: late@sapatti.fi
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################

use strict;
use warnings;

use Geo::Gpx;
# Deprecated, but oh it works fine for me and only option on my OS:
use Geo::Distance;
use Time::Piece;
use Time::Seconds;
use Number::Format qw(:subs);

my $gpxFile = $ARGV[0];

if (not defined $gpxFile) {
  die "Use:\n\"gpx2plot.pl file.gpx\" to supply a file name for the gpx file.\n";
}

my $gpx= Geo::Gpx->new(input =>$gpxFile);

my $geo = new Geo::Distance;

my $name = $gpx->name();

my $author = $gpx->author();
$author = $author->{name};

my $bounds = $gpx->bounds();

my $iter = $gpx->iterate_points();

# lat1 and lon1 are the previous point and lat2 and lon2 are the current
# point. The distance between points is calculated from these.
my $lat1 = 0;
my $lon1 = 0;
my $lat2 = 0;
my $lon2 = 0;

# Elevation
my $ele = 0;
my $minELE = 1000000;
my $maxELE = 0;

# Distance between points
my $distance = 0;
my $totalDistance = 0;

# Time
my $sT = 0;
my $time = 0;
my $timeSecs = 0;
my $prevSecs = 0;
my $duration = "";
my $startTime = 0;
my $endTime = 0;

# Speed
my $speed = 0;
my $avgSpeed = 0;
my $minSpeed = 100000;
my $maxSpeed = 0;
# smoothSpeed is used to take an average value of the speed, to
# clean up very noisy gps signal. Without the average, the speed
# is all over the place.
my $smoothSpeed = 0;
my $smoothSum = 0;
my $smoothRate = 5;

# Heart rate
my $hr = 0;
my $totalHR = 0;
my $avgHR = 0;
my $minHR = 1000000;
my $maxHR = 0;

my $iterations = 0;

my $startLat = 0;
my $startLon = 0;

print "####################################################################\n";
print "# The columns in the output are:\n";
print "# seconds latitude longitude heartRate elevation distance speed smooth\n";
print "####################################################################\n";

while ( my $pt = $iter->() ) {
	$time = $pt->{time};
	$hr = $pt->{extensions};
	$ele = $pt->{ele};

	if ( $sT == 0 ) {
		$sT = $time;
		$startTime = $time;
	} else {
		$timeSecs = $time - $sT;
	}

	$lat2 = $pt->{lat};
	$lon2 = $pt->{lon};

	if ( $lat1 == 0 ) {
		$lat1 = $lat2;
		$lon1 = $lon2;
		$startLat = $lat1;
		$startLon = $lon1;
	}

	$distance = $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );

	$speed = $timeSecs - $prevSecs;

	if ( $speed != 0) {
		$speed = $distance / $speed;
	}

	$speed = $speed * ( 18 / 5);

	if ( ($iterations % $smoothRate) == 0 ) {
		$smoothSpeed = $smoothSum / $smoothRate;
		$smoothSum = 0;
	} else {
		$smoothSum += $speed;
	}

	print $timeSecs, " ", $lat2, " ", $lon2, " ", $hr, " ", $ele, " ", $distance, " ", $speed, " ", $smoothSpeed, "\n";

	$lat1 = $lat2;
	$lon1 = $lon2;

	$totalDistance += $distance;

	$totalHR += $hr;

	$iterations++;

	$prevSecs = $timeSecs;

	if ($hr > $maxHR) {
		$maxHR = $hr;
	}

	if ($hr < $minHR) {
		$minHR = $hr;
	}

	if ($ele > $maxELE) {
		$maxELE = $ele;
	}

	if ($ele < $minELE) {
		$minELE = $ele;
	}

	if ($speed > $maxSpeed) {
		$maxSpeed = $speed;
	}

	if ($speed < $minSpeed) {
		$minSpeed = $speed;
	}
}

$endTime = $time;

$avgSpeed = ( $totalDistance / $timeSecs ) * ( 18 / 5) ;

$avgHR = $totalHR / $iterations;

# Convert the seconds into hours, minutes and seconds
my @parts = gmtime($timeSecs);
$duration = $parts[2] . "h, " . $parts[1] . "min, " . $parts[0] ."secs";

# A cool hack to convert meters to kilometers
$totalDistance = $totalDistance / 1000;

# Get the start and end times into nice formats
$startTime = localtime($startTime)->strftime('%F %T');
$endTime = localtime($endTime)->strftime('%F %T');

# Let's round some numbers
$totalDistance = round($totalDistance);
$maxSpeed = round($maxSpeed);
$minSpeed = round($minSpeed);
$avgSpeed = round($avgSpeed);
$avgHR = round($avgHR);

print "####################################################################\n";
print "# gpx2plot 0.1 by Ozfir Izmgzoz, 2021, late\@sapatti.fi \n";
print "#\n";
print "# File name: ", $name, "\n";
print "# Author: ", $author, "\n";
print "#\n";
print "# Start time: ", $startTime, "\n";
print "# End time: ", $endTime, "\n";
print "#\n";
print "# Start location: ", $startLat, ", ", $startLon, "\n";
print "# End location: ", $lat2, ", ", $lon2, "\n";
print "#\n";
print "# Duration: ", $duration, "\n";
print "# Distance: ", $totalDistance, "km\n";
print "#\n";
print "# Max speed: ", $maxSpeed, "km/h\n";
# This is stupid, because at the start the speed is always zero:
print "# Min speed: ", $minSpeed, "km/h\n";
print "# Average speed: ", $avgSpeed, "km/h\n";
print "#\n";
print "# Max heart rate: ", $maxHR, "bpm\n";
print "# Min heart rate: ", $minHR, "bpm\n";
print "# Average heart rate: ", $avgHR, "bpm\n";
print "#\n";
print "# Max elevation: ", $maxELE, "m\n";
print "# Min elevation: ", $minHR, "m\n";
print "#\n";
print "# Max latitude: ", $bounds->{maxlat}, "\n";
print "# Min latitude: ", $bounds->{minlat}, "\n";
print "# Max longitude: ", $bounds->{maxlon}, "\n";
print "# Min longitude: ", $bounds->{minlon}, "\n";
print "#\n";
print "####################################################################\n";
