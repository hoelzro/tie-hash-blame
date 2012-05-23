## no critic (RequireUseStrict)
package Tie::Hash::Blame;

## use critic (RequireUseStrict)
use strict;
use warnings;
require Tie::Hash;
use parent '-norequire', 'Tie::ExtraHash';

sub TIEHASH {
    my ( $class ) = @_;

    return bless [
        {}, # key/value storage
        {}, # history storage
    ], $class;
}

sub _storage {
    my ( $self ) = @_;

    return $self->[0];
}

sub _history {
    my ( $self ) = @_;

    return $self->[1];
}

sub STORE {
    my ( $self, $key, $value ) = @_;

    my $storage = $self->_storage;
    my $history = $self->_history;

    $storage->{$key} = $value;

    my ( undef, $filename, $line_no ) = caller;
    $history->{$key} = {
        filename => $filename,
        line_no  => $line_no,
    };

    return $value;
}

sub blame {
    my ( $self ) = @_;

    my $history = $self->_history;
    my %copy;

    foreach my $k (keys %$history) {
        my $v = $history->{$k};

        $copy{$k} = { %$v };
    }

    return \%copy;
}

1;

__END__

# ABSTRACT: A short description of Tie::Hash::Blame

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=head1 SEE ALSO

=cut
