# Pragmas.
use strict;
use warnings;
use utf8;

# Modules.
use Encode qw(encode_utf8);
use English;
use Map::Tube::Sofia;
use Test::More tests => 7;
use Test::NoWarnings;

# Test.
my $map = Map::Tube::Sofia->new;
eval {
	$map->get_shortest_route;
};
like($EVAL_ERROR, qr/ERROR: Either FROM\/TO node is undefined/,
	'Either FROM/TO node is undefined');

# Test.
eval {
	$map->get_shortest_route('Foo');
};
like($EVAL_ERROR, qr/ERROR: Either FROM\/TO node is undefined/,
	'Either FROM/TO node is undefined');

# Test.
eval {
	$map->get_shortest_route('Foo', 'Bar');
};
like(
	$EVAL_ERROR,
	qr/\QMap::Tube::get_shortest_route(): ERROR: Received invalid FROM node 'Foo'\E/,
	"Received invalid FROM node 'Foo'.",
);

# Test.
eval {
	$map->get_shortest_route('Сердика', 'Foo');
};
like(
	$EVAL_ERROR,
	qr/\QMap::Tube::get_shortest_route(): ERROR: Received invalid TO node 'Foo'\E/,
	"Received invalid TO node 'Foo'.",
);

# Test.
my $ret = $map->get_shortest_route('Ломско шосе','Сливница');
my $right_ret = encode_utf8('Ломско шосе (Втори метродиаметър), Обеля '.
	'(Първи метродиаметър,Втори метродиаметър), '.
	'Сливница (Първи метродиаметър)');
is($ret, $right_ret, encode_utf8("Shortest route from 'Ломско шосе' to 'Сливница'."));

# Test.
$ret = $map->get_shortest_route('Сливница', 'Ломско шосе');
$right_ret = encode_utf8('Сливница (Първи метродиаметър), Обеля '.
	'(Първи метродиаметър,Втори метродиаметър), '.
	'Ломско шосе (Втори метродиаметър)');
is($ret, $right_ret, encode_utf8("Shortest route from 'Сливница' to 'Ломско шосе'."));
