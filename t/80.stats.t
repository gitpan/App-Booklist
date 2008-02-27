# -*- cperl -*-
# $Id: 80.stats.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/80.stats.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ( 'stats' );
  App::Booklist->run;
};

$trap->leaveby_is(
  'return' ,
  'return on non-err'
);

$trap->stdout_like(
  qr/SAW 4 BOOKS BY 4 AUTHORS/ , 
  'show stats'
);

$trap->stdout_like(
  qr/FINISHED 1 BOOK/ , 
  'show stats'
);

$trap->stderr_nok(
  'stderr silent'
);

