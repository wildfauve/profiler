class OccupationExtender
  
  def id
    :occupation_extender
  end
  
  def name
    "Occupation Extender"
  end
  
  def execute(item: nil, profile: nil)
    if ["Guns"].include? item.entry
      [IdAttribute.id_attribute_for("source_of_funds")]
    else
      []
    end
  end
  
end