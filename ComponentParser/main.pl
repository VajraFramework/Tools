#!/usr/bin/perl

use strict;
use warnings;
require "Field.pl";
require "Property.pl";
require "Component.pl";
require "Parser.pl";

my $parser = Parser->new();
$parser->parseHeaderFiles("../../", "Vajra");

my $component = Component->new("Transform");

my $property = Property->new("Translate");
$property->addField("x", "float");
$property->addField("y", "float");
$property->addField("z", "float");
$component->addProperty($property);

my $property2 = Property->new("SetPosition");
$property2->addField("x", "float");
$property2->addField("y", "float");
$property2->addField("z", "float");
$component->addProperty($property2);

$parser->addComponent($component);

$parser->debug_PrintComponents();

printf "\n\nDONE\n";

