while (<>) {
	if (/^([ACGTMRYKVHDBacgtmrykvhdb]+)(\r?\n?)$/) {
		print(STDOUT &reversecomplement($1) . $2);
	}
	else {
		print(STDOUT $_);
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
