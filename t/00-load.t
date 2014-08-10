#!/usr/bin/env perl -T
use Test::More tests => 1;

BEGIN {
    use_ok( 'Lingua::ManagementSpeak' ) || print "Bail out!\n";
}

diag( "Testing DBIx::Query $DBIx::Query::VERSION, Perl $], $^X" );
