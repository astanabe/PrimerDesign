local $/ = "\n>";
while (<>) {
	if (/^>?\s*(\S[^\r\n]*)\r?\n(.+)/s) {
		my $seqname = $1;
		my $sequence = uc($2);
		$sequence =~ s/[^A-Z]//g;
		if ($sequence =~ /N/) {
			next;
		}
		else {
			print(STDOUT ">$seqname\n$sequence\n");
		}
	}
}
