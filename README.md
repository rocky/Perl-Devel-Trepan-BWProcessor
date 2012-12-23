Devel::Trepan::BWProcessor -- A Bullwinkle-protocol processor for Devel::Trepan
====================================

This module adds the ability to speak the Bullwinkle protocol. It is
intended as a more programmer-friendly interface for front-ends
wanting to communicate with the debugger Devel::Trepan.

## Usage

Distributed with this code are some simple front ends used for testing and as a demonstration. We show their use below. 

First a shell session without sockets: 

    $ ./bin/trepanbw.pl example/gcd.pl 3 5
    {
      'location' => {
                      'canonic_filename' => '/tmp/example/gcd.pl',
                      'line_number' => 18,
                      'filename' => 'example/gcd.pl',
                      'package' => 'main'
                      'op_addr' => 182625304
                    },
      'text' => 'die sprintf "Need two integer arguments, got %d", scalar(@ARGV) unless ',
      'name' => 'stop_location',
      'event' => 'line',
    }

    Bullwinkle read: {command =>'step', count => 3}
    {
      'count' => 3,
      'name' => 'step'
    }
    
    {
      'location' => {
                      'canonic_filename' => '/tmp/example/gcd.pl',
                      'function' => 'main::gcd',
                      'line_number' => 20,
                      'filename' => 'example/gcd.pl',
                      'package' => 'main'
                      'op_addr' => 182625832
                    },
      'text' => 'my ($a, $b) = @ARGV[0,1];',
      'name' => 'stop_location',
      'event' => 'line',
    }

    Bullwinkle read: {command =>'quit'}
    {
     'name' => 'quit'
    }


And now an example over a TCP/IP socket. In a shell: 

    $ ./bin/trepanbw.pl --server example/gcd.pl 3 5

Then in a second shell: 

    $ perl ./BWClient.pm 
    Enter BW command: Got back...
    {
      'location' => {
                      'canonic_filename' => '/tmp/example/gcd.pl',
                      'filename' => 'example/gcd.pl',
                      'line_number' => 18,
                      'package' => 'main'
                      'op_addr' => 171383552
                    },
      'text' => 'die sprintf "Need two integer arguments, got %d", scalar(@ARGV) unless ',
      'name' => 'stop_location',
      'event' => 'line',
    }
    {'command'=>'quit', exit_code => 1}
    Enter BW command: Got back...
    {
      'name' => 'quit'
    }
    Remote debugged process closed connection

   
    

LICENSE AND COPYRIGHT
---------------------

Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>

This program is distributed WITHOUT ANY WARRANTY, including but not
limited to the implied warranties of merchantability or fitness for a
particular purpose.

The program is free software. You may distribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation (either version 2 or any later version) and
the Perl Artistic License as published by O’Reilly Media, Inc. Please
open the files named gpl-2.0.txt and Artistic for a copy of these
licenses.
