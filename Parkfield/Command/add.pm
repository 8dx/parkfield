package Parkfield::Command::add;
use Parkfield -command;
use strict; use warnings;

use MongoDB;
use feature 'say';

sub abstract { "update proxy database" }

sub description { "Add proxies from a text file to proxy database" }

sub validate_args {
	my ($self, $opt, $args) = @_;

	#check if arg is valid file
	my $file = $args->[0];
	$self->usage_error("no file given") if !defined $file;
	$self->usage_error("not a file: $file") if !-f $file;
	
}

sub execute {
#hey you ever hear of something called DRY?
	my ($self, $opt, $args) = @_;

	#check if arg is valid file
	my $file = $args->[0];
#because that part was EXTREMELY WET

	#get file contents
	open my $f, "<", $file;
	my $fileContents;
	#eval {
	#	local $/; #wut record separator lel
	#	$fileContents = <$file>; #slurp $file (turn up)
	#}
	#note: i leave this in just in case slurping makes sense in the future

	#VVVVVV REAL LEET IMPLEMENTATION VVVVVVV
	my @proxies; #array to hold content
	while(chomp(my $line = <$f>)) { #PICK A LINE TAKE A LINE
		my @details = split /:/,$line; #split line into [:host, :proxy]
		push @proxies, \@details; #how do i shot multidimensonal array?
	}
	
	#initialize mongos pls
	
	my $mongo = MongoDB->connect(); #take the pit out the mango
	my $db = $mongo->get_database('proxify'); #change this if u want idc
	my $proxies = $db->get_collection('proxies');
	map {
		my ($host, $port) = @$_;
		if(!(my @find = $proxies->find({host => $host})->all)) {
		#note: there may be a better way to rewrite
		#that logic... but that's my approach for now
			my $object = {
				host => $host, #host of proxy
				port => $port, #port of proxy
				up   => 0,     #assume it's not up
				tests => []    #list of {date => TIMESTAMP, outcome => 0|1} objects representing tests
			}; #template object for new creation		
                my $res = $proxies->insert_one($object); #shove it on in mongo
		say sprintf("%s inserted with ID: %s",$host,$res->inserted_id)
        } else {
                warn "$host already stored. ignoring."
        }
     } @proxies; #lol anonymous subs ftw >>
     say "Done processing $file"; #we done here yet?
}

1;
