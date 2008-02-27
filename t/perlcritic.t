# -*- cperl -*-

# $Id: perlcritic.t 69 2008-01-12 13:54:23Z genehack $ 
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/perlcritic.t $

use Test::More;
eval "use Test::Perl::Critic";
plan skip_all => "Test::Perl::Critic required for testing PBP compliance" if $@;

Test::Perl::Critic::all_critic_ok();
