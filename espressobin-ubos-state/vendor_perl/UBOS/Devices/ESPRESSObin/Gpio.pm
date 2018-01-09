#!/usr/bin/perl
#
# A GPIO pin
#
# This file is part of ubos-admin.
# (C) 2012-2017 Indie Computing Corp.
#
# ubos-admin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ubos-admin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ubos-admin.  If not, see <http://www.gnu.org/licenses/>.
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

