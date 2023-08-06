require './init'

repo = Git.open(LOCAL_GIT_REPO_PATH)

repo.log(1000).each do |commit|
  puts '.'

  Commit.create sha: commit.sha,
                message: commit.message,
                date: commit.date.strftime('%Y-%m-%d %H:%M:%S %z'),
                author_name: commit.author.name,
                author_email: commit.author.email,
                diff: repo.show(commit.sha)
end

puts 'done'
