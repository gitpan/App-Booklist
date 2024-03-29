# -*- cperl -*-
# $Id: 30.start.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/30.start.t $

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'Orbital Resonance';
my $author = 'John Barnes';
my $pages  = 218;

my $today  = App::Booklist->epoch2ymd();


my @args = (
  'start'               ,
  '--title'  => $title  ,
  '--author' => $author ,
  '--pages'  => $pages  ,
);   

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'return' , 'exit okay' );

$trap->stdout_like( qr/Started to read '$title'/ ,
    'start returns expected stuff' );

$trap->stderr_nok( 'stderr is empty' );

my $book = App::Booklist->db_handle->resultset('Book')->find( {
  title => $title
} );

isa_ok $book , 'DBIx::Class::Row' ,
    'get a single book back';

is $book->authors->first->author , $author ,
    'and the author is the author';

is $book->pages , $pages ,
    'and the page counts match';

is $book->readings->first->start_as_ymd , $today ,
    'and the start date is what it should be';

is $book->readings->first->finishdate , undef ,
    'and the book has no finish date yet';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'exit' , 
    'start exits when trying to start book already being read'); 

$trap->exit_is( 1 , 
    'should exit with status 1 when trying to start book already being read' );

$trap->stdout_nok(
    'and should not send anything to STDOUT when doing so' );
   
$trap->stderr_like( qr/^You seem to already be reading that book/ ,
    'stderr should have error text however' );

$trap->stderr_like(
      qr/You started it on $today and have not yet recorded a finish date/ ,
      'stderr should also have the start date' );
