task :export => :environment do
  require 'csv'
  require 'securerandom'

  class VotesMailer < ActionMailer::Base
    def votes_email(csv)
      attachments['votes.csv'] = csv
      mail(to: "uikonf-team@googlegroups.com",
           body: "Votes",
           subject: "Votes")
    end
  end

  csv_string = CSV.generate do |csv|
    csv << ['votes', 'title', 'author', 'email', 'ID', 'URL']
    Proposal.all.each do |proposal|
      votes = Selection.where(proposal_id: proposal.id).count
      author = proposal.proposer
      csv << [
        votes,
        proposal.title,
        author.name,
        author.email,
        proposal.id,
        "http://vestibule.uikonf.com/proposals/#{proposal.id}"
      ]
    end
  end

  VotesMailer.votes_email(csv_string).deliver
end
