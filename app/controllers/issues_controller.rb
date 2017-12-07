class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  # GET /issues
  def index
    debugger
    @issues = Issue.includes(:comment, :status, :user, :type).where(:user_id => session[:user_id])
  end

  # GET /issues/1
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to @issue, notice: 'Issue was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /issues/1
  def update
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
      params.require(:issue).permit(:id, :title, :description, :comment_id, :expected_data, :close_date, :status_id, :user_id, :type_id)
    end
end
