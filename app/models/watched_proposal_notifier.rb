class WatchedProposalNotifier
  def self.notify_proposal_change(proposal, changing_user)
    notify(proposal, changing_user, :proposal)
  end

  def self.notify_new_suggestion(proposal, changing_user)
    notify(proposal, changing_user, :suggestion)
  end

  def self.notify(proposal, changing_user, kind)
    proposal.watchers.where("users.id != ?", changing_user.id).each do |watcher|
      ProposalNotificationMailer.notify_watcher(watcher, proposal, kind)
    end
  end
end
