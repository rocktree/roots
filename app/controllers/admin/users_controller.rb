class Admin::UsersController < AdminController

  def update
    p = update_params
    p = no_pwd_params if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @item.update(p)
      redirect_to @routes[:edit], :notice => "#{@model.to_s} was updated successfully."
    else
      @url = @routes[:show]
      render :action => "edit"
    end
  end

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

    def update_params
      params.require(:user).permit(:password, :password_confirmation, :is_admin)
    end

    def no_pwd_params
      params.require(:user).permit(:is_admin)
    end

end
