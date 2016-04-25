class AttemptsController < ApplicationController

  helper 'surveys'
  
  before_filter :load_survey, only: [:new, :create]
  before_action :authenticate_user!
  def index
    @surveys = Survey::Survey.active
  end

  def show
    @attempt = Survey::Attempt.find_by(id: params[:id])
    render :access_error if User.last.id != @attempt.participant_id
  end

  def new
    
    #@participant = current_user
    @participant = current_user
    @user = current_user
    if @user.score.nil?
      unless @survey.nil?   
        @attempt = @survey.attempts.new
        @attempt.answers.build
      end
    else
      redirect_to root_path, alert: "Not Allowed.You have already submitted your paper and your mark was #{current_user.score}"
    end
  end

  def create

    @attempt = @survey.attempts.new(params_whitelist)
    @attempt.participant = current_user
   
    if @attempt.valid? && @attempt.save
      correct_options_text = @survey.correct_options.present? ? 'Bellow are the correct answers marked in green' : ''
      current_user.update(score: @attempt.score)
      redirect_to root_path, notice: "Thank you for answering #{current_user.name}! Your marks is  #{@attempt.score}"
    else
      build_flash(@attempt)   
      @participant = current_user
      render :new
    end
  end

  def delete_user_attempts
    Survey::Attempt.where(participant_id: params[:user_id], survey_id: params[:survey_id]).destroy_all
    redirect_to new_attempt_path(survey_id: params[:survey_id])
  end

  private

  def load_survey
    @survey = Survey::Survey.find_by(id: params[:survey_id])
  end

  def params_whitelist
    if params[:survey_attempt]
      params[:survey_attempt][:answers_attributes] = params[:survey_attempt][:answers_attributes].map { |attrs| { question_id: attrs.first, option_id: attrs.last } }
      params.require(:survey_attempt).permit(Survey::Attempt::AccessibleAttributes)
    end
  end

  # def current_user
  #   view_context.current_user
  # end
end
