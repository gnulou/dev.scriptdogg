#! /usr/bin/perl
########################################
use strict;
use warnings;
########################################
package Hub
{
  sub new
  {
    my ($class, $STUFF, @args) = @_;
    ######################################
    my ($self, $req);

    $req = &_hostwinds_hub;

    $req->{req_dat} = $STUFF;

    $self = bless
    {
      $class => _post_dat($req)

    }, $class;

    return $self;
  }
  #############################
  sub _post_dat
  {
    my ($self) = @_;

    use WWW::Curl::Simple;
    use HTTP::Request ();

    my $r = HTTP::Request->new('POST', $self->{req_url}, $self->{req_header}, encode($self->{req_dat}));

    my $curl = WWW::Curl::Simple->new();

    my $res  = $curl->request($r) or warn $!."It was a problem here for sure";

    return $res->{_content};
  }

  ######################################
  sub _hostwinds_hub
  {
    return
    {
      reg_header  =>  "['Content-Type' => 'application/json; charset=UTF-8']",
      req_url     =>  "https://clients.hostwinds.com/cloud/api.php",
    };
  }
########################################
}1; # END
########################################

########################################
# END
########################################################################
# NOTES:
=pod



=cut
########################################################################
