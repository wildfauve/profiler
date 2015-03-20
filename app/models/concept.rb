class Concept
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :description, type: String
  
  embeds_many :refs
  
  def self.refs_for(concept)
    self.find(concept).refs
  end
    
  def create_me(concept: nil)
    self.update_attrs(concept: concept)
    self.save
    publish(:successful_concept_save_event, self)
  end
  
  def update_me(concept: nil)
    self.update_attrs(concept: concept)
    self.save
    publish(:successful_concept_save_event, self)
  end
  
  
  def update_attrs(concept: nil)
    self.name = concept[:name]
    self.description = concept[:description]
  end
  
  def create_ref(ref: nil)
    ref = Ref.create_me(ref: ref)
    self.refs << ref 
    self.save
    publish(:successful_ref_save_event, self, ref)
  end
  
  def ref_for(id)
    self.refs.find(id)
  end
  
  
end
