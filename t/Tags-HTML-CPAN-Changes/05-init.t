use strict;
use warnings;

use CPAN::Changes;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::CPAN::Changes;
use Test::MockObject;
use Test::More 'tests' => 5;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::CPAN::Changes->new;
my $changes = CPAN::Changes->new(
        'preamble' => 'Revision history for perl module Foo::Bar',
);
my $ret = $obj->init($changes);
is($ret, undef, 'Init returns undef.');

# Test.
$obj = Tags::HTML::CPAN::Changes->new;
eval {
	$obj->init;
};
is($EVAL_ERROR, "Data object must be a 'CPAN::Changes' instance.\n",
	"Data object must be a 'CPAN::Changes' instance (undef).");
clean();

# Test.
$obj = Tags::HTML::CPAN::Changes->new;
eval {
	$obj->init(Test::MockObject->new);
};
is($EVAL_ERROR, "Data object must be a 'CPAN::Changes' instance.\n",
	"Data object must be a 'CPAN::Changes' instance (object).");
clean();

# Test.
$obj = Tags::HTML::CPAN::Changes->new;
eval {
	$obj->init('bad');
};
is($EVAL_ERROR, "Data object must be a 'CPAN::Changes' instance.\n",
	"Data object must be a 'CPAN::Changes' instance (string).");
clean();
