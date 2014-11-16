module RubotoUi

  class Scene < android.view.View
    java_import "android.graphics.Color"
    java_import "android.graphics.Paint"
    java_import "android.graphics.RectF"

    def initialize(context)
      clear
      init_paints
      super
    end

    def clear
      @drawers = []
    end

    def draw_location(location)
      @drawers << ->(canvas) {
        canvas.drawCircle(location.x, location.y, 20, @location_paint)
      }
    end

    def draw_actor(actor)
      @drawers << ->(canvas) {
        canvas.drawCircle(actor.x, actor.y, 20, @actor_paint)
      }
    end

    def draw_patch(patch)
      puts patch.to_s
    end

    def draw_button(button)
      puts button.to_s
    end
    
    def onDraw(canvas)
      puts "in onDraw !!!!!!!!!!!!!!!!!!!!!!! xxxxxxxxxxxxxxxxxxxx"
      canvas.drawColor(Color::BLACK)
      @drawers.each do |drawer|
        drawer.call(canvas)
      end
    end
    
    private

    def init_paints
      base_paint = Paint.new
      base_paint.anti_alias = true
      @actor_paint = Paint.new(base_paint)
      @actor_paint.color = Color::WHITE
      @location_paint = Paint.new(base_paint)
      @location_paint.color = Color::BLUE
    end
  end

  class Cycle
    attr_reader :game, :scene
    def initialize(game, scene)
      @game = game
      @scene = scene
    end
    def start(&block)
      interval = 0.1
      while true do
        puts "time: #{Time.now.to_f}"
        game.instance_exec interval, &block
        scene.postInvalidate
        sleep interval
      end
    end
  end

end
class UiFactory
  def initialize(context)
    @scene = RubotoUi::Scene.new context
  end
  def scene
    @scene
  end
  def cycle(game)
    RubotoUi::Cycle.new game, @scene
  end
end
