use strict;

my $ns = [];

for my $n (1..1024) {
  my $results = [];
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $a;
      my $y = $b;      
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) = (($x - $y) % 3, ($x * $y - 1) % 3);
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
        }
      }
      push @$results, [$x, $y];
    }
  }
  if ($results->[0]->[0] == $results->[1]->[0] && $results->[0]->[0] == $results->[2]->[0] && $results->[0]->[1] == $results->[1]->[1] && $results->[0]->[1] == $results->[2]->[1]) {
    push @$ns, $n;
  }
}

for my $n (@$ns) {
  my $results = [];
  for(my $m = $n; $m > 0; $m >>= 1) {
    print "G";
    if($m % 2 == 0) {
       print "X";
    }
  }
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $a;
      my $y = $b;      
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) =(($x - $y) % 3, ($x * $y - 1) %3 );
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
        }
      }
      push @$results, [$x, $y];      
    }
  } 
  print "\n\t";
  print join (", ", map {$_->[0] . $_->[1]} @$results);
  print "\n";
}

$ns = [];

for my $n (1..256) {
  my $results = [];
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $b;
      my $y = $a;      
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) = (($x - $y) % 3, ($x * $y - 1) % 3);
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
        }
      }
      push @$results, [$x, $y];
    }
  }
  if ($results->[0]->[0] == $results->[1]->[0] && $results->[0]->[0] == $results->[2]->[0] && $results->[0]->[1] == $results->[1]->[1] && $results->[0]->[1] == $results->[2]->[1]) {
    push @$ns, $n;
  }
}

for my $n (@$ns) {
  my $results = [];
  for(my $m = $n; $m > 0; $m >>= 1) {
    print "G";
    if($m % 2 == 0) {
       print "X";
    }
  }
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $b;
      my $y = $a;      
      for(my $m = $n; $m > 0; $m >>= 1) {
        ($x, $y) =(($x - $y) % 3, ($x * $y - 1) %3 );
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
        }
      }
      push @$results, [$x, $y];      
    }
  } 
  print "\n\t";
  print join (", ", map {$_->[0] . $_->[1]} @$results);
  print "\n";
}
