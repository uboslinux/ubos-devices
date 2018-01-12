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

##
# Callback
# $newState: the new state
sub stateChanged {
    my $newState = shift;

    my $nucLedValue = undef;
    if( 'BootingOrShuttingDown' eq $newState ) {
        $nucLedValue = 'ring,80,fade_slow,green';
    } elsif( 'Operational' eq $newState ) {
        $nucLedValue = 'ring,80,none,blue';
    } elsif( 'InMaintenance' eq $newState ) {
        $nucLedValue = 'ring,80,fade_slow,red';
    } else {
        error( 'Unknown new state:', $newState );
    }

    if( $nucLedValue ) {
        UBOS::Utils::saveFile( '/proc/acpi/nuc_led', "$nucLedValue\n" );
    }
}

1;

