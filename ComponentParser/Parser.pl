package Parser;
require "Component.pl";
use File::Find;

sub new {
	my $class = shift;
	my $self = {
		_pathToDirectoryContainingSourceFiles => "",
		_directoryContainingSourceFiles => "",
		_components => [],
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub components { my $self = shift; return @{$self->{_components}}; }

sub addComponent {
	my $self = shift;

	my $component = shift;
	push(@{$self->{_components}}, ($component));
}

my @temp_allFiles;

sub parseHeaderFiles {
	my $self = shift;
	$self->{_pathToDirectoryContainingSourceFiles} = shift;
	$self->{_directoryContainingSourceFiles} = shift;
	printf "\nParsing source files under ".$self->{_pathToDirectoryContainingSourceFiles}.$self->{_directoryContainingSourceFiles}."/\n";

	@temp_allFiles = ();
	find(\&wanted_header_files, $self->{_pathToDirectoryContainingSourceFiles}.$self->{_directoryContainingSourceFiles});
	for $file (@temp_allFiles) {
		$self->parseHeaderFile($file);
	}
}

sub wanted_header_files { 
	my $fileName = $File::Find::name;
	if ($fileName =~ /.*\.h$/) {
		push(@temp_allFiles, $fileName);
	}
}

sub parseHeaderFile {
	my $self = shift;
	my $filePath = shift;
	# printf "\nLooking at source file: ".$filePath;

	open(HEADER_FILE, $filePath) or die "\n! Unable to open file $filePath";
	@lines = <HEADER_FILE>;
	close(HEADER_FILE);

	for $line (@lines) {
		if ($line =~ /\Q\/\/[[COMPONENT]]\/\/\E/) {
			printf "\nFound a Component in header file: ".$filePath."\n";
			$self->parseComponentHeaderFile($filePath);
		}
	}
}

sub parseComponentHeaderFile {
	my $self = shift;
	my $filePath = shift;

	open(HEADER_FILE, $filePath) or die "\n! Unable to open file $filePath";
	@lines = <HEADER_FILE>;
	close(HEADER_FILE);

	# Find the Component class declaration to find the name:
	my $componentName;
	#
	my $lineNumber = 0;
	for $line (@lines) {
		if ($line =~ /\Q\/\/[[COMPONENT]]\/\/\E/) {
			my $componentDeclarationLine = $lines[$lineNumber + 1];
			if ($componentDeclarationLine =~ /class\s*(\w+)\s*\:.*public.*/) {
				$componentName = $1;
				printf "\nComponent name: ".$componentName;
			} else {
				die "\n! Malformed line when looking for COMPONENT in: ".$componentDeclarationLine;
			}
		}
		$lineNumber += 1;
	}

	# Create the new Component:
	my $component = Component->new($componentName);
	$component->setPathToHeaderFile($filePath);


	# Find all the properties of the Component:
	$lineNumber = 0;
	for $line (@lines) {
		if ($line =~ /\Q\/\/[[PROPERTY]]\/\/\E/) {
			my $propertyDeclarationsLine = $lines[$lineNumber + 1];
			if ($propertyDeclarationsLine =~ /(\w+)\s*\((.*)\)\;/) {
				my $propertyName = $1;
				my $propertyFieldsLine = $2;
				addPropertyToComponent($component, $propertyName, $propertyFieldsLine);
			} else {
				die "\n! Malformed line when looking for PROPERTY in: ".$propertyDeclarationsLine;
			}
		}
		$lineNumber += 1;
	}

	# Add Component to Parser:
	$self->addComponent($component);
}

sub addPropertyToComponent {
	my $component = shift;
	my $propertyName = shift;
	my $propertyFieldsLine = shift;

	# Create a new Property:
	my $property = Property->new($propertyName);

	# Find the fields:
	@fieldDeclarations = split(/,/, $propertyFieldsLine);
	for my $fieldDeclaration (@fieldDeclarations) {
		if ($fieldDeclaration =~ /^\s*(.+)\s+(\w+)\s*$/) {
			my $fieldDatatype = $1;
			my $fieldName = $2;
			if ($fieldDatatype =~ /\*/) {
				die "\n! Malformed field datatype: $fieldDatatype";
			}
			$property->addField($fieldName, $fieldDatatype);
		} else {
			die "\n! Malformed line when looking for field in: ".$fieldDeclaration;
		}
	}

	# Add the property to the Component:
	$component->addProperty($property);
}

sub exportXml {
	my $self = shift;
	my $pathToExportFile = shift;

	open my $xmlFile, '>', $pathToExportFile or die "\n! Couldn't open output xml file";

	printf $xmlFile "\n<components>";
	for my $component ($self->components()) {
		$component->exportXml($xmlFile, 1);

	}
	printf $xmlFile "\n</components>";
}

# Debug functions:
sub debug_PrintComponents {
	my $self = shift;

	printf "\nDEBUG: Printing components: ";

	for my $component ($self->components()) {
		printf "\n\nComponent name: ".$component->name();
		printf $component->debug_PrintProperties();
		printf "\n";
	}
}

1;

