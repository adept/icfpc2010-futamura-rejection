use Data::Dumper;

for my $n (10) {
  my $results = [];
  for my $a (0..2) {
    for my $b (0..2) {
      my $x = $a;
      my $y = $b;      
      for(my $m = $n; $m > 0; $m = int ($m / 2)) {
        print ".";
        ($x, $y) =(($x - $y) % 3, ($x * $y - 1) %3 );
        print "G";
        if($m % 2 == 0) {
           ($x, $y) = ($y, $x);
           print "X";
        }
      }
      push @$results, [$x, $y];      
    }
    print " ";
    print join (", ", map {$_->[0] . ':' . $_->[1]} @$results);
    print "\n";
  } 
}

