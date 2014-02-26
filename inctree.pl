#!/usr/bin/perl

use strict;
my $foldLibInc = 1;
my @fileStack;  # stack of included files
my %fileLines;	# pairs of [SLOC-this-file, SLOC-nested-within-file] non-blank linesper filename (key)
my @fileTree;	# basic include tree, pairs of [nesting depth, filename]
while(my $line = <>) 
{
  if($line =~ /^#\s+\d+\s+\"([^"]+)\"([ 1234]*)$/)
  {
      my ($file, $flags) = ($1, $2);
      if($flags =~ /1/ || $#fileStack == -1)	# include file being compiled
      {
          my $firstInc = !defined($fileLines{$file});	# only show first include in tree - presume file-guards used
          my $nestedLibInc = ($#fileStack >= 0) && ($fileStack[$#fileStack] =~ m-^/usr-i);	# test whether included by a library include - presumes /usr synonymous with lib code...
          push @fileStack, $file;
          push @fileTree, [$#fileStack, $file] if($firstInc && (!$foldLibInc || !$nestedLibInc));
      }
      if($flags =~ /2/)
      {
          # sum the SLOC of this file into the nested counts of enclosing files
          my $file = pop @fileStack;
          my $sloc = $fileLines{$file}[0];
          for(my $i = $#fileStack; $i >= 0; --$i)
          {
              $file = $fileStack[$i];
              $fileLines{$file}[1] += $sloc;
          }
      }
  }
  elsif($line !~ /^\s*$/)
  {
      $fileLines{$fileStack[$#fileStack]}[0]++ if($#fileStack >= 0);	# tally non-blank in current file
  }
}

# dump tree
print "l-SLOC n-SLOC File\n";
for(@fileTree)
{
    my ($depth, $file) = ($_->[0], $_->[1]);
    my $lines = $fileLines{$file};
    printf "%6d %6d %s %s\n", $lines->[0], $lines->[1], "  " x $depth, $file;
}

# dump lines of code per file sorted descending
print "\n t-SLOC File\n";
my @fileKeys = sort { $fileLines{$b}->[0] + $fileLines{$b}->[1] <=> $fileLines{$a}->[0] + $fileLines{$a}->[1] } keys %fileLines;
for(@fileKeys)
{
    printf "%6d %s\n", $fileLines{$_}->[0] + $fileLines{$_}->[1], $_;
}


  
