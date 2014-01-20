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

sub generateCplusplusForComponentName {
	my $self = shift;
	my $cppFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($cppFile, $tablevel, "");
	Utilities::printLineWithTabs($cppFile, $tablevel, "if \(componentName == \"".$self->name()."\"\) \{");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\t".$self->name()."\* component = gameObject->GetComponent\<".$self->name()."\>\(\)\;");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\tif \(component == nullptr) { component = gameObject->AddComponent<".$self->name().">\(\); \}");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\treturn component;");
	Utilities::printLineWithTabs($cppFile, $tablevel, "}");
}

sub generateCplusplusForProperties {
	my $self = shift;
	my $cppFile = shift;
	my $tablevel = shift;

	Utilities::printLineWithTabs($cppFile, $tablevel, "");
	Utilities::printLineWithTabs($cppFile, $tablevel, "if (componentName == \"".$self->name()."\") {");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\t".$self->name()."\* component = gameObject->GetComponent<".$self->name().">\(\);");
	Utilities::printLineWithTabs($cppFile, $tablevel, "\tif (component == nullptr) { return; }");
	for my $property ($self->properties()) {
		$property->generateCplusplus($cppFile, $tablevel + 1);
	}
	Utilities::printLineWithTabs($cppFile, $tablevel, "\treturn;");
	Utilities::printLineWithTabs($cppFile, $tablevel, "}");
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

