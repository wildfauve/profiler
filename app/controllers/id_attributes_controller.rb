class IdAttributesController < ApplicationController
  
  def index
    @id_attrs = IdAttribute.all
  end
  
  def create
    id_attr = IdAttribute.new
    id_attr.subscribe(self)
    id_attr.create_me(id_attr: params[:id_attribute])
  end
  
  def new
    @id_attr = IdAttribute.new
  end

  def edit
    @id_attr = IdAttribute.find(params[:id])
  end

  
  def update
    id_attr = IdAttribute.find(params[:id])
    id_attr.subscribe(self)
    id_attr.update_me(id_attr: params[:id_attribute])    
  end
  
  def successful_save_event(id_attr)
    redirect_to root_path
  end

  
end