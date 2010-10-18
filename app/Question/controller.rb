require 'rho/rhocontroller'
require 'helpers/browser_helper'

class QuestionController < Rho::RhoController
  include BrowserHelper

  #GET /Question
  def index
    @questions = Question.find(:all)
    app_info(@questions)
    System::set_screen_rotation_notification(url_for(:action => :emptyScreenRotateCallback), "")

    render
  end

  # GET /Question/{1}
  def show
    @question = Question.find(@params['id'])
    if @question
      app_info(@question)
      if @question.path == 'accelerometer' && @question.answer != "true"
        System::set_screen_rotation_notification(url_for(:action => :screenRotateCallback, :query => {:id => @question.object}), "")
      end
      render :action => 'show_' + @question.path
    else
      redirect :action => :index
    end
  end


  def play_sound
    Alert.play_file '/public/seagull.mp3', 'audio/mpeg'
    render :action => 'show_sound'
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
