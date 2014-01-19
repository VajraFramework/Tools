package Component;
require "Property.pl";

sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_properties => [],
		_pathToHeaderFile => "",
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub properties { my $self = shift; return @{$self->{_properties}}; }
sub pathToHeaderFile { my $self = shift; return $self->{_pathToHeaderFile}; }

sub addProperty {
	my $self = shift;

	# my $property = Property->new(shift);
	my $property = shift;
	push(@{$self->{_properties}}, ($property));
}

sub setPathToHeaderFile {
	my $self = shift;
	$self->{_pathToHeaderFile} = shift;
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

