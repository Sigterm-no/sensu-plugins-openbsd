## Sensu-Plugins-OpenBSD

[![Build Status](https://travis-ci.org/Sigterm-no/sensu-plugins-openbsd.svg?branch=master)](https://travis-ci.org/Sigterm-no/sensu-plugins-openbsd)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-openbsd.svg)](https://badge.fury.io/rb/sensu-plugins-openbsd)

## Checks

* `bin/check-bgpd.rb` - A check for OpenBGPd peers health
* `bin/check-cmd.rb` - A check that runs a choosen command and can regex it's output
* `bin/check-ntp.rb` - A check that queries ntpctl
* `bin/check-process.rb` - A check to find running processes

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

Quick install after following the steps above:

    $ sensu-install24 -p 'sensu-plugins-openbsd'

The checks will be installed at:

    /usr/local/bin


