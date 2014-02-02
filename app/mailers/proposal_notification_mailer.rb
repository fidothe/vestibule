# encoding: utf-8

class ProposalNotificationMailer < ActionMailer::Base
  default from: Vestibule::Application.config.notification_email_from_address

  def self.notify_watcher(watcher, proposal, kind)
    m = send("notification_of_#{kind}_change", watcher, proposal)
    m.deliver
  end

  def notification_of_proposal_change(watcher, proposal)
    @proposal = proposal
    mail(to: watcher.email, subject: "UIKonf proposal ‘#{proposal.title}’ has been updated")
  end

  def notification_of_suggestion_change(watcher, proposal)
    @proposal = proposal
    mail(to: watcher.email, subject: "UKonf proposal ‘#{proposal.title}’ has a new suggestion")
  end
end
