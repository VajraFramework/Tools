package Field;
require "Utilities.pl";

sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_datatype => shift,
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub datatype { my $self = shift; return $self->{_datatype}; }

sub exportXml {
	my $self = shift;
	my $xmlFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($xmlFile, $tablevel, "<field name=\"".$self->name()."\" datatype=\"".$self->datatype()."\"></field>");
}

1;

