#!/usr/bin/perl
#
# Callback when the ubos-state changes. While we are in maintenance,
# we want to blink the LED. However. Desktop Pi will also trigger
# involuntary poweroff 30 seconds after the LED started blinking. So
# we artificially keep the system up...
#
# Copyright (C) 2017 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package UBOS::Devices::RpiDesktop::UbosStateCallback;

my $statusLedPin = 22;

##
# Callback
# $newState: the new state
# return: number of errors
sub stateChanged {
    my $newState = shift;

    my $command = 'stop';
    if( 'InMaintenance' eq $newState ) {
        $command = 'start';
    }

    UBOS::Utils::myexec( "systemctl $command rpi-desktop-keep-flashing.service" );

    return 0;
}

1;

