class ApplicationController < ActionController::API

  def status
    render json: { status: :ok, date: Time.now() }, status: :ok
  end

  def json_attributes
    json_attr = {}
    json_attr[:methods] = params[:methods] if params[:methods]
    json_attr[:only] = params[:only] if params[:only]
    json_attr[:except] = params[:except] if params[:except]
    json_attr[:include] = params[:include] if params[:include]
    json_attr
  end

end
