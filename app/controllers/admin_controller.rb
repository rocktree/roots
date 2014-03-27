class AdminController < ActionController::Base

  include AdminHelper

  protect_from_forgery :with => :exception
  before_filter :authenticate_admin
  before_action :set_defaults
  before_action :set_routes

  def dashboard
    redirect_to admin_users_path
  end

  def index
    @items = @model.all
  end

  def new
    @item = @model.new
    @url = @routes[:index]
  end

  def edit
    @url = @routes[:show]
  end

  def create
    @item = @model.new(create_params)

    if @item.save
      redirect_to @routes[:index], :notice => "#{@model.to_s} was successfully created."
    else
      @url = @routes[:index]
      render :action => "new"
    end
  end

  def update
    update_params ||= create_params
    if @item.update(update_params)
      redirect_to @routes[:edit], :notice => "#{@model.to_s} was updated successfully."
    else
      @url = @routes[:show]
      render :action => "edit"
    end
  end

  def destroy
    @item.destroy
    redirect_to @routes[:index], :notice => "#{@model.to_s} was deleted successfully."
  end

  private

    def authenticate_admin
      authenticate_user!
      redirect_to root_path unless current_user.is_admin?
    end

    def set_defaults
      @model = User
      @columns = ['title']
      @actions = [:edit, :delete]
    end

end
