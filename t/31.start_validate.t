# -*- cperl -*-
# $Id: 31.start_validate.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/31.start_validate.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'CSS Cookbook';
my $author = 'Christopher Schmitt';
my $pages  = 252;

my $today  = App::Booklist->epoch2ymd();

trap {
  local @ARGV = ( 'start' );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/title is a required option/ ,
  'you needs a title' );

my @args = (
  'start'             ,
  '--title' => $title ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/author is a required option/ ,
  'you needs an author too' );

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/pages is a required option/ ,
  'and you has to track pages yo' );

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );

