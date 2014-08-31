package App::MusicBox::Input;
use 5.012;
use strict;
use warnings;

use if $^O eq "MSWin32", "Win32::Console::ANSI";
use Term::ReadKey;

eval 'END { ReadMode "normal" }';
eval 'ReadMode "cbreak"';


sub read_key {
	state @keys;

	if (@keys) {
		return shift @keys;
	}

	my $char;
	my $packet = '';
	while (defined($char = ReadKey -1)) {
		$packet .= $char;
	}

	while ($packet =~ m(
		\G(
			\e \[          # CSI
			[\x30-\x3f]*   # Parameter Bytes
			[\x20-\x2f]*   # Intermediate Bytes
			[\x40-\x7e]    # Final Byte
		|
			.              # Otherwise just any character
		)
	)gsx) {
		push @keys, $1;
	}
	return shift @keys;
}

sub key_to_cmd {
    my $key = shift;
    my $cmd = '';
    if ( $key eq "\e[A" ){
        $cmd = 'up';
    }
    if ( $key eq "\e[B" ){
        $cmd = 'down';
    }
    if ( $key eq " " ){
        $cmd = 'play/pause';
    }
    if ( $key eq 'q' ){
        $cmd = 'quit';
    }
    if ( $key eq "\n" ){
        $cmd = 'enter';
    }
    return $cmd;
}
1;

