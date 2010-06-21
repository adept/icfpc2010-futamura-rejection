use LWP::UserAgent;
use strict;

my $ua = LWP::UserAgent->new();

my $response = $ua->get('http://icfpcontest.org/icfp10/score/instanceTeamCount');
if ($response->is_success) {
    my $content = $response->decoded_content;
    foreach my $match ($content =~ /\/instance\/(\d+)\//) {
	print "$1\n";
    }
} else {
    die $response->status_line;
} 