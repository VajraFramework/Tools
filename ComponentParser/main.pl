#!/usr/bin/perl

use strict;
use warnings;
require "Field.pl";
require "Property.pl";
require "Component.pl";
require "Parser.pl";

my $parser = Parser->new();
$parser->parseHeaderFiles("../../", "Vajra");
$parser->parseHeaderFiles("../../ExampleGame/Code/", "ExampleGame");
# $parser->debug_PrintComponents();
$parser->exportXml("../../ExampleGame/Resources/ComponentSpecifications/Components.xml");
$parser->generateCplusplus("../../ExampleGame/Code/ExampleGame/ComponentMapper/ComponentMapper.cpp");

printf "\n\nDONE\n";

