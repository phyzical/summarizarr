# frozen_string_literal: true

module MockRequests
  def stub_endpoint(url:, type: :get)
    url = URI(url)
    stub_request(type, /#{url.path}.*#{url.query}.*/).with(body: anything).to_return(
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
    count_pages(url: "sonarr#{Sonarr::Service.history_endpoint}").times.each do |i|
      stub_endpoint(url: "#{"#{base_url}#{Sonarr::Service.history_endpoint}"}?page=#{i + 1}")
    end
    stub_endpoint(url: "#{base_url}#{Sonarr::Service.status_endpoint}")
  end

  def stub_lidarr
    base_url = load_config.lidarr.base_url
    count_pages(url: "lidarr#{Lidarr::Service.history_endpoint}").times.each do |i|
      stub_endpoint(url: "#{"#{base_url}#{Lidarr::Service.history_endpoint}"}?page=#{i + 1}")
    end
    stub_endpoint(url: "#{base_url}#{Lidarr::Service.status_endpoint}")
  end

  def stub_readarr
    base_url = load_config.readarr.base_url
    count_pages(url: "readarr#{Readarr::Service.history_endpoint}").times.each do |i|
      stub_endpoint(url: "#{"#{base_url}#{Readarr::Service.history_endpoint}"}?page=#{i + 1}")
    end
    stub_endpoint(url: "#{base_url}#{Readarr::Service.status_endpoint}")
  end

  def stub_radarr
    base_url = load_config.radarr.base_url
    count_pages(url: "radarr#{Radarr::Service.history_endpoint}").times.each do |i|
      stub_endpoint(url: "#{"#{base_url}#{Radarr::Service.history_endpoint}"}?page=#{i + 1}")
    end
    stub_endpoint(url: "#{base_url}#{Radarr::Service.status_endpoint}")
  end

  def stub_bazarr
    base_url = load_config.bazarr.base_url
    count_pages(url: "bazarr#{Bazarr::Service.episode_history_endpoint}").times.each do |i|
      stub_endpoint(
        url: "#{"#{base_url}#{Bazarr::Service.episode_history_endpoint}"}?start=#{i * Bazarr::Service::PAGE_SIZE}"
      )
    end
    count_pages(url: "bazarr#{Bazarr::Service.movie_history_endpoint}").times.each do |i|
      stub_endpoint(
        url: "#{"#{base_url}#{Bazarr::Service.movie_history_endpoint}"}?start=#{i * Bazarr::Service::PAGE_SIZE}"
      )
    end
    stub_endpoint(url: "#{base_url}#{Bazarr::Service.status_endpoint}")
  end

  def stub_mylar3
    base_url = load_config.mylar3.base_url
    stub_endpoint(url: "#{base_url}#{Mylar3::Service.api_prefix}?cmd=#{Mylar3::Service.status_cmd}")
    stub_endpoint(url: "#{base_url}#{Mylar3::Service.api_prefix}?cmd=#{Mylar3::Service.history_cmd}")
  end

  def stub_tdarr
    base_url = load_config.tdarr.base_url
    count_pages(url: "tdarr#{Tdarr::Service.jobs_endpoint}").times.each do |i|
      stub_endpoint(type: :post, url: "#{"#{base_url}#{Tdarr::Service.jobs_endpoint}"}?page=#{i}")
    end
    stub_endpoint(url: "#{base_url}#{Tdarr::Service.status_endpoint}")
  end

  def stub_all
    stub_readarr
    stub_lidarr
    stub_bazarr
    stub_sonarr
    stub_radarr
    stub_mylar3
    stub_tdarr
    stub_fakeserver
  end

  private

  def count_pages(url:)
    Dir.glob("spec/support/requests/#{url}*").count
  end

  def load_config
    @load_config ||= Config.get
  end
end
