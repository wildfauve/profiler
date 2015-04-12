class OccupationExtender
  
  def id
    :occupation_extender
  end
  
  def name
    "Occupation Extender"
  end
  
  # Provide an array of the profiles to add to the Kiwi.
  def execute(item: nil, profile: nil)
    if ["Guns"].include? item.entry
      [IdAttribute.id_attribute_for("source_of_funds")]
    else
      []
    end
  end
  
end