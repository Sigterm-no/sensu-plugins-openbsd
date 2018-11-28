#!/usr/bin/env ruby
#
#   check-bgpd
#
# DESCRIPTION:
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   OpenBSD
#
# DEPENDENCIES:
#   gem: sensu-plugin

require 'sensu-plugin/check/cli'

class CheckOpenBGPd < Sensu::Plugin::Check::CLI
  option :warn,
         short: '-w WARN',
         description: 'Percetage of peers in a connecting/not-working state before warning',
         proc: proc(&:to_f),
         default: 50

  option :crit,
         short: '-c CRIT',
         description: 'Percetage of peers in a connecting/not-working state before critical',
         proc: proc(&:to_f),
         default: 90

  def run
    begin
      num_peers = `bgpctl show | egrep -v "Connect$|Active$" | tail -n +2 | wc -l`.strip.to_i
      num_issue_peers = `bgpctl show | egrep '(Active|Connect)$' | wc -l`.strip.to_i
      num_fib_routes = `bgpctl show fib | tail -n +6 | wc -l`.strip.to_i
      num_rib_routes = `bgpctl show rib | tail -n +7 | wc -l`.strip.to_i

      total_peers = num_peers + num_issue_peers
      peers_success_ratio = ((num_peers.to_f / total_peers.to_f) * 100).truncate(2)

      message = "OpenBGPd running with #{total_peers} peers, "
      message << "#{peers_success_ratio}% (#{num_issue_peers}) in a connecting or errored state, "
      message << "#{num_fib_routes}. Knows FIB routes and #{num_rib_routes} RIB routes."
    rescue StandardError => e
      unknown "OpenBGPd command Failed: #{e}"
    end

    critical message if num_peers.zero?
    critical message if peers_success_ratio >= config[:crit] || peers_success_ratio <= -config[:crit]
    warning message if peers_success_ratio >= config[:warn] || peers_success_ratio <= -config[:warn]
    ok message
  end
end
