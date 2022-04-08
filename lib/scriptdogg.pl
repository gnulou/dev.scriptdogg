#! /usr/bin/perl
########################################
use strict;
use warnings;
########################################
package Proledogg
{
  ######################################
  use lib 'dogg/Dogg/';
  use lib 'Dogg/';
  use lib 'dogg/Dogg/App/';
  use lib 'Dogg/App/';
  use lib 'dogg/Dogg/Hub/';
  use lib 'Dogg/Hub/';
  use lib 'dogg/Dogg/Dat/';
  use lib 'Dogg/Dat/';
  use YAML qw(LoadFile DumpFile);
  use JSON::PP;
  use Test::JSON;
  ######################################
  sub new
  {
    my ($class, $STUFF, @Args) = @_;

    my ($self) = bless
    {
		bldversion  => $STUFF->{bldversion},
		cfgfile	  	=> $STUFF->{cfgfile},
		datetime    => &date_time,
		id  	    => time

	}, $class;

    return $self;
  }
  ######################################
  sub load_dat
  {
	  my ($self) = @_;

	  if($self->file_read) {  $self->de_json; }

	  return $self->{dat};
  }
  ######################################
  sub dump_dat
  {
	my ($self) = @_;

    if($self->en_json)
	  { if($self->file_write) { $self->{dat} = undef; } }

	return $self->{dat};
  }
  ######################################
  # JSON
  ######################################
  sub TO_JSON
  {
  	return { %{ shift() } };

  }
  ######################################
  sub en_json
  {
    my ($self) = @_;
    my $json = JSON::PP->new->
		allow_blessed(1)->
		convert_blessed(1)->
		allow_nonref;
  	$self->{dat} = $json->sort_by
  	(sub
		{
			$JSON::PP::a cmp $JSON::PP::b
		}
	 )->pretty->encode($self->{dat});

    return $self->{dat};
  }

  ######################################
  sub de_json
  {
  	my ($self) = @_;
  	local $/;	# Enable slurp
  	$self->{dat} = decode_json($self->{dat});
  	return $self->{dat};

  }
  ########################################
  # File Stuff
  ########################################
  sub file_write
  {
	my ($self) = @_;
	open(FILE, ">$self->{file}")or warn
	  "Can't write to file [$!] $self->{file} and $self->{dat}\n";
	print FILE $self->{dat};
	close(FILE) or die $!;
	return 1;
  }
  ########################################
  sub file_read
  {
	my ($self) = @_;
	local $/;			# Enable slurp
	open(FILE, "$self->{file}");
	$self->{dat} = <FILE>;
	close(FILE);
	return $self->{dat};

  }
  ########################################
  # Directory Stuff
  ########################################
  sub dir_make
  {
	use File::Path;
	unless(-d $_[0] or mkpath $_[0])
	{
		warn $!.
		  " : Directory $_[0] could not be made on line: ".
		  __LINE__;
	}

  }
  ########################################
  sub dir_open
  {
	opendir(DIR, $_[0]) or die "can't opendir $$_[0]: $!";
	my @dir = readdir(DIR);
	closedir DIR;
	return @dir;

  }
  ########################################
  # Date_Time
  ########################################
  sub date_time
  {
	my ($self) = @_;
	my ($date, @today);

	@today = localtime;

	# Month starts at 0, have to add 1
	$date->{mon} = sprintf("%02d", $today[4]+1);
	$date->{mday} = sprintf("%02d", $today[3]);
	$date->{hour} = sprintf("%02d", $today[2]);
	$date->{min} = sprintf("%02d", $today[1]);
	$date->{sec} = sprintf("%02d", $today[0]);
	$date->{year} = $today[5] + 1900;
	$date->{formatted} =
	  $date->{year}.
	  "-".$date->{mon}.
	  "-".$date->{mday}.
	  " ".$date->{hour}.
	  ":".$date->{min}.
	  ":".$date->{sec};

	$self->{datetime} = $date->{formatted};

	return $self->{datetime};
  }
########################################
}1; # END
########################################
#
# Call to Main Subroutine
#
########################################
my $RESP = Main(@ARGV);

print "$RESP";
########################################
#
#
#
########################################
# Main Sub
########################################
sub Main
{
  use Dogg;

  my ($Bldver, $Dggfile, @Dggargs) = @_;

  unless($Bldver) { return "No arguments given. Need Two."; }

  elsif(not($Dggfile)) { return "Only one argument given. Need Two."; }

  elsif(not(-f $Dggfile))
    { return "Second argument  must be a valid .yaml file."; }

  elsif( @Dggargs lt 1 )
    { return "Need 3 arguments in arg list, none given."; }

  elsif( @Dggargs gt 3 )
    { return "There are to many arguments in the list."; }

  elsif(((@Dggargs le 1) or (@Dggargs gt 3)) or (@Dggargs eq 2))
    { return "Array list is off."; }

  else
  {
	  my $STUFF =
	  {
		bldversion 	=> $Bldver,
		cfgfile	    => $Dggfile
	  };

	  return Proledogg->new($STUFF, @Dggargs);
  }

}
########################################
# End of Main
########################################
#
# ['Content-Type' => 'application/json; charset=UTF-8']
#
########################################

########################################
#
# End of Script
#
#########################################################################
# NOTES:
=pod

alpha=type
dogg=class
bark=argument ( variable )
prole=method

=cut
########################################################################
