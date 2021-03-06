class GreenKiwiManager
  
  include Wisper::Publisher
  
  def initialize(green_kiwi: nil)
    @green_kiwi = green_kiwi if green_kiwi
  end
  
  def create_green_kiwi(green_kiwi: nil, id_attrs: nil, user_proxy: nil)
    green = GreenKiwi.new.build_profile(profile: ProfileBuilder.new.base_green_kiwi)
    green.subscribe self
    green.create_me(green_kiwi: green_kiwi, id_attrs: id_attrs, user_proxy: user_proxy)
  end

  def update_green_kiwi(green_kiwi: nil, id_attrs: nil)
    @green_kiwi.subscribe self
    @green_kiwi.update_me(green_kiwi: green_kiwi, id_attrs: id_attrs)
  end

  
  def build_green_kiwi(green: nil, persist: false, user_proxy: nil, id_token: nil)
    user_proxy.compare_tokens(external_token: id_token) if id_token
    if green
      green.build_profile(profile: ProfileBuilder.new.base_green_kiwi, user_proxy: user_proxy)      
    else
      GreenKiwi.new.build_profile(profile: ProfileBuilder.new.base_green_kiwi, persist: persist, user_proxy: user_proxy)
    end
  end
  
  # Green Model Events
  
  def successful_green_kiwi_create_event(green_kiwi)
    extend_profile(green_kiwi)
  end

  def successful_green_kiwi_update_event(green_kiwi)
    extend_profile(green_kiwi)
  end


  def extend_profile(green_kiwi)
    extensions = ProfileExtender.new.profile_change(profile: extenders(green_kiwi))
    green_kiwi.build_profile(profile: extensions, persist: true)
    publish(:successful_green_manager_event, self)        
  end
  
  def extenders(green_kiwi)
    green_kiwi.profile_items.select {|item| item.id_attribute.extender != nil}
  end
  
  
end