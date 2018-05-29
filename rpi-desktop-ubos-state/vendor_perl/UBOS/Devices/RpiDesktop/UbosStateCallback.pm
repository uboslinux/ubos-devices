#!/usr/bin/perl
#
# Callback when the ubos-state changes
#
# Copyright (C) 2017 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package UBOS::Devices::RpiDesktop::UbosStateCallback;

use UBOS::Devices::RpiDesktop::PinAssignments;

##
# Callback
# $newState: the new state
# return: number of errors
sub stateChanged {
    my $newState = shift;

    my $flag = 0;
    if( 'InMaintenance' eq $newState ) {
        $flag = 1;
    }

    UBOS::Utils::myexec( 'gpio write ' . $UBOS::Devices::RpiDesktop::PinAssignments::statusLedPin . ' ' . $flag );

    return 0;
}

1;

