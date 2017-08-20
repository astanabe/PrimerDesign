my ($primer, $cutoff, $error, $sourcefile, $pcroutfile) = ($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4]);

my $all = 0;
open(IN, "< $sourcefile") or die();
while (<IN>) {
	if (/^>/) {
		$all ++;
	}
}
close(IN);

my $success = 0;
open(IN, "< $pcroutfile") or die();
while (<IN>) {
	my @entry = split(/ +\| +/);
	if (scalar(@entry) == 22) {
		$success ++;
	}
}
close(IN);

print(STDOUT "$primer,$cutoff,$error,$all,$success\n");
