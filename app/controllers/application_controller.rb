class ApplicationController < ActionController::API

  def status
    render json: { status: :ok, date: Time.now() }, status: :ok
  end
end
