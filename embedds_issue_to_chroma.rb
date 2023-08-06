require './init'

openai = OpenAI::Client.new(access_token: OPENAI_API_KEY)

Issue.first(1000).each do |issue|
  print '.'

  document = "Title: #{issue.title}. Description: #{issue.description}"

  begin
    response = openai.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: document
      }
    )

    embedding = response['data'][0]['embedding']
  rescue StandardError => e
    puts response
    puts e.message
    next
  end

  Vector.create id: "Issue #{issue.id}", embedding: embedding, metadata: {}, document: document
end

puts 'DONE'
