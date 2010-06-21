#!/usr/bin/perl
use LWP::UserAgent;
use strict;

use constant URL => 'http://nfa.imn.htwk-leipzig.de/recent_cars/?G0=';

my $ua = LWP::UserAgent->new;
fetch_write(last_car_id());

sub fetch_write {
    my $id = shift;
    print STDERR "Fetching cars from $id...\n";
    my $response = $ua->get(URL . $id . '#hotspot');
    if ($response->is_success) {
	my $content = $response->decoded_content;
	my $last_id = -1;
	while ($content =~ /\((\d+),.+quot;(\d+)/g) {
    	#    write_car($1,$2);
        print "$1, $2\n";
	    $last_id = $1;
	}
	if ($last_id != -1) {
	    fetch_write($last_id);
	}
    } else {
	die $response->status_line;
    }	
}

sub last_car_id {
    my @dirs = grep {-d && /\d+$/} (glob('data/*'));
    if ((scalar @dirs) == 0) {return 0;}
    my @dir_names = map {s/(\d+)$/$1/;$1} @dirs;
    my @sorted = sort {$a <=> $b} (@dir_names);
    return pop @sorted;
}

sub write_car {
    my ($id, $data) = @_;
    mkdir 'data';
    mkdir "data/$id";
    open (my $fh, ">", "data/$id/car.def") || die;
    print $fh "$id, $data";
    close $fh;
}
