while (<>) {
	unless (/^#/) {
		my @entry = split(/ +\| +/);
		my $seq = $entry[13] . $entry[20] . reversecomplement($entry[16]);
		if ($seq !~ /N{5,}/i) {
			print();
		}
	}
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
