use List::Permutor;
use Data::Dumper;
use strict;
my $perm = new List::Permutor(0, 0, 1, 1, 2, 2);
my $arr = [{}, {}, {}];
while (my @set = $perm->next) {
    #print join ", ", @set;
    #print "\n";
    my ($a, $b, $c, $d, $e, $f) = @set;
    my ($m, $n) = (($a - $b) % 3, ($a * $b - 1) % 3);
    my ($o, $p) = (($c - $d) % 3, ($c * $d - 1) % 3);
    my ($q, $r) = (($e - $f) % 3, ($e * $f - 1) % 3);
    my $hash = $arr->[$m];
    $hash->{join ("", sort ($m, $n, $o, $p, $q, $r))} = join ("", $a, $b, $c, $d, $e, $f); 
}

print Dumper($arr);

#my @lines = map {my $list = $arr->{$_}; join ", ", @$list} keys %$arr;
#print join ("\n", @lines);
