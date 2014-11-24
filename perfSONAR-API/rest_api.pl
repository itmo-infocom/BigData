#!/usr/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use DateTime;
use lib '/opt/perfsonar_ps/toolkit/lib';
use perfSONAR_PS::Client::Esmond::ApiConnect;
my $local="perfsonar.vuztc.ru";
my $arch="perfsonar.vuztc.ru";

my $d = HTTP::Daemon->new(
  LocalAddr => $local,
  LocalPort => 9911,
) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my ($c,$p_ip) = $d->accept) {
  $p_ip =~ /(..)(..)(..)(..)/;
  my $ip = inet_ntoa("$3$4");
  while (my $r = $c->get_request) {
    my %IF;
    my $g_uri=$r->uri->path;
    if ($r->method eq 'GET' and $r->uri->path eq '/psAPI') {
#      print $c "Content-type: text/html\n\n";
      for (split /&/,$r->uri->query) {
	my ($n, $_) = split /=/;
	tr/+/ /; s/\s+/ /g;
	s/%([a-fA-F0-9][a-fA-F0-9])/pack "C",hex $1/eg;
	s/\n//g; s/\t+/ /g; s/^\s+(.*\S)\s+$/$1/;
	s/\r+/\r/g; s/(.*)\r$/$1/; s/^\r(.*)/$1/;
	$IF{$n} = $_;
      }
      if ($IF{cmd} eq "throughput") {
	print $c throughput ($local,$IF{chan},$arch,$IF{dt});
      } elsif ($IF{cmd} eq "tracert") {
	print $c tracert ($local,$IF{chan},$arch,$IF{dt});
      }
      $c->close;
    } else {
      $c->send_error(RC_FORBIDDEN);
    }
  }
  $c->close;
  undef($c);
}

#######################################
sub throughput {
  my ($src,$dst,$arch,$dt) = @_;
  # Define filters
  my $filters = new perfSONAR_PS::Client::Esmond::ApiFilters();
  $filters->source($src);
  $filters->destination($dst);
  $filters->time_range($dt);
  my $now = time;
  #$filters->time($now - 21600); # 6 hours ago
  #$filters->time_start($now);
  #$filters->time_end($now-$dt);
  $filters->event_type('throughput');

  # Connect to api
  my $client = new perfSONAR_PS::Client::Esmond::ApiConnect
    ( url => "http://$arch/esmond/perfsonar/archive",
      filters => $filters );
  my $str;
  #get measurements matching filters
  my $md = $client->get_metadata();
  return $client->error if $client->error; #check for errors
  #loop through all measurements
  foreach my $m(@{$md}){
    # get data of a particular event type
    my $et = $m->get_event_type("throughput");
    my $data = $et->get_data();
    die $et->error if($et->error); #check for errors
    #store all data
    foreach my $d(@{$data}){
      $str .= "Time: " . $d->datetime . ", Value: " . $d->val . "\n";
    }
  }
  return $str;
}

sub tracert {
  my ($src,$dst,$arch,$dt) = @_;
  #define filters
  my $filters = new perfSONAR_PS::Client::Esmond::ApiFilters();
  $filters->source($src);
  $filters->destination($dst);
  $filters->time_range($dt);
  $filters->event_type('packet-trace');

  # connect to api
  my $client = new perfSONAR_PS::Client::Esmond::ApiConnect
    ( url => "http://$arch/esmond/perfsonar/archive",
      filters => $filters );
  my $str;
  #get measurements matching filters
  my $md = $client->get_metadata();
  return $client->error if($client->error); #check for errors
  foreach my $m(@{$md}){
    my $et = $m->get_event_type("packet-trace");
    my $data = $et->get_data();
    die $et->error if($et->error); #check for errors
    #base data
    foreach my $d(@{$data}){
        $str .= "Time: " . $d->datetime . "\n";
        foreach my $hop(@{$d->val}){
            $str .= "ttl=" . $hop->{ttl} . ",query=" . $hop->{query};
            if($hop->{success}){
	      $str .= ",ip=" . $hop->{ip} . ",rtt=" . $hop->{rtt} . ",mtu=" . $hop->{mtu} . "\n"; 
            }else{
	      $str .= ",error=" . $hop->{error} . "\n"; 
            }
	  }
      }
  }
  return $str;
}
