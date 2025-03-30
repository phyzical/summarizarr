# frozen_string_literal: true

module MockRequests
  def stub_endpoint(url)
    url = URI(url)
    stub_request(:get, /#{url.path}.*#{url.query}.*/).to_return(
      status: 200,
      body:
        File.read(
          "spec/support/requests/#{url.host}#{url.path}#{url.query ? "?#{url.query}" : ''}.json",
          encoding: 'bom|utf-8'
        )
    )
  end

  def stub_fakeserver
    stub_request(:get, /fakeserver/).to_return(status: 500)
  end

  def stub_sonarr
    base_url = load_config.sonarr.base_url
    45.times.each { |i| stub_endpoint("#{base_url}#{Sonarr::Service.history_endpoint}?page=#{i + 1}") }
    stub_endpoint("#{base_url}#{Sonarr::Service.status_endpoint}")
  end

  def stub_lidarr
    base_url = load_config.lidarr.base_url
    3.times.each { |i| stub_endpoint("#{base_url}#{Lidarr::Service.history_endpoint}?page=#{i + 1}") }
    stub_endpoint("#{base_url}#{Lidarr::Service.status_endpoint}")
  end

  def stub_readarr
    base_url = load_config.readarr.base_url
    2.times.each { |i| stub_endpoint("#{base_url}#{Readarr::Service.history_endpoint}?page=#{i + 1}") }
    stub_endpoint("#{base_url}#{Readarr::Service.status_endpoint}")
  end

  def stub_radarr
    base_url = load_config.radarr.base_url
    3.times.each { |i| stub_endpoint("#{base_url}#{Radarr::Service.history_endpoint}?page=#{i + 1}") }
    stub_endpoint("#{base_url}#{Radarr::Service.status_endpoint}")
  end

  def stub_bazarr
    base_url = load_config.bazarr.base_url
    stub_endpoint("#{base_url}#{Bazarr::Service.episode_history_endpoint}")
    stub_endpoint("#{base_url}#{Bazarr::Service.movie_history_endpoint}")
    stub_endpoint("#{base_url}#{Bazarr::Service.status_endpoint}")
  end

  def stub_mylar3
    base_url = load_config.mylar3.base_url
    stub_endpoint("#{base_url}#{Mylar3::Service.api_prefix}?cmd=#{Mylar3::Service.status_cmd}")
    stub_endpoint("#{base_url}#{Mylar3::Service.api_prefix}?cmd=#{Mylar3::Service.history_cmd}")
  end

  def stub_all
    stub_readarr
    stub_lidarr
    stub_bazarr
    stub_sonarr
    stub_radarr
    stub_mylar3
    stub_fakeserver
  end

  private

  def load_config
    @load_config ||= Config.get
  end
end
