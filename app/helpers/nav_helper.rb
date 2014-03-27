module NavHelper

  def admin_nav_items
    [
      {
        :label => 'Users',
        :icon => 'user',
        :path => admin_users_path,
        :controllers => ['users']
      },
      {
        :label => 'Visit Site',
        :icon => 'home',
        :path => root_path,
        :controllers => [],
        :target => :blank
      },
      {
        :label => 'Logout',
        :icon => 'exit',
        :path => destroy_user_session_path
      }
    ]
  end

  def nav_active?(controllers)
    unless controllers.nil?
      controllers.each do |controller|
        return true if controller_name == controller
      end
    end
    false
  end

end
