package App::MusicBox;
# ABSTRACT: main app
use 5.012;
use warnings;
use strict;
use Moo;

use App::MusicBox::Input;
use App::MusicBox::Control;
use App::MusicBox::UI;

sub run {
    my $self = shift;

    my $c  = App::MusicBox::Control->new();
    my $ui = App::MusicBox::UI->new();
    $ui->draw_menu;
    my $quit = 0;
    while ( ! $quit ) {
        while ( my $key = App::MusicBox::Input::read_key() ) {
            my $cmd = App::MusicBox::Input::key_to_cmd($key);
            if ( $cmd eq 'up' ) {
                next;
            }
        }
    }
}

1;
