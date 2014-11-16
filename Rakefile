# Write your own rake tasks here.
# You can find the Ruboto rake tasks in rakelib/ruboto.rake

require 'fileutils'
require 'pathname'

namespace :gamecore do
  desc 'import runaround source files from submodule'
  task :import do
    dest = Pathname.new('.').expand_path('src/gamecore').to_s
    Dir.chdir 'runaround/lib' do
      files = Dir.glob('**/*').reject {|name| name.include? 'ray' }
      FileUtils.cp_r files, dest, verbose: true
    end
  end
end
