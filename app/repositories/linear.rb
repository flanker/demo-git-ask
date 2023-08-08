class Linear
  def each_issue
    headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{LINEAR_API_TOKEN}"
    }

    after_cursor = ''

    loop do
      payload = if after_cursor.empty?
                  '{ "query": "{ issues(first: 50) { edges { node { id identifier title description } cursor } pageInfo { hasNextPage endCursor } } }" }'
                else
                  '{ "query": "{ issues(first: 50, after: \"' + after_cursor + '\") { edges { node { id identifier title description } cursor } pageInfo { hasNextPage endCursor } } }" }'
                end

      response = RestClient.post 'https://api.linear.app/graphql', payload, headers

      results = JSON.parse(response.body)

      results['data']['issues']['edges'].each do |issue|
        yield issue['node']    # {"identifier": "", "title": "", "description": ""}
      end

      break unless results['data']['issues']['pageInfo']['hasNextPage']

      after_cursor = results['data']['issues']['pageInfo']['endCursor']
    end
  end
end
