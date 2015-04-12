class ProfilesController < ApplicationController
  

  def index
    session[:redirect_uri] = params[:redirect_uri]
    if !@current_user_proxy
      redirect_to login_identities_path
    else
      if !@current_user_proxy.green_kiwi
        @green = GreenKiwiManager.new.build_green_kiwi(persist: true, user_proxy: @current_user_proxy, id_token: params[:id_token])
      else
        @green = GreenKiwiManager.new.build_green_kiwi(green: @current_user_proxy.green_kiwi, user_proxy: @current_user_proxy, id_token: params[:id_token])
      end
      render 'edit'
    end
  end
  
  
  def new
    @green = GreenKiwiManager.new.build_green_kiwi
  end

  def edit
    @green = GreenKiwiManager.new.build_green_kiwi(green: GreenKiwi.find(params[:id]))
  end

  
  def update
    green = GreenKiwiManager.new(green_kiwi: GreenKiwi.find(params[:id]))
    green.subscribe(self)
    green.update_green_kiwi(green_kiwi: params[:green_kiwi], id_attrs: params[:id_attrs])
  end
  
  def successful_green_manager_event(green)
    redirect_to session[:redirect_uri]
  end

  
end