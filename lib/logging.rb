# frozen_string_literal: true
require 'logger'

class Logging
  def self.create
    log = Logger.new(File.expand_path('./log/development.log'))
    log.level = Logger::INFO
    log
  end
end
