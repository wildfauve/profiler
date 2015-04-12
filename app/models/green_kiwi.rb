class GreenKiwi
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :kiwi_url, type: String
  
  embeds_many :profile_items
  
  has_one :user_proxy, autosave: true
  
  
  def create_me(green_kiwi: nil, id_attrs: nil, user_proxy: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs, user_proxy: user_proxy)
    self.save
    publish(:successful_green_kiwi_create_event, self)
  end
  
  def update_me(green_kiwi: nil, id_attrs: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs)
    self.save
    publish(:successful_green_kiwi_update_event, self)
  end
  
  
  def update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs, user_proxy: nil)
    self.user_proxy = user_proxy if self.user_proxy != user_proxy || !user_proxy.nil?
    self.kiwi_url = green_kiwi[:kiwi_url]
    add_profile_entries(id_attrs: id_attrs)
    
  end
  
  def build_profile(profile: nil, persist: false, user_proxy: nil)
    profile.each do |id_attr|
      self.add_profile_item(id_attr: id_attr)
    end
    self.user_proxy = user_proxy if (self.user_proxy != user_proxy) && !user_proxy.nil?
    self.save if persist && self.changed?
    self
  end
    
  def add_profile_item(id_attr: nil)
    item = self.profile_items.where(attr_id: id_attr.id).first
    self.profile_items << ProfileItem.create_me(id_attr: id_attr) if !item
  end
  
  def add_profile_entries(id_attrs: nil)
    id_attrs.each do |id, entry|
      item = self.profile_items.where(attr_id: id).first
      if item
        item.add_entry(entry: entry)
      else
        raise
      end
    end
  end
  
  def check_party #check whether this is necessary for the profile to check customer.
    return
    resp = CustomerPort.new.get_customer(party_url: self.party_url)
    if resp.status == :ok
      self.create_links(party: resp.party)
      self.name = resp.party["party"]["name"] if self.name != resp.party["party"]["name"]
      self.age = resp.party["party"]["age"] if self.age != resp.party["party"]["age"]
      self.save
    elsif resp.status == :not_found
      self.create_links(party: create_party())
    elsif resp.status == :unavailable
    end
  end
  
  
end
