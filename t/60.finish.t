# -*- cperl -*-
# $Id: 60.finish.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/60.finish.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'The Sleeping Dragon';
my $id     = App::Booklist->db_handle->resultset('Book')->find( { 
  title => $title
} )->id;

my @args = (
  'start' ,
  '--id'  => $id  ,
);   

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'just checking things still work as expected'
);

$args[0] = 'finish';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};


$trap->leaveby(
  'return' ,
  'return on non-error' 
);

$trap->stdout_like(
  qr/Finished reading '$title'/ ,
  'expected stdout'
);

$trap->stderr_nok(
  'and nothing on stderr'
);
