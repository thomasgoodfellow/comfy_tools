#!/usr/bin/perl

# Resize the active window to take the left/right/top/bottom half
# of the usable area

use strict;
use Getopt::Long;

my $verbose = 0;
GetOptions('v|verbose!' => \$verbose);

my $snapIdx = -1;
my $snapIdx = $#ARGV >= 0? index("LRTB", uc(substr($ARGV[0], 0, 1))): -1;
die "Missing snap location: Left | Right | Top | Bottom\n" if $snapIdx < 0;

my $targetWId = `xdotool getactivewindow`;
chomp $targetWId;

# Use a throwaway terminal window to learn about geometry
system("mate-terminal &");
use Time::HiRes;
Time::HiRes::sleep(0.15);
my $wId = `xdotool getactivewindow`;
chomp $wId;
my $cmd = "wmctrl -i -r $wId -b remove,maximized_horz,maximized_vert";
system($cmd);

# get widgets 
my $xprop = `xprop -id $wId`;
$xprop =~ /_NET_FRAME_EXTENTS.*? = (\d+),\s*(\d+),\s*(\d+),\s*(\d+)/;
my ($wL, $wR, $wT, $wB) = ($1, $2, $3, $4);
# ($wL, $wR, $wT, $wB) = (0, 0, 0, 0);

# get usable extent
$cmd = "wmctrl -i -r $wId -b add,maximized_horz,maximized_vert";
system($cmd);
my $ext = `xwininfo -shape -id $wId`;
$ext =~ /upper-left X:\s+(\d+).*upper-left Y:\s+(\d+).*Width:\s+(\d+).*Height:\s+(\d+)/s;
my ($mX, $mY, $mW, $mH) = ($1, $2, $3, $4);
system("wmctrl -i -c $wId");

# Now can calculate the client area to ask for such that the total
# window doesn't trespass beyond its portion of the display

# fraction of total for each layout (L, R, T, B)
my @wndFracs = (
    [0, 0.5, 0, 1],
    [0.5, 1, 0, 1],
    [0, 1, 0, 0.5],
    [0, 1, 0.5, 1],
    );

# Calculate bounding frames
my $fL = $mX + $wndFracs[$snapIdx][0] * $mW;
my $fR = $mX + $wndFracs[$snapIdx][1] * $mW;
my $fT = $mY + $wndFracs[$snapIdx][2] * $mH;
my $fB = $mY + $wndFracs[$snapIdx][3] * $mH;

my $cL = $fL + $wL;
my $cW = $fR - $cL - $wR;
my $cT = $fT + $wT;
my $cH = $fB - $cT - $wB;

system("wmctrl -i -r $targetWId -b remove,maximized_horz,maximized_vert");
$cmd = "wmctrl -i -r $targetWId -e 0,$cL,$cT,$cW,$cH";
print "$cmd\n" if $verbose;
system($cmd);
