package Utilities;
sub printLineWithTabs {
	my $fileHandle = shift;
	my $numTabs = shift;
	my $content = shift;

	printf $fileHandle "\n";
	for (my $count = 0; $count < $numTabs; $count++) {
		printf $fileHandle "\t";
	}
	printf $fileHandle $content;
}

1;

