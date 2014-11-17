require 'ruboto/widget'
require 'ruboto/util/toast'

require_relative 'gamecore/runaround'
require_relative 'ui'

ruboto_import_widgets :Button, :LinearLayout, :TextView

# http://xkcd.com/378/

class RunaroundActivity
  def onCreate(bundle)
    super
    set_title 'runaround'
    runaround = Runaround.new(UiFactory.new(self))

    puts 'XXXXXXXXXXXXXCREATE'

    setContentView(runaround.scene)

    Thread.new do
      begin
        runaround.run
      rescue Exception
        puts "Exception running game: #{$!}"
        puts $!.backtrace.join("\n")
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

end
