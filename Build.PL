use strict;
use warnings;

use Module::Build;

# $Id: Build.PL 107 2008-03-07 12:05:11Z genehack $ 
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/Build.PL $

my $builder = Module::Build->new(
    module_name         => 'App::Booklist',
    license             => 'perl',
    dist_author         => 'John SJ Anderson <genehack@genehack.org>',
    dist_version_from   => 'lib/App/Booklist.pm',
    requires => {
      'App::Cmd'            => 0 ,
      'App::Cmd::Command'   => 0 ,
      'DateTime'            => 0 ,
      'DBIx::Class'         => 0 ,
      'DBIx::Class::Schema' => 0 ,
      'File::SearchPath'    => 0 ,
      'FindBin'             => 0 ,
      'SQL::Translator'     => 0 , 
      'Test::Exception'     => 0 ,
      'Test::File'          => 0 ,
      'Test::More'          => 0 ,
      'Test::Trap'          => 0 ,
      'version'             => 0 ,
    },
    script_files        => [ 'bin/booklist' ] ,
    add_to_cleanup      => [ 'Booklist-*' , '*.bak' ],
);

$builder->create_build_script();
