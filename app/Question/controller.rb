require 'rho/rhocontroller'
require 'helpers/browser_helper'

class QuestionController < Rho::RhoController
  include BrowserHelper

  #GET /Question
  def index
    @questions = Question.find(:all)
    #how can we unregister the previous callback? Hacking here, just setting a empty callback
    System::set_screen_rotation_notification(url_for(:action => :emptyScreenRotateCallback), "")
    render
  end

  # GET /Question/{1}
  def show
    @question = Question.find(@params['id'])
    app_info(@question)
    if @question
      if @question.path == 'rotation' && @question.answer != "true"
        System::set_screen_rotation_notification(url_for(:action => :screenRotateCallback, :query => {:id => @question.object}), "")
      elsif @question.path == "location" && @question.long != nil && @question.answer != "true"
        @distance = (GeoLocation.haversine_distance @question.lat.to_f, @question.long.to_f, GeoLocation.latitude, GeoLocation.longitude) * 1609
        if (@distance > 100)
          @question.update_attributes({"answer" => "true"})
        end
      end

      render :action => 'show_' + @question.path
    else
      redirect :action => :index
    end
  end


  def play_sound
    Alert.play_file '/public/seagull.mp3', 'audio/mpeg'
    #can we stop it from rendering anything here? We just want it to stay on the same page
    @question = Question.find(@params['id'])
    render :action => 'show_sound', :back => "/app/Question"
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

    Alert.show_popup :title => "Success",
                     :message => "Screen rotated successfully!",
                     :icon => :info,
                     :buttons => ["OK"],
                     :callback => url_for(:action => :on_popup_close)
  end

  def emptyScreenRotateCallback

  end

  def on_popup_close
    WebView.navigate(url_for(:action => :index))
  end

  def scanBarcode
    @question = Question.find(@params['id'])
    Camera::take_picture(url_for :action => :camera_callback, :id => @params['id'])
    render :action => 'show_barcode'
  end

  def camera_callback
    @question = Question.find(@params['id'])
    @code = Barcode.barcode_recognize(Rho::RhoApplication::get_blob_path(@params['image_uri']))
    if @code != ""
      @question.update_attributes({"answer" => @code})
    end
    app_info("Barcode")
    app_info(@code)
    WebView.navigate(url_for :action => :show, :id => @params['id'], :query => {:try => "true"})
  end

  def submit
    @questions = Question.find(:all)
    render :action => :submit
  end
end

