# -*- cperl -*-
# $Id: db.pm 41 2008-01-07 20:06:47Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/db.pm $

my $test_db_name  = "./.testing_booklist.db";
$ENV{BOOKLIST_DB} = $test_db_name;

1;
