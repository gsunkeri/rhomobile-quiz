require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    @@tabbar = nil
    @@toolbar = nil

    super

    @questions = Question.find(:all)

    if @questions.size == 0
      Question.new({'title'=>'Tekst', 'q'=>'Which bird is the national bird of norway??', 'path'=>'text', 'answer'=>''}).save
      Question.new({'title'=>'Lyd', 'q'=>'Which bird did you hear??', 'path'=>'sound', 'answer'=>''}).save
      Question.new({'title'=>'Bilde', 'q'=>'Which bird is this?', 'path'=>'image', 'answer'=>''}).save
      Question.new({'title'=>'Video', 'q'=>'Which bird is this?', 'path'=>'video', 'answer'=>''}).save
      Question.new({'title'=>'Bevegelse', 'q'=>'Turn your cellphone sideways', 'path'=>'accelometer', 'answer'=>''}).save
      Question.new({'title'=>'Kompass', 'q'=>'Turn your cellphone towards north', 'path'=>'compass', 'answer'=>''}).save
      Question.new({'title'=>'Lokasjon', 'q'=>'Walk 100 meters from your initial possition', 'path'=>'location', 'answer'=>''}).save
      Question.new({'title'=>'Strekkode', 'q'=>'Register barcode', 'path'=>'barcode', 'answer'=>''}).save
      @questions = Question.find(:all)
    end
    
    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    # SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
  end
end
