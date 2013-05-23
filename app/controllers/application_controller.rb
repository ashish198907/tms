class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user
  private
    def current_user_session
      logger.debug "ApplicationController::current_user_session"
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      logger.debug "ApplicationController::current_user"
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
 
    def require_user
      logger.debug "ApplicationController::require_user"
      unless current_user        
        #flash[:notice] = "You session has expired. Please login"
        redirect_to :controller => 'user_sessions',:action => 'new'
        return false
      end
      end

    def require_admin
      logger.debug "ApplicationController::require_admin"
      unless current_user.is_super_user
        flash[:error] = "You do not have enough permissions to access this page."
        redirect_to root_url
        return false
      end
    end

 
    def require_no_user
      logger.debug "ApplicationController::require_no_user"
      if current_user        
        flash[:notice] = "You must be logged out to access this page"
        redirect_to :controller => 'albums', :action => 'index'
        return false
      end
    end
 
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end