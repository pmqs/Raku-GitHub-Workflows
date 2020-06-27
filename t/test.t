#!raku

use lib 'lib';

use Test;

plan 2;

use-ok('HelloWorld', 'Can load "HelloWorld"');

use HelloWorld;

is hello(), "Hello World", "Got Hello world";

done-testing();