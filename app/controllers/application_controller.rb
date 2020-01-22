class ApplicationController < ActionController::API
  prepend_before_action :set_cors

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

  def build_scope scope
    build_params = request.parameters
    build_params[:scopes] ||= {}
    build_params = HashWithIndifferentAccess.new(build_params)

    build_params[:scopes].each do |scope_name, scope_params|
      scope = (scope_params.present? ? scope.send(scope_name, scope_params) : scope.send(scope_name))
    end

    total = scope.count
    scope = scope.where(build_params[:query_options]) if build_params[:query_options]
    scope = scope.select(build_params[:only]) if build_params[:only]

    # scope = build_search(scope, build_params[:search]) if build_params[:search].present?
    scope = scope.order(build_params[:order]) if build_params[:order]

    if build_params[:page] && build_params[:per]
      page = build_params[:page].to_i || 1
      per = build_params[:per].to_i || 10
      offset = (page - 1) * per
      scope = scope.offset(offset).limit(build_params[:per])
      set_response_headers total, page, per, offset
    end
    scope
  end

  def build_search scope, search_params
    scope = scope.where('name ilike ?', "%#{search_params[:name]}%")
  end

  def set_response_headers total, page, per, offset
    pages = (total/per).round
    pages = pages + 1 if pages * per < total
    response.headers["X-Pagination"] = {
      total: total,
      pages: pages == 0 ? 1 : pages,
      offset: offset,
      per: per,
      page: page,
      status: :ok
    }.to_json
  end

  def set_cors
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Expose-Headers'] = '*'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
