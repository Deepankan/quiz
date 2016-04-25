class ApplicationController < ActionController::Base
 include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :update_sanitized_params, if: :devise_controller?
  
   
   
   def update_sanitized_params

    params[:user][:role_id] = Role.find_by_name(params[:user][:role_id]).id if params[:user] && params[:controller] == "devise/registrations"
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email,:password,:password_confirmation,:name,:user_type,:role_id)}
   end


  #   def after_sign_in_path_for(resource_or_scope)   
    
  #   root_path
  # end  
   # def timeout_in
   #  binding.pry
   #  1.minute
   # end   

     def after_sign_in_path_for(resource)
      time =  
      session['time'] = MAX_TIME.minutes.from_now
      root_path
     end

  protected
 
  #derive the model name from the controller. egs UsersController will return User
  def self.permission
    return name = self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
  end
 
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
 
  #load the permissions for the current user so that UI can be manipulated
  def load_permissions
    @current_permissions = current_user.role.permissions.collect{|i| [i.subject_class, i.action]}
  end

end
