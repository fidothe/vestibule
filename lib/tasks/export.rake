task :export => :environment do
  require 'csv'
  require 'securerandom'

  csv_path = Rails.root.join('public/', SecureRandom.uuid + '.csv')
  CSV.open(csv_path, 'w:UTF-8') do |csv|
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
  puts "http://vestibule.uikonf.com/#{csv_path.basename}"
end
