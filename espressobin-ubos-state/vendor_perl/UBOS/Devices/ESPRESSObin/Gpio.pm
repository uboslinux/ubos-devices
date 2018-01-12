#!/usr/bin/perl
#
# A GPIO pin
#
# Copyright (C) 2017 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package UBOS::Devices::ESPRESSObin::Gpio;

my $pinDirection = {}; # cache of directions

##
# Set the value of a digital output pin
# $pin: pin index
# $value: 0 or 1
sub setOutputPin {
    my $pin   = shift;
    my $value = shift;

    unless( exists( $pinDirection->{$pin} )) {
        unless( -e "/sys/class/gpio/gpio$pin" ) {
            if( UBOS::Utils::myexec( 'cat > /sys/class/gpio/export', "$pin\n" )) {
                error( 'Cannot write', $pin, 'to /sys/class/gpio/export', $@ );
            }
        }
        $pinDirection->{$pin} = '?';
    }
    if( $pinDirection->{$pin} ne 'out' ) {
        if( UBOS::Utils::saveFile( "/sys/class/gpio/gpio$pin/direction", "out\n" ) == 0 ) {
            error( 'Failed to change pin direction:', $pin );
        } else {
            $pinDirection->{$pin} = 'out';
        }
    }
    if( UBOS::Utils::saveFile( "/sys/class/gpio/gpio$pin/value", "$value\n" ) == 0 ) {
        error( 'Failed to change pin value:', $pin );
    }
}

1;

