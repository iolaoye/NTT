class ValidationsController < ApplicationController

  # GET /validation
  def index
  end

  # GET /validations/1
  def show
  	if lookup_context.find_all('validations/' + params[:id]).any?
  		render params[:id]
  	else
  		@state_name = State.find_by_state_abbreviation(params[:id]).state_name
  		render "statement"
  	end
  end

end
