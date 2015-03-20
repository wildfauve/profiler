class Ref
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  
  embedded_in :concept
    
  def self.create_me(ref: nil)
    self.new.update_attrs(ref: ref)
  end
  
  def update_me(ref: nil)
    self.update_attrs(ref: ref)
  end
  
  
  def update_attrs(ref: nil)
    self.name = ref[:name]
    self
  end
  
  
end
