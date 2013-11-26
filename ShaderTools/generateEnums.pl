#!/usr/bin/perl

################################################################################
# Sub routines:

sub uniq {
	    return keys %{{ map { $_ => 1 } @_ }};
    }

################################################################################


$SHADERS_PATH = "../../Resources/shaders/";
$SHADER_VARIABLES_FILEPATH = $SHADERS_PATH . "shader_variables";

$TARGET_PATH = "../../Vajra/Framework/OpenGL/ShaderHandles/";
$ENUM_HEADER_FILE_PATH = $TARGET_PATH . "Declarations.h";
$ENUM_SOURCE_FILE_PATH = $TARGET_PATH . "Declarations.cpp";

printf "\nShaders variables file: $SHADER_VARIABLES_FILEPATH";
printf "\nShader variables:\n";

open(FILE_SHADER_VARIABLES, $SHADER_VARIABLES_FILEPATH);
@variable_declarations = <FILE_SHADER_VARIABLES>;
close(FILE_SHADER_VARIABLES);

foreach $declaration (@variable_declarations) {
	chomp($declaration);
	if ($declaration =~ /^(\w*)\s+(\w*)\s+(\w*)\s*$/) {
		printf "\n> $declaration";
		push(@qualifiers, $1);
		push(@datatypes, $2);
		push(@variablenames, $3);
	}
}

printf "\n\nUnique qualifiers found:";
@uniq_qualifiers = uniq(@qualifiers);
push(@uniq_qualifiers, "invalid");
foreach $word(@uniq_qualifiers) {
	printf "\n> $word";
}

printf "\n\nUnique datatypes found:";
@uniq_datatypes = uniq(@datatypes);
push(@uniq_datatypes, "invalid");
foreach $word(@uniq_datatypes) {
	printf "\n> $word";
}

push(@variablenames, "invalid");


################################################################################
# Writing enums:

printf "\nWriting enums to files: $ENUM_HEADER_FILE_PATH and $ENUM_SOURCE_FILE_PATH\n";
open($FILE_ENUM_HEADER, ">$ENUM_HEADER_FILE_PATH");
open($FILE_ENUM_SOURCE, ">$ENUM_SOURCE_FILE_PATH");


################################################################################
# Writing enum header file:

$headerheadfill = <<END;
#ifndef SHADER_HANDLES_DECLARATIONS_H
#define SHADER_HANDLES_DECLARATIONS_H

#include <string>

/*
 * NOTE: When any of shader variables in shader_variables are modified, this file has to be regenerated by running generateEnums.pl in Tools/ShaderTools/
 */

END

print $FILE_ENUM_HEADER "$headerheadfill";

$PREFIX_QUALIFIER = "SHADER_VARIABLE_QUALIFIER_";
$PREFIX_DATATYPE = "SHADER_VARIABLE_DATATYPE_";
$PREFIX_VARIABLENAME = "SHADER_VARIABLE_VARIABLENAME_";

# Writing enum of qualifiers:
print $FILE_ENUM_HEADER "\nenum Shader_variable_qualifier_t {";
foreach $qualifier(@uniq_qualifiers) {
	$enumvalue = $PREFIX_QUALIFIER.$qualifier.",";
	print $FILE_ENUM_HEADER "\n\t$enumvalue";
}
print $FILE_ENUM_HEADER "\n};\n";


# Writing enum of datatypes:
print $FILE_ENUM_HEADER "\nenum Shader_variable_datatype_t {";
foreach $datatype(@uniq_datatypes) {
	$enumvalue = $PREFIX_DATATYPE.$datatype.",";
	print $FILE_ENUM_HEADER "\n\t$enumvalue";
}
print $FILE_ENUM_HEADER "\n};\n";


# Writing enum of variablenames:
print $FILE_ENUM_HEADER "\nenum Shader_variable_variablename_id_t {";
foreach $variablename(@variablenames) {
	$enumvalue = $PREFIX_VARIABLENAME.$variablename.",";
	print $FILE_ENUM_HEADER "\n\t$enumvalue";
}
print $FILE_ENUM_HEADER "\n};\n";

$headertailfill = <<END;

Shader_variable_qualifier_t GetShaderVariableQualifierFromString(std::string s);
Shader_variable_datatype_t GetShaderVariableDatatypeFromString(std::string s);
Shader_variable_variablename_id_t GetShaderVariableVariableNameIdFromString(std::string s);

std::string GetStringForShaderVariableQualifier(Shader_variable_qualifier_t t);
std::string GetStringForShaderVariableDatatype(Shader_variable_datatype_t t);
std::string GetStringForShaderVariableVariableNameId(Shader_variable_variablename_id_t t);

#endif // SHADER_HANDLES_DECLARATIONS_H

END

print $FILE_ENUM_HEADER "$headertailfill";

close($FILE_ENUM_HEADER);

################################################################################
# Writing enum source file:


$sourceheadfill = <<END;
#include "Vajra/Framework/OpenGL/ShaderHandles/Declarations.h"

END

print $FILE_ENUM_SOURCE "$sourceheadfill";

$fill = <<END;
Shader_variable_qualifier_t GetShaderVariableQualifierFromString(std::string s) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $qualifier(@uniq_qualifiers) {
	print $FILE_ENUM_SOURCE "\n\tif (s == \"$qualifier\") {";
	print $FILE_ENUM_SOURCE "\n\t\treturn $PREFIX_QUALIFIER".$qualifier.";";
	print $FILE_ENUM_SOURCE "\n\t}";
}
print $FILE_ENUM_SOURCE "\n\treturn $PREFIX_QUALIFIER"."invalid".";";
print $FILE_ENUM_SOURCE "\n}\n\n";


$fill = <<END;
Shader_variable_datatype_t GetShaderVariableDatatypeFromString(std::string s) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $datatype(@uniq_datatypes) {
	print $FILE_ENUM_SOURCE "\n\tif (s == \"$datatype\") {";
	print $FILE_ENUM_SOURCE "\n\t\treturn $PREFIX_DATATYPE".$datatype.";";
	print $FILE_ENUM_SOURCE "\n\t}";
}
print $FILE_ENUM_SOURCE "\n\treturn $PREFIX_DATATYPE"."invalid".";";
print $FILE_ENUM_SOURCE "\n}\n\n";


$fill = <<END;
Shader_variable_variablename_id_t GetShaderVariableVariableNameIdFromString(std::string s) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $variablename(@variablenames) {
	print $FILE_ENUM_SOURCE "\n\tif (s == \"$variablename\") {";
	print $FILE_ENUM_SOURCE "\n\t\treturn $PREFIX_VARIABLENAME".$variablename.";";
	print $FILE_ENUM_SOURCE "\n\t}";
}
print $FILE_ENUM_SOURCE "\n\treturn $PREFIX_VARIABLENAME"."invalid".";";
print $FILE_ENUM_SOURCE "\n}\n\n";



$fill = <<END;
std::string GetStringForShaderVariableQualifier(Shader_variable_qualifier_t t) {
	switch (t) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $qualifier(@uniq_qualifiers) {
	print $FILE_ENUM_SOURCE "\n\tcase $PREFIX_QUALIFIER".$qualifier.": return \"".$qualifier."\";";
}
print $FILE_ENUM_SOURCE "\n\t// default: DO NOT ADD A DEFAULT HERE. It'll help catch the case where the enum is extended but not handled here";
print $FILE_ENUM_SOURCE "\n\t}";
print $FILE_ENUM_SOURCE "\n\treturn "."\"invalid\"".";";
print $FILE_ENUM_SOURCE "\n}\n\n";


$fill = <<END;
std::string GetStringForShaderVariableDatatype(Shader_variable_datatype_t t) {
	switch (t) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $datatype(@uniq_datatypes) {
	print $FILE_ENUM_SOURCE "\n\tcase $PREFIX_DATATYPE".$datatype.": return \"".$datatype."\";";
}
print $FILE_ENUM_SOURCE "\n\t// default: DO NOT ADD A DEFAULT HERE. It'll help catch the case where the enum is extended but not handled here";
print $FILE_ENUM_SOURCE "\n\t}";
print $FILE_ENUM_SOURCE "\n\treturn "."\"invalid\"".";";
print $FILE_ENUM_SOURCE "\n}\n\n";


$fill = <<END;
std::string GetStringForShaderVariableVariableNameId(Shader_variable_variablename_id_t t) {
	switch (t) {
END
print $FILE_ENUM_SOURCE "$fill";
foreach $variablename(@variablenames) {
	print $FILE_ENUM_SOURCE "\n\tcase $PREFIX_VARIABLENAME".$variablename.": return \"".$variablename."\";";
}
print $FILE_ENUM_SOURCE "\n\t// default: DO NOT ADD A DEFAULT HERE. It'll help catch the case where the enum is extended but not handled here";
print $FILE_ENUM_SOURCE "\n\t}";
print $FILE_ENUM_SOURCE "\n\treturn "."\"invalid\"".";";
print $FILE_ENUM_SOURCE "\n}\n\n";

close($FILE_ENUM_SOURCE);

################################################################################

printf "\nDONE\n";
