class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :check_viewing_allowed, only: [:index]
  before_filter :check_voting_allowed, only: [:create, :destroy]

  def index
    if can?(:see, :agenda)
      @top_proposals = Selection.popular.select { |count, proposal| proposal.confirmed? }.take(8)
    end
    if current_user && can?(:make, :selection)
      @proposals = Proposal.available_for_selection_by(current_user)
    end
  end

  def create
    selection = current_user.selections.build(params[:selection])
    if selection.save
      redirect_to selections_path
    else
      redirect_to selections_path, alert: selection.errors.full_messages.to_sentence
    end
  end

  def destroy
    selection = current_user.selections.find(params[:id])
    selection.destroy
    redirect_to selections_path
  end

  private
  def check_viewing_allowed
    no_one(can?(:see, :selection) || can?(:see, :agenda)) do
      flash[:alert] = t('vestibule.selections.action_alert.see', mode: Vestibule.mode_of_operation.mode)
      redirect_to dashboard_path
    end
  end

  def check_voting_allowed
    no_one(can?(:make, :selection)) do
      flash[:alert] = t('vestibule.selections.action_alert.vote', mode: Vestibule.mode_of_operation.mode)
      redirect_to dashboard_path
    end
  end
end
