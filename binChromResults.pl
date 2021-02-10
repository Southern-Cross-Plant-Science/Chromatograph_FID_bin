#!/usr/bin/perl
## 2019-May24
## Ramil P. Mauleon
## Southern Cross University 
## Lismore, NSW, Australia
## this script bins the output of chrom FID
##check the sample file that it processes...
## usage: <script> input_file > output_file

use warnings;
my $infile = $ARGV[0];## 1st argument from script, the input file to bin
my $line;
my $prevLine = 0;
my $bin = 0;
my $blockDist = 0.005; ## USER-Changeable, this is the minimum retention time difference between consecutive blocks for merging.. weirdness in perl so I added fudge factor for math comparison (0.1 is 0.10005...), 
if ($ARGV[1]) {
	$blockDist = $ARGV[1];
}

my $blockDiff; ## distance betwen two adjacent blocks

open IN, "$infile" or die $!;

print "Time\tBinNumber\tGap=$blockDist\n";
while (<IN>) {
	$line = $_;
	chomp($line); ##remove extra newlines
	next if ($line =~ m/^Time/) ; ## skip first line
	$blockDiff = $line - $prevLine;

	if ($blockDiff <= $blockDist) { ## adjacent blocks are near enough.
		$prevLine = $line; ## assign current time to 
		print "$prevLine\t$bin\t$blockDiff\n"; ## let's just print it for now.. still on the current bin number
		next;
	} ## end if currblock near prevblock
	
	if ($blockDiff > $blockDist) { ## the adjacent current & previous block are too far..
		$bin ++; ## define this as the next bin na
		$prevLine = $line; ## assign current time to 
		print "$prevLine\t$bin\t$blockDiff\n"; ## let's just print it for now.. still on the current bin number
		next;
	} ## end if currblock far from  prevblock

	
} ## end WHILE IN

