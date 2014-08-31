package App::MusicBox;
# ABSTRACT: main app
use 5.012;
use warnings;
use strict;
use Moo;

use App::MusicBox::Input;
sub run {
    my $self = shift;

    my $quit = 0;
    while ( ! $quit ) {
        while ( my $key = App::MusicBox::Input::read_key() ) {
            my $cmd = App::MusicBox::Input::key_to_cmd($key);
            say $cmd;
        }
#        $ui->draw;
    }
}

1;
