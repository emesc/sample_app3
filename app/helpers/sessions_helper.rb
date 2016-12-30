module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns current logged in user, if any
  def current_user
    @current_user || = User.find_by(id: sessions[:user_id])
  end

  # returns true if user is logged in, false otherwise
  def is_logged_in?
    !current_user.nil?
  end
end
