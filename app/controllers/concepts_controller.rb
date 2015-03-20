class ConceptsController < ApplicationController
  
  def index
    @concepts = Concept.all
  end
  
  def create
    concept = Concept.new
    concept.subscribe(self)
    concept.create_me(concept: params[:concept])
  end
  
  def new
    @concept = Concept.new
  end

  def edit
    @concept = Concept.find(params[:id])
  end

  
  def update
    concept = Concept.find(params[:id])
    concept.subscribe(self)
    concept.update_me(concept: params[:concept])    
  end
  
  def successful_concept_save_event(concept)
    redirect_to configurations_path
  end

  

  
end