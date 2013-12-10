class SuggestionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_action_allowed

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @suggestion = current_user.suggestions.build(params[:suggestion].merge(:proposal => @proposal))
    if @suggestion.save
      redirect_to proposal_path(@proposal)
    else
      render :template => 'proposals/show'
    end
  end

  def check_action_allowed
    no_one(can?(:make, :suggestion)) do
      flash[:alert] = t('vestibule.suggestions.action_alert', mode: Vestibule.mode_of_operation.mode)
      redirect_to proposal_path(params[:proposal_id])
    end
  end
end
