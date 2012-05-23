use strict;
use warnings;

use Tie::Hash::Blame;
use Test::More tests => 4;

sub last_line {
    my ( undef, undef, $line ) = caller();
    return $line - 1;
}

my %hash;
my $history;
my %expected_lines;
my $filename = __FILE__;

tie %hash, 'Tie::Hash::Blame';

EMPTY_HISTORY: {
    $history = tied(%hash)->blame;
    is_deeply $history, {};
}

$hash{'foo'}           = 17;
$expected_lines{'foo'} = last_line();

SINGLE_ITEM_HISTORY: {
    $history = tied(%hash)->blame;
    is_deeply $history, {
        foo => {
            filename => $filename,
            line_no  => $expected_lines{'foo'},
        },
    };
}

$hash{'bar'}           = 18;
$expected_lines{'bar'} = last_line();

MULTI_ITEM_HISTORY: {
    $history = tied(%hash)->blame;
    is_deeply $history, {
        foo => {
            filename => $filename,
            line_no  => $expected_lines{'foo'},
        },
        bar => {
            filename => $filename,
            line_no  => $expected_lines{'bar'},
        },
    };
}

$hash{'foo'}           = 19;
$expected_lines{'foo'} = last_line();

HISTORY_OVERWRITE: {
    $history = tied(%hash)->blame;
    is_deeply $history, {
        foo => {
            filename => $filename,
            line_no  => $expected_lines{'foo'},
        },
        bar => {
            filename => $filename,
            line_no  => $expected_lines{'bar'},
        },
    };
}
