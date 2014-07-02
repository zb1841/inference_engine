#!/usr/bin/perl
$rand=rand();
$rand2=rand();
system("./reason.pl  $ARGV[2] $ARGV[1]  /tmp/$rand");
system("cat /tmp/$rand $ARGV[1]  > /tmp/$rand2");
system("sort  /tmp/$rand2|uniq > /tmp/$rand");
system("./reason.pl    $ARGV[2]  /tmp/$rand    $ARGV[3]");
print ".reason.pl  $ARGV[2]  /tmp/$rand    $ARGV[3]\n";
unlink ("/tmp/$rand");
unlink ("/tmp/$rand2");
