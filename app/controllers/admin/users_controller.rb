class Admin::UsersController < AdminController

  private

    def set_defaults
      super
      @model = User
      @columns = ['email']
    end

    def create_params
      params.require(:user).permit(:email, :password, :password_confirmation, 
        :is_admin)
    end

    def edit_params
      params.require(:user).permit(:password, :password_confirmation, :is_admin)
    end

end
