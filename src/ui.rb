require 'monitor'

module RubotoUi

  class Scene < android.view.View
    java_import 'android.graphics.Color'
    java_import 'android.graphics.Paint'
    java_import 'android.graphics.RectF'
    java_import 'android.view.MotionEvent'

    include MonitorMixin

    attr_accessor :game

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
        visited = location.state == :visited
        canvas.drawCircle(location.x, location.y, 20, visited ? blue_paint : red_paint)
      }
    end

    def draw_actor(actor)
      @drawers << ->(canvas) {
        canvas.drawCircle(actor.x, actor.y, 20, white_paint)
      }
    end

    def draw_circle(point, radius)
      @drawers << ->(canvas) {
        canvas.drawCircle(point.x, point.y, radius, yellow_paint)
      }
    end 

    def draw_patch(patch)
#      puts patch.to_s
    end

    def draw_button(button)
      @drawers << ->(canvas) {
        canvas.drawCircle(button.point.x, button.point.y, 30, yellow_paint)
      }
    end
    
    def onDraw(canvas)
      puts "onDraw: size: #{get_width}, #{get_height}"
      canvas.drawColor(Color::BLACK)
      synchronize do
        @drawers.each do |drawer|
          drawer.call(canvas)
        end
      end
    end

    def onTouchEvent(event)
      puts event

      if event.get_action_masked == MotionEvent::ACTION_DOWN      
        game.event :press, point: Point.new(event.get_x, event.get_y)
      end

      puts 'handled event ok'
      true
    end

    private

    attr_reader :base_paint, :blue_paint, :red_paint, :yellow_paint, :white_paint

    def init_paints
      @base_paint = Paint.new
      base_paint.anti_alias = true
      @yellow_paint = paint(Color::YELLOW)
      @white_paint = paint(Color::WHITE)
      @blue_paint = paint(Color::BLUE)
      @red_paint = paint(Color::RED)
    end

    def paint(color)
      paint = Paint.new(base_paint)
      paint.color = color
      paint
    end
  end

  class Cycle
    attr_reader :game, :scene
    def initialize(game, scene)
      @game = game
      @scene = scene
      scene.game = game
    end
    def start(&block)
      interval = 0.03
      last_tick = 0.0
      while true do
        scene.synchronize do
          game.instance_exec interval, &block
        end
        tick_time = Time.now.to_f - last_tick
        
        early_by = interval - tick_time
        sleep early_by if early_by > 0

        puts "tick: early by #{early_by}, time taken #{tick_time}"

        last_tick = Time.now.to_f

        scene.postInvalidate
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
