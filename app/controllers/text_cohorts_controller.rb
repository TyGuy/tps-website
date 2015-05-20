class TextCohortsController < ApplicationController

  before_action :require_login

  def new
    @cohort = TextCohort.new
  end

  def create
    @cohort = TextCohort.new(text_cohort_params)
    saved = @cohort.save
    if saved
      flash[:success] = "Text cohort successfully created!"
      @cohort.create_entries_from_file(params[:text_cohort][:cohort_file])

      redirect_to text_cohort_path(@cohort)
    else
      flash[:error] = "Issue creating text cohort: #{@cohort.errors.join("\t")}"
      redirect_to new_text_cohorts_path
    end
  end

  def update
    @cohort = TextCohort.find(params[:id])
  end

  def show
    @cohort = TextCohort.find(params[:id])
  end


  private
  def text_cohort_params
    params.require(:text_cohort).permit(:name)
  end


end
