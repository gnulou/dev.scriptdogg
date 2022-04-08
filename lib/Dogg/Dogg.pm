#! /usr/bin/perl
########################################
use strict;
use warnings;
##########################################
package Dogg
{
  ########################################
  use lib "App/";
  use lib "Hub/";
  use lib "Dat/";
  use JSON::PP;
  use Test::JSON;
  use App;
  use Hub;
  use Dat;
  ########################################
  sub new
  {
    my ($class, @args) = @_;
	
	my ($self, $STUFF);
	
	foreach my $arg (@args)
	{
	  unless($arg eq $class)
	  {
		$STUFF->{$arg} = _process_args($arg);
	  }
	}
	
    return $self;
  }
  ######################################
  sub DESTROY 
  {
    local($., $@, $!, $^E, $?);
    my $self = shift;
	
    return if ${^GLOBAL_PHASE} eq 'DESTRUCT';
	
	unless($self->_dump_conf)
	{
		print "Error in DESTROY.";
	}
	
	$self->{id}->close() if $self->{id};
	$self->{bldversion}->close() if $self->{bldversion};
	$self->{datetime}->close() if $self->{datetime};
	$self->{cfg}->close() if $self->{cfg};
	$self->{cfgfile}->close() if $self->{cfgfile};
	
  }
  ######################################
  # YAML
  ######################################
  sub _load_conf
  {
	my ($self) = @_;
	$self->{cfg} = LoadFile($self->{cfgfile});
	return $self->{cfg};
  }
  ######################################  
  sub _dump_conf
  {
	  my ($self) = @_;
	  
	  unless(DumpFile($self->{cfgfile}, $self->{cfg}))
	  
	    { print "Error Dumping Conf file. Line: ".__LINE__; }
	  
	  else { $self->{cfg} = undef; }
	 
	 return $self->{cfg};
	  
  }
  ######################################
  sub _process_args
  {
	my $arg = shift;
  }

  ######################################
  sub add_dogg
  {

  }
 
  ###################################### 
  sub get_dogg
  {

  }

  ######################################
  sub set_dogg
  {

  }
  
  ######################################
  sub update_dogg
  {
	  
  }

  ######################################
  #
  #
  ######################################
  # JSON
  ######################################
  sub TO_JSON
  {
  	return { %{ shift() } };

  }
########################################
}1; # END
########################################################################
# NOTES:
=pod



=cut
########################################################################
