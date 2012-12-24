# -*- coding: utf-8 -*-
# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>

package Devel::Trepan::BWClient;
use strict;
use rlib;

# require_relative 'default'                # default debugger settings

use Devel::Trepan::Interface::BWClient;
use English qw( -no_match_vars );

sub new
{
    my ($class, $settings) = @_;
    my  $intf = Devel::Trepan::Interface::BWClient->new( 
        undef, undef, undef, undef, 
        {host => $settings->{host},
         port => $settings->{port}}
        );
    my $self = {
        intf => $intf,
        user_inputs => [$intf->{user}]
    };
    bless $self, $class;
}

sub msg($$)
{
    my ($self, $msg) = @_;
    chomp $msg;
    $self->{intf}{user}->msg($msg);
}

use threads;

sub start_client($)
{
    my $options = shift;
    my $client = Devel::Trepan::BWClient->new(
        {client      => 1,
         cmdfiles    => [],
         initial_dir => $options->{chdir},
         nx          => 1,
         host        => $options->{host},
         port        => $options->{port}}
    );
    my $intf = $client->{intf};
    my $response;

    my $thr = threads->create(
        sub {
            while (1) {
                eval {
                    $response = $intf->read_remote;
                };
                if ($EVAL_ERROR) {
                    $client->msg("Remote debugged process closed connection");
                    last;
                }
                $Data::Dumper::Terse     = 1;
		$Data::Dumper::Sortkeys  = 1;
                print Data::Dumper::Dumper($response);
            }
        });

    while (1) {
        my $command;
        eval {
            $command = $client->{user_inputs}[0]->read_command('Enter BW command: ');
        };
        if ($EVAL_ERROR) {
            if (scalar @{$client->{user_inputs}} == 0) {
                $client->msg("user-side EOF. Quitting...");
                last;
            };
        }
        $intf->write_remote($command);
    }
    $thr->join();
}

unless (caller) {
    Devel::Trepan::BWClient::start_client({host=>'127.0.0.1', port=>1964});
}

1;
