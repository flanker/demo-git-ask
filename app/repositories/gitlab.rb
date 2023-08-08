class Gitlab
  def each_issue(pages = 10, &block)
    page = 1

    pages.times do
      headers = { 'PRIVATE-TOKEN' => GITLAB_API_TOKEN }
      response = RestClient.get "#{GITLAB_PROJECT_BASE_URL}/issues?page=#{page}", headers

      raw_issues = JSON.parse(response)

      break if raw_issues.empty?

      raw_issues.each(&block)

      page += 1
    end
  end
end
