my ($primer, $cutoff, $distfile) = ($ARGV[0], $ARGV[1], $ARGV[2]);

open(IN, "< $distfile") or die();
while (<IN>) {
	if (/^[^\t]+\t[^\t]+\t(\d+)/) {
		print(STDOUT "$primer,$cutoff,$1\n");
	}
}
close(IN);
