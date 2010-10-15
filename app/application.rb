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
      Question.new({'title'=>'Tekst', 'q'=>'Hvilken fugl regnes som norges nasjonalfugl?', 'path'=>'text', 'answer'=>''}).save
      Question.new({'title'=>'Lyd', 'q'=>'Hvilken fugl hører du her?', 'path'=>'sound', 'answer'=>''}).save
      Question.new({'title'=>'Bilde', 'q'=>'Hvilke fugl er dette?', 'path'=>'image', 'answer'=>''}).save
      Question.new({'title'=>'Video', 'q'=>'Hvor er dette fra?', 'path'=>'video', 'answer'=>''}).save
      Question.new({'title'=>'Bevegelse', 'q'=>'Rett mobilen i en vinkel du tror er 45', 'path'=>'accelometer', 'answer'=>''}).save
      Question.new({'title'=>'Kompass', 'q'=>'Rett mobilen i den retningen du tror er nord', 'path'=>'compass', 'answer'=>''}).save
      Question.new({'title'=>'Lokasjon', 'q'=>'Gå 100 meter fra din utgangsposisjon', 'path'=>'location', 'answer'=>''}).save
      Question.new({'title'=>'Strekkode', 'q'=>'Skann inn nåværende posisjon', 'path'=>'barcode', 'answer'=>''}).save
      @questions = Question.find(:all)
    end
    
    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    # SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
  end
end
