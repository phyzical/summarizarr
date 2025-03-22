# frozen_string_literal: true

module MockRequests
  def stub_endpoint(url)
    url = URI(url)
    stub_request(:get, /#{url}/).to_return(status: 200, body: File.read("spec/support/#{url.host}#{url.path}.json"))
  end

  def stub_sonarr
    stub_endpoint('http://sonarr:8989/api/v3/history/since')
  end

  def stub_radarr
    stub_endpoint('http://radarr:7878/api/v3/history/since')
  end

  def stub_all
    stub_sonarr
    stub_radarr
  end
end
