package Component;
require "Property.pl";
require "Utilities.pl";

sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_properties => [],
		_includePathToHeaderFile => "",
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub properties { my $self = shift; return @{$self->{_properties}}; }
sub includePathToHeaderFile { my $self = shift; return $self->{_includePathToHeaderFile}; }

sub addProperty {
	my $self = shift;

	# my $property = Property->new(shift);
	my $property = shift;
	push(@{$self->{_properties}}, ($property));
}

sub setIncludePathToHeaderFile {
	my $self = shift;
	$self->{_includePathToHeaderFile} = shift;
}

sub exportXml {
	my $self = shift;
	my $xmlFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($xmlFile, $tablevel, "");
	Utilities::printLineWithTabs($xmlFile, $tablevel, "<component name=\"".$self->name()."\" includePath=\"".$self->includePathToHeaderFile()."\">");
	for my $property ($self->properties()) {
		$property->exportXml($xmlFile, $tablevel + 1);
	}
	Utilities::printLineWithTabs($xmlFile, $tablevel, "</component>");
}

# Debug functions:
sub debug_PrintProperties {
	my $self = shift;

	for my $property ($self->properties()) {
		printf "\n\t".$property->name();
		$property->debug_PrintFields();
	}
}

1;

