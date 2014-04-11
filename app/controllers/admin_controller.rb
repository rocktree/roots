class AdminController < ActionController::Base
  helper_method :sort_column, :sort_direction

  include AdminHelper

  protect_from_forgery :with => :exception
  before_filter :authenticate_admin
  before_action :set_defaults, :except => [:dashboard]
  before_action :set_routes, :except => [:dashboard]

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
    @item.slug = '' if @item.attributes.has_key? 'slug'
    if @item.save
      if @item.attributes.has_key? 'slug' 
        if create_params[:slug].blank?
          @item.slug = @item.create_slug
        else
          @item.slug = @item.make_slug_unique(create_params[:slug])
        end
        @item.save
      end
      redirect_to @routes[:index], :notice => "#{@model.to_s} was successfully created."
    else
      @url = @routes[:index]
      render :action => "new"
    end
  end

  def update
    update_params ||= create_params
    if @item.attributes.has_key? 'slug' and !update_params[:slug].blank?
      update_params[:slug] = @item.make_slug_unique(update_params[:slug])
    end
    if @item.update(update_params)
      if @item.attributes.has_key? 'slug'
        @item.create_slug if update_params[:slug].blank? and !update_params[:slug].nil?
        @routes[:edit] = send("edit_admin_#{model_table_singular}_path", @item)
      end
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
      if Rails.const_defined?(controller_name.classify)
        @model = controller_name.classify.constantize
      end
      @columns = ['title']
      @actions = [:edit, :delete]
      @concerns = []
      @sortable = ['title']
    end

     def set_routes
      @routes = {
        :index => send("admin_#{model_table}_path"),
        :new => send("new_admin_#{model_table_singular}_path")
      }
      unless params[:id].nil?
        @item = @model.find_by_id(params[:id])
        @item = @model.find_by_slug(params[:id]) if @item.nil?
        @routes.merge!(
          :show => send("admin_#{model_table_singular}_path", @item),
          :edit => send("edit_admin_#{model_table_singular}_path", @item)
        )
      end
    end

    def create_params
      fields = []
      @model.attribute_names.each do |a|
        fields << a.to_sym unless a == 'id' || a == 'created_at' || a == 'updated_at'
      end
      params.require(@model.to_s.downcase.to_sym).permit(fields.collect(&:to_sym))
    end

    def sort_column
      Report.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
