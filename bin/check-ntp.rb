#! /usr/bin/env ruby
#
#   check-ntp
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
#
# USAGE:
#
# NOTES:
#  warning and critical values are offsets in milliseconds.
#
# LICENSE:
#   Copyright 2018 Sigterm AS, Mikal Villa <support@sigterm.no>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
# Stratum Levels
# 1:      Primary reference (e.g., calibrated atomic clock, radio clock, etc...)
# 2-15:   Secondary reference (via NTP, calculated as the stratum of your system peer plus one)
# 16:     Unsynchronized
# 17-255: Reserved
#
# Source Field Status Codes
# http://doc.ntp.org/current-stable/decode.html

require 'sensu-plugin/check/cli'

class CheckNTP < Sensu::Plugin::Check::CLI
  option :warn,
         short: '-w WARN',
         proc: proc(&:to_f),
         default: 10

  option :crit,
         short: '-c CRIT',
         proc: proc(&:to_f),
         default: 100

  option :stratum,
         short: '-s STRATUM',
         description: 'check that stratum meets or exceeds desired value',
         proc: proc(&:to_i),
         default: 15

  option :unsynced_status,
         short: '-u CODE',
         description: 'If ntp_status is unsynced (that is, not yet connected to or disconnected from ntp), what should the response be.',
         proc: proc(&:downcase),
         default: 'unknown'

  def run
    output = ''
    begin
      output = `ntpctl -s status`
      # Peers
      peers_idx = output.index('peers')
      peers_str = output[0, peers_idx].strip
      peers_array = peers_str.split('/')
      num_connected = peers_array[0]
      num_available = peers_array[1]
      # End peers
      stratum_end_idx = output.index('stratum') + 7
      stratum = output[stratum_end_idx, stratum_end_idx + 3].strip.to_i
      # Synced
      # synced = 'clock synced'
      unsynced = 'clock unsynced'
      # Offset
      offset = output[/offset (...), clock/, 1].strip
    rescue StandardError
      unknown 'NTP command Failed'
    end

    if output.include? unsynced
      case config[:unsynced_status]
      when 'warn'
        warning 'NTP state unsynced'
      when 'crit'
        critical 'NTP state unsynced'
      when 'unknown'
        unknown 'NTP state unsynced'
      end
    end

    if stratum > 15
      critical 'NTP not synced'
    elsif stratum > config[:stratum]
      critical "NTP stratum (#{stratum}) above limit (#{config[:stratum]})"
    end

    offset_f = offset.sub('s', '').to_f

    message = "NTP offset by #{offset} peers #{num_connected}/#{num_available}"
    warning message if num_connected.to_i.zero?
    critical message if offset_f >= config[:crit] || offset_f <= -config[:crit]
    warning message if offset_f >= config[:warn] || offset_f <= -config[:warn]
    ok message
  end
end
