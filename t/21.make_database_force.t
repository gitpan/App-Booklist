# -*- cperl -*-
# $Id: 21.make_database_force.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/21.make_database_force.t $

use Test::More    qw/ no_plan    /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $test_db_name = App::Booklist->db_location();

trap {
  local @ARGV = ( 'make_database' , '--force' );
  App::Booklist->run;
};

$trap->stderr_nok(
  'stderr is empty' );

$trap->stdout_like ( qr/Created database at $test_db_name/ ,
  'make_database says what it did' );

