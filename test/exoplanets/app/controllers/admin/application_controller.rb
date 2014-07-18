class Admin::ApplicationController < ApplicationController
  control_and_rescue_traffic

  layout 'admin'
  respond_to :html

  helper_method :resource_class, :resource_name, :resource_collection, :resource

  before_filter :authenticate_admin!

  def access_denied
    current_user ? forbidden : unauthorized
  end

  def forbidden
    redirect_to new_user_session_path, status: 403
  end

  def unauthorized
    redirect_to new_user_session_path
  end

  def controller_scope
    [:admin]
  end

  def resource_location action=nil
    case action
    when :create then controller_scope << resource
    when :update then controller_scope << resource
    else
      controller_scope << resource_name.to_s.pluralize.to_sym
    end
  end

  def resource_path_for res, action=nil
    plural = resource_name.to_s.pluralize.to_sym

    if action.present?
      action = action.to_s
    else
      action = params[:action]
    end

    case action
    when 'update' then controller_scope + [res]
    when 'create' then controller_scope + [plural]
    when 'index' then controller_scope + [plural]
    when 'destroy' then controller_scope + [res]
    when 'show' then controller_scope + [res]
    when 'new' then [:new] + controller_scope + [resource_name]
    else
      [action.to_sym] + controller_scope + [res]
    end
  end

  def resource_path action=nil
    resource_path_for resource, action
  end

private

  def authenticate_admin!
    authenticate_user!
    forbidden unless current_user.has_role? :admin
  end

end
