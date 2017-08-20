use File::Spec;
use strict;

my $inputfile = $ARGV[-2];
my $outputfile = $ARGV[-1];
my $numthreads = 1;
my $devnull = File::Spec->devnull();
my $inputhandle;
my $temphandle;
my $outhandle;
my $inhandle;

for (my $i = 0; $i < scalar(@ARGV) - 2; $i ++) {
	if ($ARGV[$i] =~ /^-+(?:n|n(?:um)?threads?)=(\d+)$/i) {
		$numthreads = $1;
	}
	else {
		&errorMessage(__LINE__, "\"$ARGV[$i]\" is unknown option.");
	}
}

my @seqnames;

unless (open($inputhandle, "< $inputfile")) {
	&errorMessage(__LINE__, "Cannot open \"$inputfile\".");
}
{
	local $/ = "\n>";
	my $tempno = 0;
	while (<$inputhandle>) {
		if (/^>?\s*(\S[^\r\n]*)\r?\n(.+)\r?\n/s) {
			my $seqname = $1;
			my $sequence = $2;
			$seqname =~ s/\s.+$//;
			$sequence =~ s/[> \r\n]//g;
			push(@seqnames, $seqname);
			open($temphandle, "> $outputfile.$tempno") or die;
			print($temphandle ">$seqname\n$sequence\n");
			close($temphandle);
			$tempno ++;
		}
	}
}
close($inputhandle);

open($temphandle, "> outfile") or die;
print($temphandle " ");
close($temphandle);

{
	my $child = 0;
	$| = 1;
	$? = 0;
	for (my $i = 0; $i < scalar(@seqnames) - 1; $i ++) {
		if (my $pid = fork()) {
			$child ++;
			if ($child == $numthreads) {
				if (wait == -1) {
					$child = 0;
				} else {
					$child --;
				}
			}
			if ($?) {
				&errorMessage(__LINE__);
			}
			next;
		}
		else {
			for (my $j = $i + 1; $j < scalar(@seqnames); $j ++) {
				if ($i == $j) {
					&errorMessage(__LINE__, "Error.");
					#unless (open($outhandle, ">> $outputfile")) {
					#	&errorMessage(__LINE__, "Cannot write a file.");
					#}
					#flock($outhandle, 2);
					#seek($outhandle, 0, 2);
					#print($outhandle "$seqnames[$i]\t$seqnames[$j]\t0\n");
					#close($outhandle);
				}
				else {
					# align by needle
					my $pipehandle;
					unless (open($pipehandle, "needle -gapopen 10 -gapextend 0.5 -aformat3 markx3 -warning N -error N -fatal N -die N -auto $outputfile.$i $outputfile.$j stdout |")) {
						&errorMessage(__LINE__, "Cannot align by needle.");
					}
					my $aln1;
					my $aln2;
					{
						my $switch;
						while (<$pipehandle>) {
							if ($switch == 1 && /^>/) {
								$switch = 2;
							}
							elsif (/^>/) {
								$switch = 1;
							}
							elsif ($switch == 2 && /^\r?\n?$/) {
								last;
							}
							elsif ($switch == 1 && /^\S+/) {
								$aln1 .= uc($&);
							}
							elsif ($switch == 2 && /^\S+/) {
								$aln2 .= uc($&);
							}
							elsif (!$switch) {
								next;
							}
						}
					}
					close($pipehandle);
					if (length($aln1) != length($aln2) || !$aln1 || !$aln2) {
						&errorMessage(__LINE__, "Cannot align correctly.\n$i : $seqnames[$i]\n$j : $seqnames[$j]");
					}
					# scrape end gaps
					#{
					#	$aln1 =~ /^-+/;
					#	my $flen = length($&);
					#	$aln2 =~ /^-+/;
					#	if (length($&) > $flen) {
					#		$flen = length($&);
					#	}
					#	for (my $k = 0; $k < $flen; $k ++) {
					#		my $temp = substr($aln1, 0, 1, '');
					#		$temp = substr($aln2, 0, 1, '');
					#	}
					#}
					#{
					#	$aln1 =~ /-+$/;
					#	my $tlen = length($&);
					#	$aln2 =~ /-+$/;
					#	if (length($&) > $tlen) {
					#		$tlen = length($&);
					#	}
					#	for (my $k = 0; $k < $tlen; $k ++) {
					#		my $temp = substr($aln1, -1, 1, '');
					#		$temp = substr($aln2, -1, 1, '');
					#	}
					#}
					# calc n-distance
					my $dist = 0;
					my $gap = 0;
					for (my $k = 0; $k < length($aln1); $k ++) {
						my $seq1 = substr($aln1, $k, 1);
						my $seq2 = substr($aln2, $k, 1);
						if ($gap == 1 && $seq1 eq '-' || $gap == 2 && $seq2 eq '-') {
							next;
						}
						elsif ($gap == 1 || $gap == 2) {
							$gap = 0;
						}
						elsif ($gap == 0 && $seq1 eq '-') {
							$gap = 1;
						}
						elsif ($gap == 0 && $seq2 eq '-') {
							$gap = 2;
						}
						if (&testCompatibility($seq1, $seq2) == 0) {
							$dist ++;
						}
					}
					# save to a file
					unless (open($outhandle, ">> $outputfile")) {
						&errorMessage(__LINE__, "Cannot write a file.");
					}
					flock($outhandle, 2);
					seek($outhandle, 0, 2);
					print($outhandle "$seqnames[$i]\t$seqnames[$j]\t$dist\n");
					#print($outhandle "$seqnames[$j]\t$seqnames[$i]\t$dist\n");
					close($outhandle);
				}
			}
			exit;
		}
	}
}

# join
while (wait != -1) {
	if ($?) {
		&errorMessage(__LINE__, 'Cannot align correctly.');
	}
}
print(STDERR "done.\n\n");

unlink("outfile");
for (my $i = 0; $i < scalar(@seqnames); $i ++) {
	unlink("$outputfile.$i");
}

# error message
sub errorMessage {
	my $lineno = shift(@_);
	my $message = shift(@_);
	print(STDERR "ERROR!: line $lineno\n$message\n");
	print(STDERR "If you want to read help message, run this script without options.\n");
	exit(1);
}

sub testCompatibility {
	# 0: incompatible
	# 1: compatible
	my ($seq1, $seq2) = @_;
	my $compatibility = 1;
	if ($seq1 ne $seq2) {
		if ($seq1 eq '-' && $seq2 ne '-' ||
			$seq1 ne '-' && $seq2 eq '-' ||
			$seq1 eq 'A' && $seq2 =~ /^[CGTUSYKB]$/ ||
			$seq1 eq 'C' && $seq2 =~ /^[AGTURWKD]$/ ||
			$seq1 eq 'G' && $seq2 =~ /^[ACTUMWYH]$/ ||
			$seq1 =~ /^[TU]$/ && $seq2 =~ /^[ACGMRSV]$/ ||
			$seq1 eq 'M' && $seq2 =~ /^[KGT]$/ ||
			$seq1 eq 'R' && $seq2 =~ /^[YCT]$/ ||
			$seq1 eq 'W' && $seq2 =~ /^[SCG]$/ ||
			$seq1 eq 'S' && $seq2 =~ /^[WAT]$/ ||
			$seq1 eq 'Y' && $seq2 =~ /^[RAG]$/ ||
			$seq1 eq 'K' && $seq2 =~ /^[MAC]$/ ||
			$seq1 eq 'B' && $seq2 eq 'A' ||
			$seq1 eq 'D' && $seq2 eq 'C' ||
			$seq1 eq 'H' && $seq2 eq 'G' ||
			$seq1 eq 'V' && $seq2 =~ /^[TU]$/) {
			$compatibility = 0;
		}
	}
	return($compatibility);
}
