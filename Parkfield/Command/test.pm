package Parkfield::Command::test;
use Parkfield -command;
use strict; use warnings;

use MongoDB;
use Data::Dumper;
use feature 'say';

sub abstract { "test a proxy" }

sub description { "Test a proxy from the database." }

sub opt_spec {
    # --next n 
    # --host 123.*.0.* (accepts wildcard patterns)
    return (
      [ "next|n=i",  "test next N untested proxies" ],
      [ "host|t=s@",  "recheck all results"       ],
    );
  }

sub validate_args {
	my ($self, $opt, $args) = @_;
	#do shit
}

sub execute {
	my ($self, $opt, $args) = @_;
	say sprintf("opts: %s\nargs: %s", $opt, $args);
}

1;
