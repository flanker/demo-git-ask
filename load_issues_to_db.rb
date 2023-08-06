require './init'

Issue.destroy_all

repo = Gitlab.new
repo.each_issue(100) do |raw_issue|
  print '.'
  Issue.create number: raw_issue['id'],
               title: raw_issue['title'],
               description: raw_issue['description']
end

puts 'done'
