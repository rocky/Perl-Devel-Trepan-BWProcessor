# -*- coding: utf-8 -*-
# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>
use warnings; no warnings 'redefine';

use rlib '../../../..';

# require_relative '../../app/condition'

package Devel::Trepan::CmdProcessor::Command::Next;
=head1 Next

Step one statement ignoring steps into function calls at this level.
Sometimes this is called 'step over'.

=head2 Input Fields

 { command  => 'next',
   [count   => <integer>],
 }

If I<count> is given that many statements will be stepped over. If it
is not given, 1 is used, i.e. stop at the next statement.

=head2 Output Fields

 { name     => 'next',
   count    => <integer>,
   [errmsg  => <error-message-array>]
   [msg     => <message-text array>]
 }

=cut

use if !@ISA, Devel::Trepan::CmdProcessor::Command ;

unless (@ISA) {
    eval <<'EOE';
    use constant ALIASES    => qw(n next+ next- n+ n-);
    use constant CATEGORY   => 'running';
    use constant SHORT_HELP => 'Step program without entering called functions';
    use constant MIN_ARGS   => 0; # Need at least this many
    use constant MAX_ARGS   => 1; # Need at most this many - 
                                  # undef -> unlimited.
    use constant NEED_STACK => 1;
EOE
}

use strict;
use vars qw(@ISA); @ISA = @CMD_ISA;
use vars @CMD_VARS;  # Value inherited from parent

our $NAME = set_name();

# This method runs the command
sub run($$) {
    my ($self, $args) = @_;
    my $proc = $self->{proc};
    my $opts = $proc->parse_next_step_suffix($args->[0]);
    
    # FIXME: parse and adjust step count
    $proc->{skip_count} = 0;

    $proc->next($opts);
}

unless (caller) {
  # require_relative '../mock'
  # dbgr, cmd = MockDebugger::setup
  # p cmd.run([cmd.name])
}

1;
