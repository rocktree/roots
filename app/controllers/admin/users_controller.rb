class Admin::UsersController < AdminController

  private

    def set_defaults
      super
      @model = User
      @columns = ['email']
    end

    def create_params
      params.require(:report).permit(:email, :password, :password_confirmation, 
        :is_admin)
    end

end
