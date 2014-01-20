package Property;
require "Field.pl";
require "Utilities.pl";

sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_numFields => "0",
		_fields => [],
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub numFields { my $self = shift; return $self->{_numFields}; }
sub fields { my $self = shift; return @{$self->{_fields}}; }

sub addField {
	my $self = shift;

	my $field = Field->new(shift, shift);
	push(@{$self->{_fields}}, ($field));
	$self->{_numFields} += 1;
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

sub generateCplusplus {
	my $self = shift;
	my $cppFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($cppFile, $tablevel, "if (propertyName == \"".$self->name()."\") {");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\tif ((int)argv.size() < ".$self->numFields()."\) { return; }");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\tcomponent->".$self->name()."\(");
	my $count = 0;
	for my $field ($self->fields()) {
		printf $cppFile Utilities::getStringToDatatypeConverterForDatatype($field->datatype())."(argv[".$count."])";
		$count++;
		if ($count < $self->numFields()) {
			printf $cppFile ", ";
		}
	}
	printf $cppFile "\);";
	Utilities::printLineWithTabs($cppFile, $tablevel, "\treturn;");
	Utilities::printLineWithTabs($cppFile, $tablevel, "}");
}

1;

