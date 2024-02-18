package Tags::HTML::CPAN::Changes;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use English;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_class'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class.
	$self->{'css_class'} = 'changes';

	# Process params.
	set_params($self, @{$object_params_ar});

	if (! defined $self->{'css_class'}) {
		err "Parameter 'css_class' is required.";
	}

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_changes'};

	return;
}

sub _init {
	my ($self, $changes) = @_;

	if (! defined $changes
		|| ! blessed($changes)
		|| ! $changes->isa('CPAN::Changes')) {

		err "Data object must be a 'CPAN::Changes' instance.";
	}

	$self->{'_changes'} = $changes;

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_changes'}) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_class'}],
	);
	foreach my $changes_rel (sort { $b->version <=> $a->version } $self->{'_changes'}->releases) {
		my $version = $changes_rel->version;
		if (defined $changes_rel->date) {
			$version .= ' - '.$changes_rel->date;
		}
		if (defined $changes_rel->note) {
			$version .= ' '.$changes_rel->note;
		}
		$self->{'tags'}->put(
			['b', 'div'],
			['a', 'class', 'version'],
			['b', 'h2'],
			['d', $version],
			['e', 'h2'],
		);
		$self->{'tags'}->put(
			['b', 'ul'],
			['a', 'class', 'changes'],
		);
		# TODO Rewrite to entries.
		foreach my $group ($changes_rel->group_values) {
			my $group_name = eval { $group->name };
			if (! $EVAL_ERROR && $group_name ne '') {
				$self->{'tags'}->put(
					['b', 'h3'],
					['d', '['.$group_name.']'],
					['e', 'h3'],
				);
			}
			foreach my $change (@{$group->changes}) {
				$self->{'tags'}->put(
					['b', 'li'],
					['a', 'class', 'change'],
					['d', $change],
					['e', 'li'],
				);
			}
		}
		$self->{'tags'}->put(
			['e', 'ul'],
		);
		$self->{'tags'}->put(
			['e', 'div'],
		);
	}
	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	if (! exists $self->{'_changes'}) {
		return;
	}

	$self->{'css'}->put(
		['s', '.'.$self->{'css_class'}],
		['d', 'max-width', '800px'],
		['d', 'margin', 'auto'],
		['d', 'background', '#fff'],
		['d', 'padding', '20px'],
		['d', 'border-radius', '8px'],
		['d', 'box-shadow', '0 2px 4px rgba(0, 0, 0, 0.1)'],
		['e'],

		['s', '.'.$self->{'css_class'}.' .version'],
		['d', 'border-bottom', '2px solid #eee'],
		['d', 'padding-bottom', '20px'],
		['d', 'margin-bottom', '20px'],
		['e'],

		['s', '.'.$self->{'css_class'}.' .version:last-child'],
		['d', 'border-bottom', 'none'],
		['e'],

		['s', '.'.$self->{'css_class'}.' .version h2'],
		['s', '.'.$self->{'css_class'}.' .version h3'],
		['d', 'color', '#007BFF'],
		['d', 'margin-top', 0],
		['e'],

		['s', '.'.$self->{'css_class'}.' .changes'],
		['d', 'list-style-type', 'none'],
		['d', 'padding-left', 0],
		['e'],

		['s', '.'.$self->{'css_class'}.' .change'],
		['d', 'background-color', '#f8f9fa'],
		['d', 'margin', '10px 0'],
		['d', 'padding', '10px'],
		['d', 'border-left', '4px solid #007BFF'],
		['d', 'border-radius', '4px'],
		['e'],
	);

	return;
}

1;

__END__
