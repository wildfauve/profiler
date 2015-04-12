class IdentitiesController < ApplicationController
  
  def sign_up
    # Send the Signup to the ID Service via a OAuth Redirect
    auth_service = IdentityAdapter.new.authorise_url(host: request.host_with_port, scope: "signup")
    redirect_to auth_service
  end
  
  def login
    # Send the Login to the ID Service via a OAuth Redirect
    auth_service = IdentityAdapter.new.authorise_url(host: request.host_with_port, scope: "basic_profile")
    redirect_to auth_service
  end
  
  def authorisation
    # Get an access token for the logged_in user from the ID Service using an OAuth /token call
    # Now we need to create an internal "user" by getting the /me
    auth = IdentityAdapter.new
    auth.subscribe(self)
    auth.get_access(params: params, host: request.host_with_port)
  end
  
  def logout
    auth_logout_service = IdentityAdapter.new.logout_url(user_proxy: @current_user_proxy, host: request.host_with_port)
    session[:user_proxy] = nil
    redirect_to auth_logout_service
  end
  
  def valid_authorisation(user_proxy)
    session[:user_proxy] = {proxy_id: user_proxy.id.to_s, expires: 10.minutes.from_now}
    redirect_to profiles_path
  end

  def create_additional_identity(user_proxy)
    session[:user_proxy] = {proxy_id: user_proxy.id.to_s, expires: 10.minutes.from_now}    
    redirect_to new_profile_path
  end
  
  def login_error
    flash.now.alert = "Invalid Login"
    render 'shared/login_error'
    
  end  
end