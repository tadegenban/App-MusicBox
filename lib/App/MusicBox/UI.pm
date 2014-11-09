#encoding: UTF-8
package App::MusicBox::UI;
use 5.012;
use strict;
use warnings;
use Moo;

use if $^O eq "MSWin32", "Win32::Console::ANSI";
use Term::ANSIColor;


has title => is => 'rw', default => '网易云音乐';
has title_x    => is => 'rw', default => 30;
has title_y    => is => 'rw', default => 2;

has menu_list => (
    is      => 'rw',
    default => sub {
        return ['排行榜', '艺术家', '新碟上架', '精选歌单', '我的歌单', 'DJ节目', '打碟', '收藏', '搜索', '帮助'];
    },
    );
has menu_index => is => 'rw', default => 0;
has menu_index_sigil => is => 'rw', default => '$';
has menu_x    => is => 'rw', default => 20;
has menu_y    => is => 'rw', default => 6;


sub draw {
    my $self = shift;

    local $| = 1;
    $self->clear_screen;
    $self->draw_title();
    $self->draw_menu();
}

sub draw_title {
    my ( $self, $title ) = @_;

    $self->save_cursor;
    $self->move_cursor($self->title_x, $self->title_y);
    print $self->title;
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

    $self->save_cursor;
    $self->move_cursor($self->menu_x, $self->menu_y);

    map { say $_; $self->move_cursor($self->menu_x, 0) } @{ $self->menu_list };

    $self->restore_cursor;

    $self->save_cursor;
    $self->move_cursor($self->menu_x - length($self->menu_index_sigil),
                      $self->menu_y + $self->menu_index);
    print $self->menu_index_sigil;

    $self->restore_cursor;
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
    print "\e[2J";
}

1;
