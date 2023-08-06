require './init'

openai = OpenAI::Client.new(access_token: OPENAI_API_KEY)

Commit.last(1000).each do |commit|
  print '.'

  begin
    response = openai.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: commit.diff
      }
    )

    embedding = response['data'][0]['embedding']
  rescue StandardError => e
    puts response
    puts e.message
    next
  end

  Vector.create id: commit.sha, embedding: embedding, metadata: {}, document: commit.diff
end

puts 'DONE'
