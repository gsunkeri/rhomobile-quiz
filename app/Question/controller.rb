require 'rho/rhocontroller'
require 'helpers/browser_helper'

class QuestionController < Rho::RhoController
  include BrowserHelper

  #GET /Question
  def index
    @questions = Question.find(:all)
    app_info(@questions)
    #how can we unregister the previous callback? Hacking here, just setting a empty callback
    System::set_screen_rotation_notification(url_for(:action => :emptyScreenRotateCallback), "")

    render
  end

  # GET /Question/{1}
  def show
    @question = Question.find(@params['id'])
    if @question
      app_info(@question)
      if @question.path == 'rotation' && @question.answer != "true"
        System::set_screen_rotation_notification(url_for(:action => :screenRotateCallback, :query => {:id => @question.object}), "")
      elsif @question.path == "location" && @question.long != nil && @question.answer != "true"
        app_info("calculating distance...")
        app_info(GeoLocation.latitude.to_s)
        app_info(GeoLocation.longitude.to_s)
        app_info(@question.lat)
        app_info(@question.long)
        
        @distance = ( GeoLocation.haversine_distance @question.lat.to_f, @question.long.to_f, GeoLocation.latitude, GeoLocation.longitude ) * 1609
     if (@distance > 100)
          @question.update_attributes({"answer" => "true"})
        end
      end

      app_info(@distance)
      app_info(@question)
      
      render :action => 'show_' + @question.path
    else
      redirect :action => :index
    end
  end


  def play_sound
    Alert.play_file '/public/seagull.mp3', 'audio/mpeg'

    #can we stop it from rendering anything here? We just want it to stay on the same page
    @question = Question.find(@params['id'])
    render :action => 'show_sound'
  end

  def tracking
    @question = Question.find(@params['id'])
    @question.update_attributes({"long" => GeoLocation.longitude, "lat" => GeoLocation.latitude})
    render :action => 'show_location'
  end

  def update
    @question = Question.find(@params['id'])
    @question.update_attributes(@params['question']) if @question
    redirect :action => :index
  end

  def screenRotateCallback
    @question = Question.find(@params["id"])
    @question.update_attributes({"answer" => "true"})
    app_info(@question)

    Alert.show_popup :title => "Success", :message => "Screen rotated successfully!", :icon => :info,
                     :buttons => ["OK"],
                     :callback => url_for(:action => :on_popup_close)
  end

  def emptyScreenRotateCallback


  end

  def on_popup_close
    WebView.navigate(url_for(:action => :index))
  end

end
