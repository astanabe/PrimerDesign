while (<>) {
	unless (/^#/) {
		my @entry = split(/ +\| +/);
		chomp($entry[21]);
		print('>' . $entry[0] . ' taxid=' . $entry[2] . '; ' . $entry[21] . "\n");
		print($entry[16] . "\n");
	}
}
