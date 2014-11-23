package App::MusicBox::Control;
use 5.012;
use strict;
use warnings;
use utf8;
use Encode qw( decode encode from_to );

use Moo;
use Data::Dumper;
use App::MusicBox::Api;
use App::MusicBox::Player;

with 'App::MusicBox::UI';

has route   => is => 'rw', default => '/';
has netease => is => 'rw', default => sub { App::MusicBox::Api->new() };
has player  => is => 'rw', default => sub { App::MusicBox::Player->new() };

sub enter {
    my $self = shift;

    if ( $self->route eq '/' ) {
        $self->choice_channel;
        return;
    }
    if ( $self->route eq '/songs' ) {
        $self->player->play();
    }
}

sub choice_channel {
    my $self = shift;

    my $ne = $self->netease;

    # 排行榜
    if ( $self->menu_index == 0 ) {
        my $songs = $ne->top_songlist;
        $self->menu_list( $self->to_menu($ne->dig_info($songs, 'songs'), 'songs') );
        $self->title( $self->title . ' > 排行榜' );
        $self->route('/songs');
    }

    # 艺术家
    if ( $self->menu_index == 1 ) {
        my $artists = $ne->top_artists;
        $self->menu_list( $self->to_menu($ne->dig_info($artists, 'artists'), 'artists') );
        $self->title( $self->title . ' > 艺术家' );
        $self->route('/artists');
    }
}

sub index_inc {
    my $self = shift;

    $self->menu_index( $self->menu_index == $self->menu_length - 1 ? 0
                                                                   : $self->menu_index + 1
        );
}

sub index_dec {
    my $self = shift;

    $self->menu_index( $self->menu_index == 0 ? $self->menu_length - 1
                                              : $self->menu_index  - 1
        );
}

sub next_page {
    my $self = shift;

    return if ( $self->page + $self->page_cap >= $self->menu_length );

    $self->page($self->page + 1);
    $self->index($self->index + $self->page_cap > $self->menu_length ? $self->menu_length - 1
                                                                     : $self->index + $self->page_cap
        );
}

sub to_menu {
    my ( $self, $datalist, $type ) = @_;

    my $menu_list = [];
    if ( $type eq 'songs' ) {
        foreach my $i ( 1 .. $#$datalist ) {
            my $str = $i . '. ' . $datalist->[$i]->{song_name} . '   -   ' . $datalist->[$i]->{artist} . '  < ' . $datalist->[$i]->{album_name} . ' >';
            push $menu_list, $str;
        }
    }
    if ( $type eq 'artists' ) {
        foreach my $i ( 1 .. $#$datalist ) {
            my $str = $i . '. ' . $datalist->[$i]->{artist_name} . '   -   ' . $datalist->[$i]->{alais};
            push $menu_list, $str;
        }
    }
    return $menu_list;
}
1;
