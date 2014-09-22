#encoding: UTF-8
package App::MusicBox::UI;
use 5.012;
use strict;
use warnings;
use Moo;

use if $^O eq "MSWin32", "Win32::Console::ANSI";
use Term::ANSIColor;

sub draw_title {
    my ( $self, $title ) = @_;

    $self->save_cursor;
    $self->move_cursor(10, 10);
    print $title;
    $self->restore_cursor;
}

sub draw_playinfo {
    my $self = shift;

    my $title;
    $self->draw_title($title);
}

sub draw_loading {
    my $self = shift;

}

sub draw_menu {
    my $self = shift;

    $self->clear_screen;
    my $title = "网易云音乐";
    $self->draw_title($title);
}

sub draw_search {
    my $self = shift;

}

sub draw_search_menu {
    my $self = shift;

}

sub draw_login {
    my $self = shift;

}

sub draw_login_error {
    my $self = shift;

}


# --- cursor related method

sub move_cursor {
    my ( $self, $dx, $dy ) = @_;
    $dx > 0 ? do { printf "\e[%dC", $dx } : $dx < 0 ? do { printf "\e[%dD", -$dx } : do {};
    $dy > 0 ? do { printf "\e[%dB", $dy } : $dy < 0 ? do { printf "\e[%dA", -$dy } : do {};
}

sub save_cursor {
    my $self = shift;
    print "\e[s";
}

sub restore_cursor {
    my $self = shift;
    print "\e[u";
}

sub hide_cursor {
    my $self = shift;
    state $once = eval 'END { $self->show_cursor }';
    print "\e[?25l";
}
sub show_cursor {
    my $self = shift;
    print "\e[?25h";
}

sub clear_screen {
    my $self = shift;
    print "\e[1J";
    print "\e[1;1H";
}

1;
