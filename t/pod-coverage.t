# -*- cperl -*-

# $Id: pod-coverage.t 69 2008-01-12 13:54:23Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/pod-coverage.t $

use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
my $trustparents = { coverage_class => 'Pod::Coverage::CountParents' };
all_pod_coverage_ok( $trustparents );
