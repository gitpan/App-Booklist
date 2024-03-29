package App::Booklist::Command::finish;

# $Id: finish.pm 89 2008-02-02 18:27:40Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/lib/App/Booklist/Command/finish.pm $

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use FindBin;
use lib "$FindBin::Bin/../lib";

use App::Booklist;

sub opt_spec {
  (
    [ 'id|i=s'                , 'reading id'    ] ,
    [ ] ,
    [ 'finishdate|finish|d=s' , 'date finished reading (optional; defaults to today)' ] ,
  );
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  $self->usage_error("Must give '--id' argument")
    unless $opt->{id};
  
  if ( $opt->{finishdate} ) {
    eval {
      $opt->{finishdate} = App::Booklist->ymd2epoch( $opt->{finishdate} ); 
    };
    $self->usage_error( $@ ) if ( $@ );
  }
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = App::Booklist->db_handle();

  my $reading = $db->resultset('Reading')->find($opt->{id});

  unless ( $reading ) {
    print STDERR "Hmm. I can't seem to find a reading with that ID...";
    exit(1);
  }

  my $finishdate;
  if ( $opt->{finishdate} ) {
    $finishdate = $opt->{finishdate};
  }
  else {
    $finishdate = time();
  }
  
  $reading->finishdate( $finishdate );
  $reading->update();

  my $title = $reading->book->title;

  my $duration;
  eval { $duration = $reading->calc_reading_duration };
  die "$@" if $@;
  
  print "Finished reading '$title'\nRead for $duration";
}


1; # Magic true value required at end of module

__END__

=head1 NAME

App::Booklist::Command::finish - finish reading a book

=head1 SYNOPSIS

    booklist finish --id $ID [ --finishdate $YYYYMMDD ]
    booklist finish -i $ID [ -d $YYYYMMDD ]

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
