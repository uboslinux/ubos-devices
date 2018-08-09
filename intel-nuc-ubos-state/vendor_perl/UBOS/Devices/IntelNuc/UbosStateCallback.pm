#!/usr/bin/perl
#
# Callback when the ubos-state changes
#
# Copyright (C) 2017 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package UBOS::Devices::IntelNuc::UbosStateCallback;

use UBOS::Logging;
use UBOS::Utils;

my $specialFile = '/proc/acpi/nuc_led';

##
# Callback
# $newState: the new state
# return: number of errors
sub stateChanged {
    my $newState = shift;

    my $nucLedValue = undef;
    if( 'Operational' eq $newState ) {
        $nucLedValue = 'ring,80,none,blue';
    } elsif( 'InMaintenance' eq $newState ) {
        $nucLedValue = 'ring,80,fade_slow,yellow';
    } elsif( 'ShuttingDown' eq $newState ) {
        $nucLedValue = 'ring,0,none,green'; # cannot be stopped when poweroff, nor started when boot starts
    } elsif( 'Rebooting' eq $newState ) {
        $nucLedValue = 'ring,80,fade_slow,green'; # cannot be stopped when poweroff, nor started when boot starts
    } elsif( 'Error' eq $newState ) {
        $nucLedValue = 'ring,80,none,red';
    } else {
        error( 'Unknown new state:', $newState );
    }

    if( $nucLedValue ) {
        if( -e $specialFile ) {
            UBOS::Utils::saveFile( $specialFile, "$nucLedValue\n" );
        } else {
            warning( 'Special NUC LED file not found:', $specialFile );
        }
    }
    return 0;
}

1;

