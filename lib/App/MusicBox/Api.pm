package App::MusicBox::Api;
use strict;
use warnings;
use utf8;
use 5.012;

use Moo;
use Mojo::UserAgent;

use Data::Dumper;
use Try::Tiny;

our $default_timeout = 10;

has header => is => 'rw', default => sub {
    {
            'Accept'          => '*/*',
            'Accept-Encoding' => 'gzip,deflate,sdch',
            'Accept-Language' => 'zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4',
            'Connection'      => 'keep-alive',
            'Content-Type'    => 'application/x-www-form-urlencoded',
            'Host'            => 'music.163.com',
            'Referer'         => 'http=>//music.163.com/search/',
            'User-Agent'      => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36'
    }
};
has cookies => is => 'rw', default => sub {
    {
            'appver'          => '1.5.2'
    }
};

sub httpRequest {
    my ( $self, $method, $action, $query, $urlencoded, $callback, $timeout ) = @_;

    my $connection;
    if ( $method eq 'GET' ) {
        my $url = defined $query ? $action . '?' . $query : $action;
        my $ua = Mojo::UserAgent->new;
        $ua->connect_timeout($default_timeout);
        $connection = $ua->get($url, $self->header);
    }
    elsif ( $method eq 'POST' ) {
        ...;
    }

    return $connection->res->json;

}

# 热门单曲 http://music.163.com/#/discover/toplist 50
sub top_songlist {
    my ( $self, $offset, $limit ) = @_;
    $offset //= 0;
    $limit  //= 100;

    my $action = 'http://music.163.com/discover/toplist';

    my $ua = Mojo::UserAgent->new;
    $ua->connect_timeout($default_timeout);
    my $songids = [];
    for my $id ( $ua->get($action, $self->header)->res->body =~ /\/song\?id=(\d+)/g ) {
        push $songids, $id;
    }
    return $self->songs_detail($songids);
}


# 热门歌手 http://music.163.com/#/discover/artist/
sub top_artists {
    my ( $self, $offset, $limit ) = @_;
    $offset //= 0 ;
    $limit  //= 100;

    my $action = 'http://music.163.com/api/artist/top?offset=' . $offset . '&total=false&limit=' . $limit;
    try {
        say Dumper $self->httpRequest('GET', $action);
    }
    catch {
        return []
    }

}


sub songs_detail {
    my ( $self, $songids, $offset ) = @_;
    $offset //= 0;

    my $action = 'http://music.163.com/api/song/detail?ids=[' .
                 join(',', @$songids[$offset .. $offset + 10] ) .
                 ']';
    my $data = $self->httpRequest('GET', $action);
    return $data->{songs};
}

sub dig_info {
    my ( $self, $data, $dig_type ) = @_;

    my $tmp = [];
    if ( $dig_type eq 'songs' ) {
        foreach my $d ( @$data ) {
            my $song_info = {
                song_id    => $d->{id},
                artist     => [],
                song_name  => $d->{name},
                album_name => $d->{album}->{name},
                mp3_url    => $d->{mp3Url},
            };
            if ( exists $d->{artist} ) {
                $song_info->{artist} = $d->{artist};
            }
            elsif ( exists $d->{artists} ) {
                $song_info->{artist} = join ',', map { $_->{name} } @{ $d->{artists} };
            }
            else {
                $song_info->{artist} = '未知艺术家';
            }
            push $tmp, $song_info;
        }
    }

    if ( $dig_type eq 'artists' ) {
          for my $d ( @$data ) {
              my $artist_info  = {
                  artist_id    => $d->{id},
                  artist_name  => $d->{name},
                  alias        => join '', @{ $d->{alias} },
              };
              push $tmp, $artist_info;
          }
    }
    return $tmp;
}

1;