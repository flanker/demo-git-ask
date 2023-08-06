require './init'

diff = <<~DIFF
YOUR AWESOME CODE DIFF HERE
DIFF

openai = OpenAI::Client.new(access_token: OPENAI_API_KEY)

response = openai.embeddings(
  parameters: {
    model: 'text-embedding-ada-002',
    input: diff
  }
)

embedding = response['data'][0]['embedding']

context_embeddings = Vector.query(embedding: embedding)
full_context = context_embeddings.map.with_index do |context_embedding, index|
  "Git commit #{index + 1}:\n #{context_embedding.document}"
end.join("\n")

prompt = <<~PROMPT
你是金数据研发团队的高级工程师，你正在准备提交一个 git commit，请帮忙写一个合适的 commit message。

下面是一些这个代码库之前的 git commit 信息

#{full_context.first(10_000)}

你需要写的 commit message 格式要求

第一个行：WHY is this change

空格一行之后，What it does? 这里可以写多行

下面是这次的 diff:

#{diff}

Git commit message:

PROMPT

response = openai.chat(
  parameters: {
    model: 'gpt-3.5-turbo-16k',
    messages: [{ role: 'user', content: prompt }],
    temperature: 0.7
  }
)

puts response.dig('choices', 0, 'message', 'content')
