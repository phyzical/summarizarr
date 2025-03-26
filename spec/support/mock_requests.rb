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
    base_url = load_config.sonarr.base_url
    stub_endpoint("#{base_url}#{Sonarr::Service.since_endpoint}")
    stub_endpoint("#{base_url}#{Sonarr::Service.status_endpoint}")
  end

  def stub_lidarr
    base_url = load_config.lidarr.base_url
    stub_endpoint("#{base_url}#{Lidarr::Service.since_endpoint}")
    stub_endpoint("#{base_url}#{Lidarr::Service.status_endpoint}")
  end

  def stub_radarr
    base_url = load_config.radarr.base_url
    stub_endpoint("#{base_url}#{Radarr::Service.since_endpoint}")
    stub_endpoint("#{load_cbase_url}#{Radarr::Service.status_endpoint}")
  end

  def stub_bazarr
    base_url = load_config.bazarr.base_url
    stub_endpoint("#{base_url}#{Bazarr::Service.episode_history_endpoint}")
    stub_endpoint("#{base_url}#{Bazarr::Service.movie_history_endpoint}")
    stub_endpoint("#{base_url}#{Bazarr::Service.status_endpoint}")
  end

  def stub_all
    stub_lidarr
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
