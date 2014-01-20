package Property;
require "Field.pl";
require "Utilities.pl";

sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_fields => [],
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub fields { my $self = shift; return @{$self->{_fields}}; }

sub addField {
	my $self = shift;

	my $field = Field->new(shift, shift);
	push(@{$self->{_fields}}, ($field));
}

# Debug functions:
sub debug_PrintFields {
	my $self = shift;

	for my $field ($self->fields()) {
		printf "\n\t\t".$field->name()." ".$field->datatype();
	}
}

sub exportXml {
	my $self = shift;
	my $xmlFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($xmlFile, $tablevel, "<property name=\"".$self->name()."\">");
	for my $field ($self->fields()) {
		$field->exportXml($xmlFile, $tablevel + 1);
	}
	Utilities::printLineWithTabs($xmlFile, $tablevel, "</property>");
}

1;

