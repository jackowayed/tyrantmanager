#--
# Copyright (c) 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

#-------------------------------------------------------------------------------
# make sure our project's top level directory and the lib directory are added to
# the ruby search path.
#-------------------------------------------------------------------------------
$:.unshift File.expand_path(File.join(File.dirname(__FILE__),"lib"))
$:.unshift File.expand_path(File.dirname(__FILE__))


#-------------------------------------------------------------------------------
# load the global project configuration and add in the top level clean and
# clobber tasks so that other tasks can utilize those constants if necessary
# This loads up the defaults for the whole project configuration
#-------------------------------------------------------------------------------
require 'rubygems'
require 'tasks/config.rb'
require 'rake/clean'

#-------------------------------------------------------------------------------
# Main configuration for the project, these overwrite the items that are in
# tasks/config.rb
#-------------------------------------------------------------------------------
require 'tyrant_manager'
Configuration.for("project") {
  name      "tyrantmanager"
  version   TyrantManager::VERSION
  author    "Jeremy Hinegardner"
  email     "jeremy@copiousfreetime.org"
  homepage  "http://tyrant-manager.rubyforge.org/"
}

#-------------------------------------------------------------------------------
# load up all the project tasks and setup the default task to be the
# test:default task.
#-------------------------------------------------------------------------------
Configuration.for("packaging").files.tasks.each do |tasklib|
  import tasklib
end
task :default => 'test:default'

#-------------------------------------------------------------------------------
# Finalize the loading of all pending imports and update the top level clobber
# task to depend on all possible sub-level tasks that have a name like
# ':clobber'  in other namespaces.  This allows us to say:
#
#   rake clobber
#
# and it will get everything.
#-------------------------------------------------------------------------------
Rake.application.load_imports
Rake.application.tasks.each do |t| 
  if t.name =~ /:clobber/ then
    task :clobber => [t.name] 
  end 
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    proj = Configuration.for('project')
    spec.name         = proj.name
    
    spec.author       = proj.author
    spec.email        = proj.email
    spec.homepage     = proj.homepage
    spec.summary      = proj.summary
    spec.description  = proj.description
    spec.platform     = Gem::Platform::RUBY

    
    pkg = Configuration.for('packaging')
    spec.files        = pkg.files.all
    spec.executables  = pkg.files.bin.collect { |b| File.basename(b) }

    # add dependencies here
    spec.add_dependency( "loquacious", "~> 1.3.0")
    spec.add_dependency( "rufus-tokyo", "~> 1.0.0")
    spec.add_dependency( "logging", "~> 1.1.4" )
    spec.add_dependency( "main", "~> 2.8.4" )

    # development dependencies
    spec.add_development_dependency("configuration", ">= 0.0.5")
    spec.add_development_dependency( "rake", "~> 0.8.3")

    if ext_conf = Configuration.for_if_exist?("extension") then
      spec.extensions << ext_conf.configs
      spec.extensions.flatten!
    end
    
    if rdoc = Configuration.for_if_exist?('rdoc') then
      spec.has_rdoc         = true
      spec.extra_rdoc_files = pkg.files.rdoc
      spec.rdoc_options     = rdoc.options + [ "--main" , rdoc.main_page ]
    else
      spec.has_rdoc         = false
    end 

    if test = Configuration.for_if_exist?('testing') then
      spec.test_files       = test.files
    end 

    if rf = Configuration.for_if_exist?('rubyforge') then
      spec.rubyforge_project  = rf.project
    end 

  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
