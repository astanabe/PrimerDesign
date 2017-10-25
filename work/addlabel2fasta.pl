my $output = 0;
while (<>) {
	if (/^>/ && (/gi\|(\d+)/ || /^>(\d+)/)) {
		my $gi = $1;
		my $taxid = `blastdbcmd -out - -entry $gi -db ~/blastdb/nt -target_only -outfmt \%T`;
		$taxid =~ s/\r?\n?$//;
		my $title = `blastdbcmd -out - -entry $gi -db ~/blastdb/nt -target_only -outfmt \%t`;
		$title =~ s/\r?\n?$//;
		if ($gi && $taxid && $title) {
			print(">$gi taxid=$taxid; $title\n");
			$output = 1;
		}
		else {
			$output = 0;
		}
	}
	elsif (/^>/ && (/^>([A-Z]+\d+\.\d+)/)) {
		my $accver = $1;
		my $gi = `blastdbcmd -out - -entry $accver -db ~/blastdb/nt -target_only -outfmt \%g`;
		$gi =~ s/\r?\n?$//;
		my $taxid = `blastdbcmd -out - -entry $accver -db ~/blastdb/nt -target_only -outfmt \%T`;
		$taxid =~ s/\r?\n?$//;
		my $title = `blastdbcmd -out - -entry $accver -db ~/blastdb/nt -target_only -outfmt \%t`;
		$title =~ s/\r?\n?$//;
		if ($gi && $taxid && $title) {
			print(">$gi taxid=$taxid; $title\n");
			$output = 1;
		}
		else {
			$output = 0;
		}
	}
	elsif ($output) {
		print($_);
	}
}
