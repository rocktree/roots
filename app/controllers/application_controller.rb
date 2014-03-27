class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  private

    def after_sign_in_path_for(resource)
      if current_user.is_admin?
        admin_dashboard_path
      else
        root_path
      end
    end

    def after_sign_out_path_for(user)
      root_path
    end

end
