require 'rubygems'
require 'spec'
require 'logging'

$:.unshift File.expand_path( File.join( File.dirname( __FILE__ ),"..","lib"))


Logging::Logger['TyrantManager'].level = :all

module Spec
  module Log
    def self.io
      @io ||= StringIO.new
    end
    def self.appender
      @appender ||= Logging::Appenders::IO.new( "speclog", io )
    end

    Logging::Logger['TyrantManager'].add_appenders( Log.appender )

    def self.layout
      @layout ||= Logging::Layouts::Pattern.new(
        :pattern      => "[%d] %5l %6p %c : %m\n",
        :date_pattern => "%Y-%m-%d %H:%M:%S"
      )
    end

    Log.appender.layout = layout
  end

  module Helpers
    require 'tmpdir'
    def temp_dir( unique_id = $$ )
      dirname = File.join( Dir.tmpdir, "tyrant-spec-#{unique_id}" )
      FileUtils.mkdir_p( dirname ) unless File.directory?( dirname )
      # for osx
      dirname = Dir.chdir( dirname ) { Dir.pwd }
    end

    def spec_log
      Log.io.string
    end
  end
end

Spec::Runner.configure do |config|
  config.include Spec::Helpers

  config.before do
    Spec::Log.io.rewind
    Spec::Log.io.truncate( 0 )
  end

  config.after do
    Spec::Log.io.rewind
    Spec::Log.io.truncate( 0 )
  end
end
