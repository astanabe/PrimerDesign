while (<>) {
	if (/^>(\d+)/) {
		my $gi = $1;
		my $taxid = `blastdbcmd -out - -entry $gi -db ~/blastdb/nt -target_only -outfmt \%T`;
		$taxid =~ s/\r?\n?$//;
		my $title = `blastdbcmd -out - -entry $gi -db ~/blastdb/nt -target_only -outfmt \%t`;
		$title =~ s/\r?\n?$//;
		print(">$gi taxid=$taxid; $title\n");
	}
	else {
		print($_);
	}
}
