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
        $nucLedValue = 'ring,80,none,green';
    } elsif( 'Operational' eq $newState ) {
        $nucLedValue = 'ring,80,none,blue';
    } elsif( 'InMaintenance' eq $newState ) {
        $nucLedValue = 'ring,80,none,red';
    } else {
        error( 'Unknown new state:', $newState );
    }

    if( $nucLedValue ) {
        UBOS::Utils::saveFile( '/proc/acpi/nuc_led', "$nucLedValue\n" );
    }
}

1;

