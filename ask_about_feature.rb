require './init'

question = '如何在工作台上查看我的数据'

puts question

openai = OpenAI::Client.new(access_token: OPENAI_API_KEY)

response = openai.embeddings(
  parameters: {
    model: 'text-embedding-ada-002',
    input: question
  }
)

embedding = response['data'][0]['embedding']

context_embeddings = Vector.query(embedding: embedding)
full_context = context_embeddings.map.with_index do |context_embedding, index|
  "资料#{index + 1}: #{context_embedding.document}"
end.join("\n")

prompt = <<~PROMPT
  你是金数据研发团队的高级工程师，请回答我关于业务的问题。

  请问：#{question}

  下面是一些关于这个业务的资料：

  #{full_context.first(10_000)}

  回答：
PROMPT

response = openai.chat(
  parameters: {
    model: 'gpt-3.5-turbo-16k',
    messages: [{ role: 'user', content: prompt }],
    temperature: 0.7
  }
)

puts response.dig('choices', 0, 'message', 'content')
