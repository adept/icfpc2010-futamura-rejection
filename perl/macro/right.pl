use strict;

my $ns = [];

for my $n (1..16) {
  my $results = [];
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $a;
      my $y = $b;      
      ($x, $y) = ($y, $x);
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) = (($x - $y) % 3, ($x * $y - 1) % 3);
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
        }
      }
      push @$results, [$x, $y];
    }
  }
  if ($results->[0]->[0] == $results->[1]->[0] && $results->[0]->[0] == $results->[2]->[0]) {
    push @$ns, $n;
    print "$n has left fixed output when 0 fed on the left\n";
  }
  if ($results->[3]->[0] == $results->[4]->[0] && $results->[3]->[0] == $results->[5]->[0]) {
    push @$ns, $n;
    print "$n has left fixed output when 1 fed on the left\n";
  }
  if ($results->[6]->[0] == $results->[7]->[0] && $results->[6]->[0] == $results->[8]->[0]) {
    push @$ns, $n;
    print "$n has left fixed output when 1 fed on the left\n";
  }
}

for my $n (@$ns) {
  my $results = [];
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $b;
      my $y = $a;      
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) =(($x - $y) % 3, ($x * $y - 1) %3 );
        print "G";
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
           print "X";
        }
      }
      push @$results, [$x, $y];      
    }
  } 
  print "\n\t";
  print join (", ", map {$_->[0] . $_->[1]} @$results);
  print "\n";
}



