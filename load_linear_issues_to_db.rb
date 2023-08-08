require './init'

repo = Linear.new
repo.each_issue do |raw_issue|
  print '.'
  Issue.create number: raw_issue['identifier'],
               title: raw_issue['title'],
               description: raw_issue['description']
end

puts 'done'
