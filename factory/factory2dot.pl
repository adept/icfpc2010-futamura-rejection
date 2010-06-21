# use strict;

my $dot_header =<<EOL;
digraph tree {
  concentrate=true;
  node [shape = record];
  XI[label="To world\\n(output)"]
  XO[label="From world\\n(input)"];
EOL

my $dot_footer ="\n}";


my $line = "";
while(<>) {
    chomp;
    $line=$line.$_
};

print $dot_header;
$line =~ s/(\d+)([LR]):// or die "Cannot find external node connection $line.\n";
print "XO -> $1:$2I\n";

my $n=0;
while($line) {
        if($line =~ s/^(X|(\d+)([RL]))(X|(\d+)([RL]))(\d)#(X|(\d+)([RL]))(X|(\d+)([RL])),?//) {
            print "// Parsing $&\n";
            print "// Parsed $1,$2,$3,$4,$5,$6.$7.$8,$9.${10}.${11},${12}.${13}\n";
            print "$n [label=\"{<LI>LI|<LO>LO}|$n|{<RI>RI|<RO>RO}\"]\n";
            if ($1 eq "X") {
                print "XO -> $n:LI\n";
            } else {
                print "$2:$3O -> $n:LI\n";
            }
            if ($4 eq "X") {
                print "XO -> $n:RI\n";
            } else {
                print "$5:$6O -> $n:RI\n"
            };
#            if ($8 eq "X") {
#                print "$n:LO -> XI\n";
#            } else {
#                print "$n:LO -> ${9}:${10}I\n"
#            };
#            if ($11 eq "X") {
#                print "$n:RO -> XI\n";
#            } else {
#                print "$n:RO -> ${12}:${13}I\n"
#            };
            if ($n>0) {
                my $prev = $n-1;
                print "$prev -> ${n}[style=invis]\n";
            }
            ++$n;
        } elsif ($line =~ s/^:(\d+)([LR])$//) {
            print "$1:$2O->XI\n";
        } else {
            die "Syntax error: $line\n";
        }
}

print $dot_footer;

