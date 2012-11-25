# -*- coding: utf-8 -*-
require 'net/irc'

class Stig::Server < Net::IRC::Server::Session
  def server_name
    'stig'
  end

  def server_version
    Stig::VERSION
  end

  def on_user(m)
    super

    p 'on_user', m
    post @prefix, JOIN, '#timeline'
    begin
      @thread = Thread.new do
        IO.popen("ls").each_line{|l|
          post @prefix, PRIVMSG, '#timeline', l.strip
        }
      end
    end
  end

  def on_disconnected
    p 'on_disconnected'
    @thread.kill rescue nil
  end

  def on_privmsg(m)
    target, msg = *m.params
    p 'on_privmsg', m
  end
end
