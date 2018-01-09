#!/usr/bin/perl
#
# Callback when the ubos-state changes
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
}

1;

