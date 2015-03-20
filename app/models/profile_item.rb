class ProfileItem
  
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :attr_id, type: BSON::ObjectId
  field :entry_text, type: String
  field :entry_select, type: BSON::ObjectId
  field :entry_concept, type: BSON::ObjectId


  embedded_in :green_kiwi
  
  
  def self.create_me(id_attr: nil)
    item = self.new.update_attrs(id_attr: id_attr)
    item
  end
  
  def update_attrs(id_attr: nil)
    self.attr_id = id_attr.id
    self
  end
  
  def id_attribute
    IdAttribute.find(attr_id)
  end
  
  def add_entry(entry: nil)
    case self.id_attribute.type
    when :select
      self.entry_select = entry
      self.entry_concept = Concept.find(self.id_attribute.concept).id
    else
      self.entry_text = entry
    end
  end
  
  def entry
    case self.id_attribute.type
    when :select
      Concept.find(self.entry_concept).ref_for(self.entry_select).name
    else
      self.entry_text
    end
  end
  
  def entry_id # only for select types
    self.entry_concept ? Concept.find(self.entry_concept).ref_for(self.entry_select).id : nil
  end
    
end

