class WelcomesController < ApplicationController
  def show
  end

  def index
  end

  def change_to_english
      config.language='en'
	  respond_to do |format|
		format.html { redirect_to 'welcomes_index' }
	  end
  end 

  def change_to_spanish
      config.language='es'
	  respond_to do |format|
		format.html { redirect_to 'welcomes_index' }
	  end
  end 
end
