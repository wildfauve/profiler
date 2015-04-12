class IdentityAdapter
  
  include Wisper::Publisher
  
  attr_accessor :access_token, :id_token, :id_token_encoded, :user_proxy
  
  include UrlHelpers
  
  def authorise_url(host: nil, scope: nil)
    q = {}
    q[:response_type] = "code"
    q[:redirect_uri] = url_helpers.authorisation_identities_url host: host
    q[:scope] = scope
    q[:client_id] = Setting.oauth["client_id"]
    "#{Setting.oauth(:id_service_url)}?#{q.to_query}"    
  end
  
  def logout_url(user_proxy: nil, host: nil)
    q = {post_logout_redirect_uri: url_helpers.root_url(host: host)}
    q[:id_token_hint] = user_proxy.access_token["id_token"]
    "#{Setting.oauth(:id_logout_service_url)}?#{q.to_query}"
  end
  
  #POST /token HTTP/1.1
  #   Host: server.example.com
  #   Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
  #   Content-Type: application/x-www-form-urlencoded
  #
  #   grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
  #   &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
  
  def get_access(params: nil, host: nil)
    if params[:error]
      publish(:login_error)
    else
      token = IdPort.new.get_access_token(auth_code: params[:code], host: host)
      @access_token = token.access_token
      @user_proxy = UserProxy.set_up_user(access_token: @access_token)
      if @user_proxy.requires_additional_identity?
        publish(:create_additional_identity, @user_proxy)
      else
        @user_proxy.green_kiwi.check_party
        publish(:valid_authorisation, @user_proxy)
      end
    end
  end
    
  def id_token_provided?
    @id_token ? true : false
  end
  
  def get_claim(type: nil, key: nil)
    @id_token[type].first {|c| c["ref"] == "party"}
  end
    
  
end