# -*- cperl -*-
# $Id: 99.clean_up.t 87 2008-02-02 18:23:14Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/99.clean_up.t $

use Test::More qw/ no_plan /;

use Test::File;

use App::Booklist;

use lib './t';
require 'db.pm';

my $file = App::Booklist->db_location();
unlink $file;

file_not_exists_ok $file , 
  'database file was properly cleaned up';
