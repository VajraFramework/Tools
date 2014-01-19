package Field;
sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_datatype => shift,
	};
	bless($self, $class);

	return $self;
}

# Accessors:
sub name { my $self = shift; return $self->{_name}; }
sub datatype { my $self = shift; return $self->{_datatype}; }

1;

