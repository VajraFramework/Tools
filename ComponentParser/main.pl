#!/usr/bin/perl

use strict;
use warnings;
require "Field.pl";
require "Property.pl";
require "Component.pl";
require "Parser.pl";

my $vajraParser = Parser->new();
$vajraParser->parseHeaderFiles("../../", "Vajra");
# $vajraParser->debug_PrintComponents();
$vajraParser->exportXml("../../ExampleGame/Resources/ComponentSpecifications/VajraComponents/Components.xml");

my $gameParser = Parser->new();
$gameParser->parseHeaderFiles("../../ExampleGame/Code/", "ExampleGame");
# $gameParser->debug_PrintComponents();
$gameParser->exportXml("../../ExampleGame/Resources/ComponentSpecifications/GameComponents/Components.xml");

printf "\n\nDONE\n";

