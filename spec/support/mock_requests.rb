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
    stub_endpoint("#{load_config.sonarr.base_url}#{Sonarr::Service::SINCE_ENDPOINT}")
    stub_endpoint("#{load_config.sonarr.base_url}#{Sonarr::Service::STATUS_ENDPOINT}")
  end

  def stub_radarr
    stub_endpoint("#{load_config.radarr.base_url}#{Radarr::Service::SINCE_ENDPOINT}")
    stub_endpoint("#{load_config.radarr.base_url}#{Radarr::Service::STATUS_ENDPOINT}")
  end

  def stub_bazarr
    stub_endpoint("#{load_config.bazarr.base_url}#{Bazarr::Service::EPISODE_HISTORY_ENDPOINT}")
    stub_endpoint("#{load_config.bazarr.base_url}#{Bazarr::Service::MOVIE_HISTORY_ENDPOINT}")
    stub_endpoint("#{load_config.bazarr.base_url}#{Bazarr::Service::STATUS_ENDPOINT}")
  end

  def stub_all
    stub_bazarr
    stub_sonarr
    stub_radarr
    stub_fakeserver
  end

  private

  def load_config
    @load_config ||= Config.get
  end
end
