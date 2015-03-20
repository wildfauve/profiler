module ApplicationHelper
  
  def profile_extender_select
    pe = ProfileExtender.new
    pe.extenders.map{|e| [pe.send(e).name, pe.send(e).id]}
  end
  
  def type_select
    IdAttribute.types
  end
  
  def concept_select
    Concept.all.map {|c| [c.name, c.id]}
  end
  
  def ref_select(id_attr)
    Concept.refs_for(id_attr.concept).map {|ref| [ref.name, ref.id]}
  end
  
end
