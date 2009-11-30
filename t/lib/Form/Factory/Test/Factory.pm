package Form::Factory::Test::Factory;
use Test::Able::Role;
use Test::More;
use Test::Moose;

has name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has class_name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 1,
    default   => sub { 'Form::Factory::Factory::' . shift->name },
);

has factory_options => (
    is        => 'ro',
    does      => 'HashRef',
    required  => 1,
    lazy      => 1,
    default   => sub { {} },
);

has factory => (
    is        => 'ro',
    does      => 'Form::Factory::Factory',
    required  => 1,
    lazy      => 1,
    default   => sub { 
        my $self = shift;
        Form::Factory->new_factory($self->name, $self->factory_options);
    },
);

test plan => 4, factory_ok => sub { 
    my $self = shift;

    my $factory = $self->factory;
    ok($factory, "got a factory for " . $self->name);
    isa_ok($factory, $self->class_name);
    does_ok($factory, 'Form::Factory::Factory');
    can_ok($factory, qw( render_control consume_control ));
};

1;
