require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper.rb"))

require 'tyrant_manager'

describe TyrantManager do
  before( :each ) do
    @tdir = File.join( temp_dir, 'tyrant' )
    TyrantManager::Log.silent {
      @tyrant  = TyrantManager.setup( @tdir )
    }
  end

  after( :each ) do
    FileUtils.rm_rf @tdir
  end

  describe "#default_directory" do
    it "uses the current working directory" do
      Dir.chdir( @tdir ) do |d|
        TyrantManager.default_directory.should == d
      end
    end

    it "uses the TYRANT_MANAGER_HOME environment variable" do
      ENV['TYRANT_MANAGER_HOME'] = @tdir
      TyrantManager.default_directory.should == @tdir
    end
  end

  it "initializes with an existing directory" do
    t = TyrantManager.new( @tdir )
    t.config_file.should == File.join( @tdir, "config.rb" )
  end

  it "raises an error if attempting to initialize from a non-existent tyrnat home" do
    lambda { TyrantManager.new( "/tmp" ) }.should raise_error( TyrantManager::Error, /\/tmp is not a valid archive/ )
  end

  it "#config_file" do
    @tyrant.config_file.should == File.join( @tdir, "config.rb" )
    File.exist?( @tyrant.config_file ).should == true
  end

  it "#configuration" do
    @tyrant.configuration.should_not == nil
  end

  it "has the location of the ttserver command" do
    @tyrant.configuration.ttserver.should == "ttserver"
  end
end