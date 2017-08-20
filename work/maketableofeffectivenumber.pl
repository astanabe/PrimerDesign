my ($primer, $cutoff, $seqfile) = ($ARGV[0], $ARGV[1], $ARGV[2]);

my $num = 0;
open(IN, "< $seqfile") or die();
while (<IN>) {
	if (/^>/) {
		$num ++;
	}
}
close(IN);

print(STDOUT "$primer,$cutoff,$num\n");
