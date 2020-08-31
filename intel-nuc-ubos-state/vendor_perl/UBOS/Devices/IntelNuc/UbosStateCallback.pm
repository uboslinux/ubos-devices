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
# Callback. We basically try out the various values for the various NUCs,
# and rely on the fact that so far, for supported models, there is no overlap,
# so one of them and only one is supposed to work
#
# $newState: the new state
# return: number of errors
sub stateChanged {
    my $newState = shift;

    my $nucLedValues = undef;
    if( 'Operational' eq $newState ) {

        $nucLedValues = [
            # NUC6, NUC7:
            #   ring: 80,none,blue
            '02 02 50 04 04',
            #   power: power (factory setting)

            # NUC 10:
            #   hdd: off
            '05 01 04 00 00', # software controlled
            '06 02 04 00 00', # brightness zero
            #   power: power (factory setting)

        ];

    } elsif( 'InMaintenance' eq $newState ) {

        $nucLedValues = [
            # NUC6, NUC7:
            #   ring: 80,fade_slow,yellow
            '02 02 50 06 03',
            #   power: power (factory setting)

            # NUC 10:
            #   hdd: white, breathing, 1Hz
            '05 01 04 00 00', # software controlled
            '06 02 04 00 50', # brightness 80
            '06 02 04 01 01', # breathing
            '06 02 04 02 0a', # blinking frequency
            '06 02 04 03 01', # white
            #   power: power (factory setting)

        ];

    } elsif( 'ShuttingDown' eq $newState ) {

        $nucLedValues = [
            # NUC6, NUC7:
            #   ring: 0,none,green -- cannot be stopped when poweroff, nor started when boot starts
            '02 02 00 04 06',
            #   power: power (factory setting)

            # NUC 10:
            #   hdd: off
            '05 01 04 00 00', # software controlled
            '06 02 04 00 00', # brightness zero
            #   power: power (factory setting)

        ];

    } elsif( 'Rebooting' eq $newState ) {

        $nucLedValues = [
            # NUC6, NUC7:
            #   ring: 80,fade_slow,green -- cannot be stopped when poweroff, nor started when boot starts
            '02 02 50 06 06',
            #   power: power (factory setting)

            # NUC 10:
            #   hdd: off
            '05 01 04 00 00', # software controlled
            '06 02 04 00 00', # brightness zero
            #   power: power (factory setting)

        ];

    } elsif( 'Error' eq $newState ) {

        $nucLedValues = [
            # NUC6, NUC7:
            #   ring: 80,none,red
            '02 02 50 04 05',
            #   power: power (factory setting)

            # NUC 10:
            #   hdd: white, solid
            '05 01 04 00 00', # software controlled
            '06 02 04 00 64', # brightness 100
            '06 02 04 01 00', # solid
            '06 02 04 03 01', # white
            #   power: power (factory setting)

        ];

    } else {
        error( 'Unknown new state:', $newState );
    }

    if( $nucLedValues ) {
        if( -e $specialFile ) {
            foreach my $data ( @$nucLedValues ) {
                UBOS::Utils::saveFile( $specialFile, "$data\n" );
            }
        } else {
            warning( 'Special NUC LED file not found:', $specialFile );
        }
    }
    return 0;
}

1;

