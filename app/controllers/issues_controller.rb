class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  # GET /issues
  def index
    @issues = Issue.where(:user_id => session[:user_id]).includes(:status, :user, :type)
  end

  # GET /issues/1
  def show
  end

  # GET /issues/new
  def new
    @action = 1
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
    @action = 2
  end

  # POST /issues
  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = session[:user_id]
    @issue.priority_id = params[:issue][:priority_id]
    if @issue.save
      redirect_to @issue, notice: 'Issue was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /issues/1
  def update
    @issue.priority_id = params[:issue][:priority_id]
    if @issue.update(issue_params)
      redirect_to @issue, notice: 'Issue was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /issues/1
  def destroy
    @issue.destroy
    redirect_to issues_url, notice: 'Issue was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def issue_params
      params.require(:issue).permit(:id, :title, :description, :comment_id, :expected_data, :close_date, :status_id, :user_id, :type_id, :priority_id)
    end
end
