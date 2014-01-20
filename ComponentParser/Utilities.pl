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

sub getStringToDatatypeConverterForDatatype {
	my $datatype = shift;
	if ($datatype =~ /int/) {
		return "StringUtilities::ConvertStringToInt";
	}
	if ($datatype =~ /float/) {
		return "StringUtilities::ConvertStringToFloat";
	}
	if ($datatype =~ /bool/) {
		return "StringUtilities::ConvertStringToBool";
	}
	if ($datatype =~ /string/) {
		return "ConvertStringToString";
	}
}

1;

