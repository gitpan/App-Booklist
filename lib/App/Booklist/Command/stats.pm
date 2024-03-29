package App::Booklist::Command::stats;

# $Id: stats.pm 89 2008-02-02 18:27:40Z genehack $
# $URL: svn+ssh://genehack.net/var/lib/svn/booklist/trunk/lib/App/Booklist/Command/stats.pm $

use warnings;
use strict;

use base qw/ App::Cmd::Command /;

use DateTime;

use FindBin;
use lib "$FindBin::Bin/../lib";

use App::Booklist;

sub usage_desc { "%c stats" }

sub opt_spec {
  (
    [ 'year|y=s' , 'limit to a particular year' ] ,
    [ 'all|a'    , 'show all-time stats (default is year to-date)' ] ,
  )
}

sub validate_args {
  my( $self , $opt , $args ) = @_;
  
  # no args allowed but options!
  $self->usage_error("No args allowed") if @$args;

  # can't have both 'all' and a 'year'
  $self->usage_error("--year and --all are mutually exclusive")
    if $opt->{year} and $opt->{all};

  if ( $opt->{year} ) {
    $self->usage_error("--year takes a four-digit number as an arg")
      unless $opt->{year} =~ /^\d{4}$/;
  }
}


sub run {
  my( $self , $opt , $args ) = @_;

  my $db = App::Booklist->db_handle();

  my $search;
    
  if ( $opt->{all} ) {
    $search = undef;
  }
  elsif ( $opt->{year} ) {
    my $dt1 = DateTime->new( year => $opt->{year} );
    my $dt2 = DateTime->new( year => $opt->{year} + 1 );
    my $e1  = $dt1->epoch - 1;
    my $e2  = $dt2->epoch;
    $search = {
      startdate => { '>' => $e1 , '<' => $e2 } ,
    };
  }
  else {
    my $dt1  = DateTime->now;
    my $year = $dt1->year;
    my $dt2  = DateTime->new( year => $year );
    my $e1   = $dt2->epoch - 1;
    $search = {
      startdate => { '>' => $e1 } ,
    };
  }

  my @readings = $db->resultset('Reading')->search( $search ,
                                                    { order_by => 'id' } );

  my( %books , %authors , $total_duration , $total_pages );
  my $unfinished = 0;
  my( $min_pages , $max_pages ) = ( 999999999 , 0 );
  my( $min_duration , $max_duration ) = ( 99999999 , 0 );
  
  foreach my $r( @readings ) {
    my $book     = $r->book;
    my @authors  = $r->book->authors;
    my @tags     = $r->book->tags;
    my $duration = $r->duration;
    my $pages    = $r->book->pages;
    
    $books{$book->id}{count}++;
    $books{$book->id}{obj} = $book;
    
    foreach ( @authors ) {
      $authors{$_->id}{count}++;
      $authors{$_->id}{obj} = $_;
    }

    if ( $duration ) {
      $total_duration += $duration;
      $total_pages    += $pages;
      if ( $pages < $min_pages ) { $min_pages = $pages }
      if ( $pages > $max_pages ) { $max_pages = $pages }
      if ( $duration < $min_duration ) { $min_duration = $duration }
      if ( $duration > $max_duration ) { $max_duration = $duration }
    }
    else {
      $unfinished++;
    }
  }
  
  my $book_count   = scalar keys %books;
  my $author_count = scalar keys %authors;
  my $finished = $book_count - $unfinished;

  my $max_read_count = 1;
  my @max_read;
  foreach ( keys %books  ) {
    if ( $books{$_}{count} > $max_read_count ) {
      $max_read_count = $books{$_}{count};
      push @max_read , $_;
    }
  }

  my $max_auth_count = 1;
  my $max_auth;
  foreach ( keys %authors ) {
    if ( $authors{$_}{count} > $max_auth_count ) {
      $max_auth_count = $authors{$_}{count};
      $max_auth = $authors{$_}{obj};
    }
  }

  printf "SAW %d BOOKS BY %d AUTHORS\n" , $book_count , $author_count;
  printf "FINISHED %d BOOK" , $finished;
  print 'S' unless $finished == 1;
  print "\n";
  if ( $total_duration ) {
    print "\n";
    printf "AVERAGE READING TIME: %5d days\n" , _sec2days( $total_duration / $finished );
    printf "     SLOWEST READING: %5d days\n" , _sec2days( $max_duration );
    printf "     FASTEST READING: %5d days\n" , _sec2days( $min_duration );
    print "\n";
    printf "    TOTAL READ PAGES: %7d pages\n" , $total_pages;
    printf "AVERAGE PAGES / BOOK: %7d pages\n" , int( $total_pages / $finished );
    print "\n";
    printf " LONGEST BOOK HAD: %d pages\n" , $max_pages;
    printf "SHORTEST BOOK HAD: %d pages\n" , $min_pages;
    
  }

  
  print "\n";

  if ( $max_read_count > 1 ) {
    printf "Most reads of a single book: %d\n" , $max_read_count;
    print  "You read these books more than once:\n";
    foreach ( @max_read ) {
      my $book = $books{$_}{obj};
      printf "\t%s (Reads: %d)\n" , $book->title , $books{$_}{count};
    }
    print "\n";
  }
  
  if ( $max_auth && $max_auth > 1 ) {
    printf "Most books by a single author: %d by %s\n" ,
      $max_auth_count , $max_auth->author;
  }
}

sub _sec2days {
  my( $sec ) = shift;
  return int( $sec / ( 60 * 24 * 24 ));
}

1; # Magic true value required at end of module

__END__

=head1 NAME

App::Booklist::Command::stats - generate descriptive stats from the database

=head1 SYNOPSIS

Generate descriptive stats from the database



    booklist stats

    booklist stats --year $YEAR
    booklist stats -y $YEAR

    booklist stats --all
    booklist stats -a


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
