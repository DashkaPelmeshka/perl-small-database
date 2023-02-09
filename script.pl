#!/usr/bin/perl
use utf8;
use strict;
use warnings;


our $DEBUG = 0;

our $VARIABLE_FORMAT = qr/[a-zA-Z]\w*/;
our $VALUE_FORMAT = qr/\d+/;

my %DATABASE = ();
my $NULL = 'NULL';

sub debug_print {
  my @args = @_;
  print join(' ', "DEBUG:", @args)."\n" if $DEBUG;
}


sub GET {
  my ($variable) = @_;
  my $value = exists($DATABASE{$variable}) ? $DATABASE{$variable} : $NULL;
  debug_print "GET $variable = $value";
  return $value;
}

sub SET {
  my ($variable, $value) = @_;
  $DATABASE{$variable} = $value;
  debug_print "SET $variable = $value";
}

sub UNSET {
  my ($variable) = @_;
  delete $DATABASE{$variable};
  debug_print "UNSET $variable";
}

sub COUNTS {
  my ($value) = @_;
  my $count = grep { $_ eq $value } values %DATABASE;
  debug_print "COUNTED $value: $count";
  return $count;
}


if ( @ARGV ) { 
  if (($ARGV[0] eq '-h') || ($ARGV[0] eq '-help')) {
    show_help();
    exit;
  }

  if (($ARGV[0] eq '-d') || ($ARGV[0] eq '-debug')) {
    shift @ARGV;
    $DEBUG = 1;
  }
}

my $line;
while (defined($line = <>)) {
  chomp $line;

  if ($line =~ /^GET\s+(${VARIABLE_FORMAT})$/iu) { # GET
    my $variable = $1;
    my $value = GET $variable;
    print "$value\n";
  } elsif ($line =~ /^SET\s+(${VARIABLE_FORMAT})\s+(${VALUE_FORMAT})$/iu) {  # SET
    my ($variable, $value) = ($1, $2);
    SET $variable, $value;
  } elsif ($line =~ /^COUNTS\s+(${VALUE_FORMAT})$/iu) {  # COUNTS
    my ($value) = ($1);
    my $count = COUNTS $value;
    print "$count\n";
  } elsif ($line =~ /^UNSET\s+(${VARIABLE_FORMAT})$/iu) {  # UNSET
    my ($variable) = ($1);
    UNSET $variable;
  } elsif ($line =~ /^BEGIN$/iu) {  # BEGIN
    #todo
  } elsif ($line =~ /^ROLLBACK$/iu) {  # ROLLBACK
    #todo
  } elsif ($line =~ /^COMMIT$/iu) {  # COMMIT
    #todo
  } elsif ($line =~ /^end$/iu) {  # END
    exit;
  } else { # ERROR IN ARGUMENT
      print "
ERROR IN COMMAND
Please, check arguments and try again:
only GET, SET, UNSET, COUNTS, FIND, END,
BEGIN, ROLLBACK, COMMIT commands are available.
\n";
  }
}

# В программе использовались следующие предположения:
# 1) Переменные могут 
# 2) Значения могут 