task :export => :environment do
  require 'csv'
  require 'securerandom'

  csv_path = Rails.root.join('public/', SecureRandom.uuid + '.csv')
  CSV.open(csv_path, 'w:Windows-1252') do |csv|
    csv << ['votes', 'title', 'author', 'email', 'ID', 'URL']
    Proposal.all.each do |p|
      votes = proposal.selections.count
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
  puts "http://vestibule.uikonf.com/tmp/#{csv_path.basename}"
end
