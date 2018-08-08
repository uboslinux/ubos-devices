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

    if( 'Operational' eq $newState ) {
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $bluePin,  1 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $redPin,   0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $greenPin, 0 );

    } elsif( 'InMaintenance' eq $newState ) {
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $bluePin,  0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $redPin,   1 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $greenPin, 1 );

    } elsif( 'Error' eq $newState ) {
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $bluePin,  0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $redPin,   1 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $greenPin, 0 );

    } elsif( 'ShuttingDown' eq $newState ) {
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $bluePin,  0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $redPin,   0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $greenPin, 1 );

    } elsif( 'Rebooting' eq $newState ) {
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $bluePin,  0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $redPin,   0 );
        UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $greenPin, 1 );

    } else {
        error( 'Unknown new state:', $newState );
    }

    UBOS::Devices::ESPRESSObin::Gpio::setOutputPin( $fanPin, 1 );

    return 0;
}

1;

