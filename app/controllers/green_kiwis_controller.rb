class GreenKiwisController < ApplicationController
  
  def index
    @green = GreenKiwi.all
  end
  
  def create
    green = GreenKiwiManager.new
    green.subscribe(self)
    green.create_green_kiwi(green_kiwi: params[:green_kiwi], id_attrs: params[:id_attrs])
  end
  
  def new
    @green = GreenKiwiManager.new.build_green_kiwi
  end

  def edit
    @green = GreenKiwiManager.new.build_green_kiwi(green: GreenKiwi.find(params[:id]))
  end

  
  def update
    green = GreenKiwiManager.new(green_kiwi: GreenKiwi.find(params[:id]))
    green.subscribe(self)
    green.update_green_kiwi(green_kiwi: params[:green_kiwi], id_attrs: params[:id_attrs])
  end
  
  def successful_green_manager_event(green)
    redirect_to green_kiwis_path
  end

  
end