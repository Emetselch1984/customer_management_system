module ErrorHandlers
  # この表記をすると下記includeメソッドが使えるようになる
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :rescue500
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
    rescue_from ActionController::BadRequest, with: :rescue400
    rescue_from ActionController::ParameterMissing, with: :rescue400
  end

  private def rescue400(_e)
    render 'errors/bad_request', status: 400
  end

  private def rescue404(_e)
    render 'errors/not_found', status: 404
  end

  private def rescue500(_e)
    render 'errors/internal_server_error', status: 500
  end
end
