# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>
use warnings; no warnings 'redefine';

use rlib '../../../..';

package Devel::Trepan::BWProcessor::Command::Info_Program;
=pod

=head1 Info_Program

Information about debugged program and its environment

=head2 Input Fields

 { command => 'info_program',
 }


=head2 Output Fields

 { name       => 'info_program',
   event      => <event-name>,
   program    => <program-name>
   [address   => <op-address>],
   [errmsg    => <error-message-array>],
   [msg       => <message-text array>]
 }

<event-name> is one of the kinds of stopping events, e.g. 'line', 'breakpoint', 'interrupt', etc.
The address is the current OP address if the program is currently running.

=cut

use if !@ISA, Devel::Trepan::BWProcessor::Command ;

use strict;

use vars qw(@ISA); @ISA = @CMD_ISA; 
use vars @CMD_VARS;  # Value inherited from parent
our $NAME = set_name();

# This method runs the command
sub run($$)
{
    my ($self, $args) = @_;
    my $proc = $self->{proc};
    my $response = { 
	'name'  => $NAME,
	'event' => $proc->{event}
    };
    $response->{'program'} = $DB::ini_dollar0 if
	defined($DB::ini_dollar0) && $DB::ini_dollar0;
    $response->{'address'} = $DB::OP_addr if 
	defined($DB::OP_addr);
    if ($DB::brkpt) {
        $response->{breakpoint} = {
	    'type' => $DB::brkpt->type eq 'tbrkpt' ? 'temporary ' : 'permanent',
	    'id'   => $DB::brkpt->id
	}
    }
    $proc->{response} = $response;

}

unless (caller) {
    my $cmd = __PACKAGE__->new();
    my $value = $cmd->run({});
    require Data::Dumper;
    print Data::Dumper::Dumper($value), "\n";
}

1;
