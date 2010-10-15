require 'rho/rhocontroller'
require 'helpers/browser_helper'

class QuestionController < Rho::RhoController
  include BrowserHelper

  #GET /Question
  def index
    @questions = Question.find(:all)
    render
  end

  # GET /Question/{1}
  def show
    @question = Question.find(@params['id'])
    if @question
      render :action => 'show_' + @question.path
    else
      redirect :action => :index
    end
  end
  
  def play_sound
    Alert.play_file '/public/seagull.mp3', 'audio/mpeg'
    render :action => 'show_sound'
  end


  def play_sound
    Alert.play_file '/public/seagull.mp3', 'audio/mpeg'
    render :action => 'show_sound'
  end

  def stop_sound
    Rho::RingtoneManager.stop
    render :action => 'show_sound'
  end

  def update
    @question = Question.find(@params['id'])
    @question.update_attributes(@params['question']) if @question
    redirect :action => :index
  end
 
end
