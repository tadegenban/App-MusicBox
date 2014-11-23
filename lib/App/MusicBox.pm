package App::MusicBox;
# ABSTRACT: main app
our $VERSION = 0.001;
use 5.012;
use warnings;
use strict;

use Time::HiRes;

use Moo;

use App::MusicBox::Input;
use App::MusicBox::Control;
use App::MusicBox::UI;


sub run {
    my $self = shift;

    my $c  = App::MusicBox::Control->new();
    $c->init;
    my $quit = 0;
  RUN:
    while ( ! $quit ) {

        my $time = Time::HiRes::time;

        while ( my $key = App::MusicBox::Input::read_key() ) {
            my $cmd = App::MusicBox::Input::key_to_cmd($key);
            if ( $cmd eq 'up' ) {
                $c->index_dec;
            }
            if ( $cmd eq 'down' ) {
                $c->index_inc;
            }
            if ( $cmd eq 'enter' ) {
                $c->enter;
            }
            if ( $cmd eq 'quit' ) {
                last RUN;
            }
            if ( $cmd eq 'next' ) {
                $c->next_page;
            }
            if ( $cmd eq 'prev' ) {
                $c->prev_page;
            }
        }

        $c->draw();

    }
}

1;
