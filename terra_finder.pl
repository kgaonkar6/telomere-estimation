#lopezgarcg@email.chop.edu
#add to dockerhub
#!/usr/bin/perl

##  count reads containing telomeric repeats 
##

# Running terra_finder.pl
# perl terra_finder.pl fastq1 fastq2 out.txt

use strict;
use IO::Zlib;	# read gzipped files

#requires package
tie *FILE1, 'IO::Zlib', $ARGV[0], "rb";		# fastq1
tie *FILE2, 'IO::Zlib', $ARGV[1], "rb";		# fastq2
my $libsize=0;

# for every read pair we create a fingerprint representing the number of repeats (forward and reverse strands) in both reads
# the the fingerprint is used as the key for a hash with incremental values 
my %match;
do{ $libsize++; 
	my $r1=readline(FILE1);
	my $r2=readline(FILE2);
	my $line = ($libsize -2)/4;
	if($line  =~ /^-?\d+$/){
		#print "$line\t$r1";
		my $na1 = () = $r1 =~ /TTAGGG/gi;
		my $na2 = () = $r2 =~ /TTAGGG/gi;
		my $nb1 = () = $r1 =~ /CCCTAA/gi;
		my $nb2 = () = $r2 =~ /CCCTAA/gi;
		my $key1="$na1\_$nb1\_$na2\_$nb2";
		if(exists$match{$key1} ){$match{$key1}++;}
		else{$match{$key1} = 1;}
		}
	} until eof;

# print every fingerprint and the read count associated to it 
my @name=split(".",$ARGV[0]);
#added extension
my $outputfile=$name[0].".txt";
open(OUT, $outputfile);
foreach my$k(keys%match){
	print OUT $k,"\t",$match{$k},"\n";
	}
close (OUT);

END;

