require './init'

feature = '门户'
puts "#{feature} 的 check list"

openai = OpenAI::Client.new(access_token: OPENAI_API_KEY)

response = openai.embeddings(
  parameters: {
    model: 'text-embedding-ada-002',
    input: feature
  }
)

embedding = response['data'][0]['embedding']

context_embeddings = Vector.query(embedding: embedding)
full_context = context_embeddings.map.with_index do |context_embedding, index|
  "资料#{index + 1}: #{context_embedding.document}"
end.join("\n")

prompt = <<~PROMPT
  你是金数据研发团队的高级工程师，你正在实现一个#{feature}的功能。
  为了保证上线的质量，你先制定一个上线的 Check list：

  下面是一些关于这个功能的资料：

  #{full_context.first(10_000)}

  Checklist:
PROMPT

response = openai.chat(
  parameters: {
    model: 'gpt-3.5-turbo-16k',
    messages: [{ role: 'user', content: prompt }],
    temperature: 0.7
  }
)

puts response.dig('choices', 0, 'message', 'content')
