require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    @tabs = nil
    @@tabbar = nil
    @@toolbar = nil

    super

    @questions = Question.find(:all)

    if @questions.size == 0
      Question.new({'title'=>'Text', 'q'=>'Which bird is the national bird of norway??', 'path'=>'text', 'answer'=>''}).save
      Question.new({'title'=>'Sound', 'q'=>'Which bird did you hear??', 'path'=>'sound', 'answer'=>''}).save
      Question.new({'title'=>'Image', 'q'=>'Which bird is this?', 'path'=>'image', 'answer'=>''}).save
      Question.new({'title'=>'Video', 'q'=>'Which bird is this?', 'path'=>'video', 'answer'=>''}).save
      Question.new({'title'=>'ScreenRotation', 'q'=>'Turn your cellphone sideways', 'path'=>'rotation', 'answer'=>''}).save
      Question.new({'title'=>'Location', 'q'=>'Walk 100 meters from your initial possition', 'path'=>'location', 'answer'=>''}).save
      Question.new({'title'=>'Barcode', 'q'=>'Register barcode', 'path'=>'barcode', 'answer'=>''}).save
      @questions = Question.find(:all)
    end
  end

  def on_activate_app
    GeoLocation.known_position?
  end
end
