class RefsController < ApplicationController
  
  def index
    @concept = Concept.find(params[:concept_id])
  end
  
  def create
    concept = Concept.find(params[:concept_id])
    concept.subscribe(self)
    concept.create_ref(ref: params[:ref])
  end
  
  def new
    @concept = Concept.find(params[:concept_id])
    @ref = Ref.new
  end

  def edit
    @concept = Concept.find(params[:id])
  end

  
  def update
    concept = Concept.find(params[:id])
    concept.subscribe(self)
    concept.update_me(concept: params[:concept])    
  end
  
  def successful_ref_save_event(concept, ref)
    @ref = ref
  end

  

  
end