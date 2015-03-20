class GreenKiwi
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :kiwi_url, type: String
  
  embeds_many :profile_items
  
  
  def create_me(green_kiwi: nil, id_attrs: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs)
    self.save
    publish(:successful_green_kiwi_create_event, self)
  end
  
  def update_me(green_kiwi: nil, id_attrs: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs)
    self.save
    publish(:successful_green_kiwi_update_event, self)
  end
  
  
  def update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs)
    self.kiwi_url = green_kiwi[:kiwi_url]
    add_profile_entries(id_attrs: id_attrs)
    
  end
  
  def build_profile(profile: nil, persist: false)
    profile.each do |id_attr|
      self.add_profile_item(id_attr: id_attr)
    end
    self.save if persist
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
  
  
end
