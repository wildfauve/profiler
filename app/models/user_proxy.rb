class UserProxy
  
  class Error < StandardError ; end
  class ExternalTokenMismatch < Error ; end
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :email, type: String
  field :email_verified, type: Boolean
  field :access_token, type: Hash
  field :id_token, type: Hash
  
  belongs_to :green_kiwi
  
  def self.set_up_user(access_token: nil)
    user = get_user_from_id_service(access_token: access_token)
    proxy = self.find_or_create(access_token: access_token)
    proxy
  end
    
  
  def self.find_or_create(access_token: nil)
    id_token = token_decode_and_validate(token: access_token["id_token"])
    up = self.where(name: id_token["preferred_username"]).first
    if up
      up.add_attrs(id_token: id_token, access_token: access_token)
    else
      up = self.new.add_attrs(id_token: id_token, access_token: access_token)
    end
    up
  end
  
  def self.token_decode_and_validate(token: nil)
    begin
      key = PKI::PKI.new
      JSON::JWT.decode(token, key.key.public_key)
      #@id_token = JWT.decode(@id_token_encoded, Setting.oauth["id_token_secret"]).inject(&:merge)
    rescue JSON::JWT::Exception => e
      raise
    end
  end
  
    
  def self.get_user_from_id_service(access_token: nil)
    conn = Faraday.new(url: Setting.oauth["id_userinfo_service_url"])    
    conn.params = {access_code: access_token["access_code"]} 
    conn.authorization :Bearer, access_token["access_code"]
    resp = conn.get
    raise if resp.status >= 300
    JSON.parse(resp.body)
  end
    
  
  def add_attrs(id_token: nil, access_token: nil)
    raise if !id_token
    name = "preferred_username"
    email = "email_verified"
    key = :id_token
    self.id_token = id_token
    self.name = id_token["preferred_username"]
    self.email_verified = id_token["email_verified"]
    self.email = id_token["email"]    
    self.access_token = access_token
    self.save
    self
  end
  
  def requires_additional_identity?
    if Setting.oauth(:require_additional_identity)
      self.green_kiwi ? false : true
    else
      false
    end
  end
  
  def id_token_encoded
    self.access_token[:id_token]
  end
  
  
  def compare_tokens(external_token: nil)
    e_token = UserProxy.token_decode_and_validate(token: external_token)
    raise UserProxy::ExternalTokenMismatch if e_token[:sub] != self.id_token[:sub]
  end

  
end