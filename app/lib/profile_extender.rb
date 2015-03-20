class ProfileExtender
  
  class << self
    def register_extenders(*extenders)
      extenders.each do |extender|
        define_method(extender) do
          extender.to_s.split("_").collect(&:capitalize).join.constantize.new
        end
      end
    end
  end
  
  register_extenders :occupation_extender
  
  def extenders
    self.methods.select {|m| m[/_extender/]}
  end
  
  def profile_change(profile: nil)
    profile.inject([]) do |extensions, item| 
      extensions << self.send(item.id_attribute.extender).execute(item: item, profile: profile)
    end.flatten.uniq
  end
  
  #def profile_change(profile: nil)
  # extenders.each do |extender|
  #    self.send(extender).execute(profile: profile)
  #  end
  #end
  
  
end