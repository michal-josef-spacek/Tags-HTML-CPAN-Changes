use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::CPAN::Changes;
use Test::MockObject;
use Test::More 'tests' => 12;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::CPAN::Changes->new;
isa_ok($obj, 'Tags::HTML::CPAN::Changes');

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'css' => 'bad_css',
	);
};
is($EVAL_ERROR, "Parameter 'css' must be a 'CSS::Struct::Output::*' class.\n",
	"Parameter 'css' must be a 'CSS::Struct::Output::*' class (bad string).");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'css' => 0,
	);
};
is($EVAL_ERROR, "Parameter 'css' must be a 'CSS::Struct::Output::*' class.\n",
	"Parameter 'css' must be a 'CSS::Struct::Output::*' class (bad number).");
clean();

# Test.
my $test_obj = Test::MockObject->new;
eval {
	Tags::HTML::CPAN::Changes->new(
		'css' => $test_obj,
	);
};
is($EVAL_ERROR, "Parameter 'css' must be a 'CSS::Struct::Output::*' class.\n",
	"Parameter 'css' must be a 'CSS::Struct::Output::*' class (bad object).");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'css_class' => undef,
	);
};
is($EVAL_ERROR, "Parameter 'css_class' is required.\n",
	"Parameter 'css_class' is required.");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'css_class' => '1bad',
	);
};
is($EVAL_ERROR, "Parameter 'css_class' has bad CSS class name (number on begin).\n",
	"Parameter 'css_class' has bad CSS class name (number on begin) (1bad).");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'css_class' => '@bad',
	);
};
is($EVAL_ERROR, "Parameter 'css_class' has bad CSS class name.\n",
	"Parameter 'css_class' has bad CSS class name (\@bad).");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'tags' => 'bad_tags',
	);
};
is($EVAL_ERROR, "Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Parameter 'tags' must be a 'Tags::Output::*' class (bad string).");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'tags' => 0,
	);
};
is($EVAL_ERROR, "Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Parameter 'tags' must be a 'Tags::Output::*' class (bad number).");
clean();

# Test.
$test_obj = Test::MockObject->new;
eval {
	Tags::HTML::CPAN::Changes->new(
		'tags' => $test_obj,
	);
};
is($EVAL_ERROR, "Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Parameter 'tags' must be a 'Tags::Output::*' class (bad object)");
clean();

# Test.
eval {
	Tags::HTML::CPAN::Changes->new(
		'xxx' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'xxx'.\n",
	"Unknown parameter 'xxx'.");
clean();
