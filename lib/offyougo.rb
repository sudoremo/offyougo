require 'yaml'
require 'highline/import'
require 'colorize'
require 'offyougo/volume_watcher'
require 'offyougo/app'

module Offyougo
  def self.root
    @root || (File.expand_path '../..', __FILE__)
  end

  def self.version
    @version || (IO.read(File.join(root, 'VERSION').chomp))
  end
end