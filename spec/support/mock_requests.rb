# frozen_string_literal: true

module MockRequests
  def stub_endpoint(url)
    url = URI(url)
    stub_request(:get, /#{url}/).to_return(
      status: 200,
      body: File.read("spec/support/requests/#{url.host}#{url.path}.json")
    )
  end

  def stub_fakeserver
    stub_request(:get, /fakeserver/).to_return(status: 500)
  end

  def stub_sonarr
    api_url = 'http://sonarr:8989/api/v3'
    stub_endpoint("#{api_url}/history/since")
    stub_endpoint("#{api_url}/system/status")
  end

  def stub_radarr
    api_url = 'http://radarr:7878/api/v3'
    stub_endpoint("#{api_url}/history/since")
    stub_endpoint("#{api_url}/system/status")
  end

  def stub_all
    stub_sonarr
    stub_radarr
    stub_fakeserver
  end
end
