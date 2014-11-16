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

    setContentView(runaround.scene)

    Thread.new do
      runaround.run
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

end
