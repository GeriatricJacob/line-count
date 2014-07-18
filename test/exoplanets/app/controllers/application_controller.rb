class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_traffic

  def self.resource_name
    self.name.gsub('Controller', '').split('::').last.underscore
  end

  def after_sign_in_path_for(resource)
    if resource.roles.empty?
      params[:redirect] || super
    else
      params[:redirect] || admin_root_path
    end
  end

  def after_sign_up_path_for(resource)
    params[:redirect] || super
  end

  def resource_params
    params.require(resource_name).permit!
  end

  def controller_scope
    []
  end

end
