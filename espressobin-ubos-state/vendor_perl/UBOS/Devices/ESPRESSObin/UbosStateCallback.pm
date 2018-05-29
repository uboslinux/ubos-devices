#!/usr/bin/perl
#
# Callback when the ubos-state changes
#
# Copyright (C) 2017 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package UBOS::Devices::ESPRESSObin::UbosStateCallback;

use UBOS::Devices::ESPRESSObin::Gpio;

use UBOS::Logging;
use UBOS::Utils;

my $bluePin  = 495;
my $redPin   = 494;
my $greenPin = 477;
my $fanPin   = 493;

my @ledPins = ( $bluePin, $redPin, $greenPin );

##
# Callback
# $newState: the new state
# return: number of errors
sub stateChanged {
    my $newState = shift;

    my $onPin = -1;
    if( 'BootingOrShuttingDown' eq $newState ) {
        $onPin = $greenPin;
    } elsif( 'Operational' eq $newState ) {
        $onPin = $bluePin;
    } elsif( 'InMaintenance' eq $newState ) {
        $onPin = $redPin;
    } else {
        error( 'Unknown new state:', $newState );
    }
    if( $onPin >= 0 ) {
        foreach my $pin ( @ledPins ) {
            UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $pin, $pin == $onPin );
        }
    }
    UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $fanPin, 1 );

    return 0;
}

1;

