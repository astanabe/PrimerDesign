use strict;
use File::Spec;
my $devnull = File::Spec->devnull();
my $forwardprimer;
my $reverseprimer;
my $output = 'raw';
my $inverse = 0;
my $allowerror = 0;

# get command line options
for (my $i = 0; $i < scalar(@ARGV); $i ++) {
	if ($ARGV[$i] =~ /^-+(?:fp|forwardprimer)=(.+)$/i) {
		$forwardprimer = $1;
	}
	elsif ($ARGV[$i] =~ /^-+(?:rp|reverseprimer)=(.+)$/i) {
		$reverseprimer = $1;
	}
	elsif ($ARGV[$i] =~ /^-+(?:o|output)=(.+)$/i) {
		$output = $1;
	}
	elsif ($ARGV[$i] =~ /^-+(?:ae|allowerror)=(\d+)$/i) {
		$allowerror = $1;
	}
	elsif ($ARGV[$i] =~ /^-+(?:i|inverse)$/i) {
		$inverse = 1;
	}
	else {
		&errorMessage(__LINE__, "\"$ARGV[$i]\" is unknown option.");
	}
}

if (!$forwardprimer && !$reverseprimer) {
	&errorMessage(__LINE__, 'Primer sequences are not given.');
}
if (!$forwardprimer) {
	$forwardprimer = 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN';
}
if (!$reverseprimer) {
	$reverseprimer = 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN';
}

if ($output !~ /^raw$/i && $output !~ /^fasta$/i) {
	&errorMessage(__LINE__, 'Output option is invalid.');
}

while (<STDIN>) {
	unless (/^#/) {
		my @entry = split(/ +\| +/);
		if (!$inverse && &pass($forwardprimer, $entry[13]) && &pass($reverseprimer, $entry[16]) || $inverse && (!&pass($forwardprimer, $entry[13]) || !&pass($reverseprimer, $entry[16]))) {
			if ($output =~ /^fasta$/i) {
				chomp($entry[21]);
				print('>' . $entry[0] . ' taxid=' . $entry[2] . '; ' . $entry[21] . "\n");
				print($entry[13] . $entry[20] . reversecomplement($entry[16]) . "\n");
			}
			elsif ($output =~ /^raw$/i) {
				print();
			}
		}
	}
}

sub pass {
	# 1: OK
	# 0: NG
	my $pattern1 = $_[0];
	my $pattern2 = $_[1];
	my $nerror = 0;
	for (my $i = 0; $i < length($pattern2); $i ++) {
		if (&testCompatibility(substr($pattern1, $i, 1), substr($pattern2, $i, 1))) {
			$nerror ++;
		}
	}
	my $pass = 1;
	if ($nerror > $allowerror) {
		$pass = 0;
	}
	return($pass);
}

sub testCompatibility {
	# 0: compatible
	# 1: incompatible
	my ($seq1, $seq2) = @_;
	my $compatibility = 0;
	if ($seq1 eq $seq2) {
		$compatibility = 0;
	}
	else {
		if ($seq1 eq 'A' && $seq2 =~ /^[CGTUSYKB]$/ ||
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
			$compatibility = 1;
		}
	}
	return($compatibility);
}

sub reversecomplement {
	my @temp = split('', $_[0]);
	my @seq;
	foreach my $seq (reverse(@temp)) {
		$seq =~ tr/ACGTMRYKVHDBacgtmrykvhdb/TGCAKYRMBDHVtgcakyrmbdhv/;
		push(@seq, $seq);
	}
	return(join('', @seq));
}

sub errorMessage {
	my $lineno = shift(@_);
	my $message = shift(@_);
	print("ERROR!: line $lineno\n$message\n");
	print("If you want to read help message, run this script without options.\n");
	exit(1);
}
