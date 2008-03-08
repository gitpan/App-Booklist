package App::Booklist::DB::AuthorBook;

# $Id: AuthorBook.pm 108 2008-03-08 03:47:41Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/lib/App/Booklist/DB/AuthorBook.pm $

use warnings;
use strict;

use base qw/DBIx::Class/;

__PACKAGE__->load_components( qw/ PK::Auto Core / );

__PACKAGE__->table( 'authors_books' );

__PACKAGE__->add_columns(
  author => { data_type => 'INTEGER' } ,
  book   => { data_type => 'INTEGER' } ,
);

__PACKAGE__->set_primary_key( qw/ author book / );

__PACKAGE__->belongs_to( author => 'App::Booklist::DB::Author' );
__PACKAGE__->belongs_to( book   => 'App::Booklist::DB::Book'   );







1; # Magic true value required at end of module



__END__

=head1 NAME

App::Booklist::DB::BookAuthor - DBIC table class for the 'bookauthor' table.

=head1 SYNOPSIS

Autoloaded by DBIC framework. 

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

John SJ Anderson  C<< <genehack@genehack.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, John SJ Anderson C<< <genehack@genehack.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
