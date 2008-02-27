# -*- cperl -*-
# $Id: 71.list-validate.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/71.list-validate.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ('list','foo');
  App::Booklist->run;
};

$trap->leaveby_is(
  'die' ,
  'die on bad args'
);

$trap->die_like(
  qr/No args allowed/ ,
  'thou shalt have no other args before me'
);

