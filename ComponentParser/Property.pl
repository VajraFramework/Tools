package Property;
require "Field.pl";

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

	printf "\nDEBUG: Printing fields: ";

	for my $field ($self->fields()) {
		printf "\n\t".$field->name()." ".$field->datatype();
	}
}

1;

