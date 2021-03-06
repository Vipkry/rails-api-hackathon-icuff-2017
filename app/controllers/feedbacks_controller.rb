class FeedbacksController < ApplicationController

  # GET /feedback
  def feedback
    @result = nil
    teacher_id = @current_user.teacher_id if @current_user.teacher_id 
    @result = Feedback.where('teacher_id = ?', teacher_id)
    if @result
      render json: @result, status: 200
    else
      render json: nil, status: 404
    end
  end
end
