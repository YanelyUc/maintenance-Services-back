class ApplicationController < ActionController::API
  def error_response(message, status = '403')
    render json: {
      errors: [
        {
          detail: message
        }
      ]
    }, status: status
  end
end
