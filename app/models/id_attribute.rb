class IdAttribute
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :description, type: String
  field :display_name, type: String
  field :base, type: Boolean
  field :type, type: Symbol #date, time, number, text, email, url, tel, :long_text
  field :concept, type: BSON::ObjectId
  field :required, type: Boolean
  field :pattern, type: String 
  field :min, type: Float
  field :max, type: Float
  field :extender, type: Symbol # class that check for new profile item based on this item,
  field :act_section, type: String
  
  field :verification_method, type: Symbol # branch ???
  field :process_point, type: Symbol # on join, on a transaction
  
  scope :base_profile, -> {where(base: true)}
  
  def self.types
    [
      ["Long Text", :long_text], 
      ["Text", :text],
      ["Select", :select]
    ]
  end
  
  def self.id_attribute_for(name)
    self.where(name: name).first
  end
    
  def create_me(id_attr: nil)
    self.update_attrs(id_attr: id_attr)
    self.save
    publish(:successful_save_event, self)
  end
  
  def update_me(id_attr: nil)
    self.update_attrs(id_attr: id_attr)
    self.save
    publish(:successful_save_event, self)
  end
  
  
  def update_attrs(id_attr: nil)
    self.name = id_attr[:name]
    self.description = id_attr[:description]
    id_attr[:extender].blank? ? self.extender = nil : self.extender = id_attr[:extender].to_sym
    self.base = id_attr[:base]
    self.display_name = id_attr[:display_name]
    self.type = id_attr[:type].to_sym
    self.concept = id_attr[:concept]
  end
  
  
end
