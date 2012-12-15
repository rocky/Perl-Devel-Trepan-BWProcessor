# -*- coding: utf-8 -*-
# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>

use warnings; no warnings 'redefine'; 
use rlib '../../..';

# Interface for debugging a program but having user control
# reside outside of the debugged process, possibly on another
# computer
package Devel::Trepan::Interface::Bullwinkle;
use English qw( -no_match_vars );
our (@ISA);

# Our local modules
use if !@ISA, Devel::Trepan::Interface;
use if !@ISA, Devel::Trepan::IO::Input;
use Devel::Trepan::Util qw(hash_merge);
# use if !@ISA, Devel::Trepan::IO::TCPServer;
use if !@ISA, Devel::Trepan::IO::Input;

use strict; 

@ISA = qw(Devel::Trepan::Interface Exporter);

use constant DEFAULT_INIT_CONNECTION_OPTS => {
    io => 'TCP',
    logger => undef  # An Interface. Complaints go here.
};

use constant DEFAULT_INPUT_OPTS => {
    readline   =>                        # Try to use Term::ReadLine?
        $Devel::Trepan::IO::Input::HAVE_TERM_READLINE, 
    # The below are only used if we want and have readline support.
    # See method Trepan::term_readline below.
    histsize => 256,                     # Use gdb's default setting
    file_history   => '.trepanplbw_hist',  # where history file lives
                                         # Note a directory will 
                                         # be appended
    history_save   => 1                  # do we save the history?
};

sub new
{
    my($class, $inp, $out, $opts) = @_;
    my $connection_opts = hash_merge($opts->{connection_opts}, DEFAULT_INIT_CONNECTION_OPTS);
    my $input_opts = hash_merge($opts->{input_opts}, DEFAULT_INPUT_OPTS);
  
    # at_exit { finalize };
    ## FIXME:
    my $self = {
        output => $out || *STDOUT,
        input  => Devel::Trepan::IO::Input->new($inp, $input_opts),
        logger => $connection_opts->{logger},
	opts   => $opts
    };
    bless $self, $class;
    return $self;
}
  
# # Closes both input and output
# sub close($)
# {
#     my ($self) = @_;
#     if ($self->{inout} && $self->{inout}->is_connected) {
#         $self->{inout}->write(QUIT . 'bye');
#         $self->{inout}->close;
#     }
# }
  
sub is_closed($) 
{
    my($self)  = shift;
    # FIXME: 
    # $self->{input}->is_eof && $self->{output}->is_eof;
    0
}

sub is_interactive($)
{
    my $self = shift;
    $self->{input}->is_interactive;
}

sub has_completion($)
{
    my $self = shift;
    $self->{input}{term_readline};
}

# Called when a dangerous action is about to be done to make sure
# it's okay. `prompt' is printed; user response is returned.
# FIXME: make common routine for this and user.rb
sub confirm($;$$)
{
    my ($self, $prompt, $default) = @_;
    $default = 1 unless defined($default);
    return $default;
}
  
sub is_input_eof($)
{
    my ($self) = @_;
    0;
}

# used to write to a debugger that is connected to this
# server; 

### FIXME: 
use Data::Dumper; 
sub msg($;$)
{
    my ($self, $msg) = @_;
    ### FIXME
    print Data::Dumper::Dumper($msg), "\n";
    # $self->{inout}->writeline(PRINT . $msg);
}

# used to write to a debugger that is connected to this
# server; `str' written will have a newline added to it
sub errmsg($;$)
{
    my ($self, $msg) = @_;
    ### FIXME
    print Data::Dumper::Dumper($msg), "\n";
    # $self->{inout}->writeline(SERVERERR . $msg);
}

sub readline($;$) {
    my($self, $prompt)  = @_;
    $self->{output}->flush;
    if ($self->{input}{readline}) {
        $self->{input}->readline($prompt);
    } else { 
        $self->{output}->write($prompt . "\n: ") if defined($prompt) && $prompt;
        $self->{input}->readline;
    }
}

# read a debugger command
sub read_command($$)
{
    my ($self) = @_;
    my $cmd_str = $self->readline("Bullwinkle read: ");
    print "$cmd_str" if $self->{opts}{echo_read};
    eval($cmd_str);
}

# Demo
unless (caller) {
    my $intf = Devel::Trepan::Interface::Bullwinkle->new();
    $intf->msg('Testing 1, 2, 3..');
    if (@ARGV) {
	my $val = $intf->read_command();
	print "$val\n" if $val;
    }
}

1;
