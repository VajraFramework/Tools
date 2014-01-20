#!/usr/bin/perl

use strict;
use warnings;
require "Field.pl";
require "Property.pl";
require "Component.pl";
require "Parser.pl";

my $parser = Parser->new();
$parser->parseHeaderFiles("../../", "Vajra");
# $parser->debug_PrintComponents();
$parser->exportXml("../../ExampleGame/Resources/ComponentSpecifications/VajraComponents/Components.xml");

printf "\n\nDONE\n";

