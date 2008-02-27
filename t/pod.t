# -*- cperl -*-

# $Id: pod.t 69 2008-01-12 13:54:23Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/t/pod.t $

use Test::More;
eval "use Test::Pod 1.14";
plan skip_all => "Test::Pod 1.14 required for testing POD" if $@;
all_pod_files_ok();
