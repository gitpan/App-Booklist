# -*- cperl -*-
# $Id: 00.load.t 95 2008-02-02 18:31:21Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/00.load.t $

use Test::More tests => 16;

BEGIN {
use_ok( 'App::Booklist' );
use_ok( 'App::Booklist::Command::add' );
use_ok( 'App::Booklist::Command::authors' );
use_ok( 'App::Booklist::Command::finish' );
use_ok( 'App::Booklist::Command::import' );
use_ok( 'App::Booklist::Command::list' );
use_ok( 'App::Booklist::Command::make_database' );
use_ok( 'App::Booklist::Command::start' );
use_ok( 'App::Booklist::Command::stats' );
use_ok( 'App::Booklist::DB' );
use_ok( 'App::Booklist::DB::Author' );
use_ok( 'App::Booklist::DB::AuthorBook' );
use_ok( 'App::Booklist::DB::Book' );
use_ok( 'App::Booklist::DB::BookTag' );
use_ok( 'App::Booklist::DB::Reading' );
use_ok( 'App::Booklist::DB::Tag' );
}

diag( "Testing App::Booklist $App::Booklist::VERSION" );
