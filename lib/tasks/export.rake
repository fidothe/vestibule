task :export => :environment do
  require 'csv'

  csv_path = Rails.root.join('public/tmp', SecureRandom.uuid + '.csv')
  CSV.open(csv_path, 'w:Windows-1252') do |csv|
    csv << ['votes', 'title', 'author', 'email', 'ID', 'URL']
    Proposal.each do |p|
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
