#!/usr/bin/env ruby
require 'rubygems'
require 'ruby_expect'

unless ARGV.size == 2
  puts 'Usage:'
  puts 'rhc_setup <uname> <passwd>'
  exit
end

uname = ARGV.first
passwd = ARGV.last

rhc_cmd = RubyExpect::Expect.spawn('rhc setup')
rhc_cmd.procedure do
  each do
    expect(/Enter the server hostname/) do
      send "\n"
    end

    expect(/Login to openshift.redhat.com/) do
      send uname
    end

    expect(/Password/) do
      send passwd
    end

    expect(/Generate a token now/) do
      send 'yes'
    end

    expect(/Upload now/) do
      send 'yes'
    end

    expect(/name for this key/) do
      send "\n"
    end
  end
end
