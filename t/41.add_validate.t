# -*- cperl -*-
# $Id: 41.add_validate.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/41.add_validate.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'Overclocked: Stories of Future Present';
my $author = 'Cory Doctorow';
my $pages  = 285;

my @args = ( 'add' );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/title is a required option/ ,
  'you needs a title'
);

push @args , ( '--title' => $title );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/author is a required option/ ,
  'you needs an author too'
);

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/pages is a required option/ ,
  'and you has to track pages yo'
);

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );
