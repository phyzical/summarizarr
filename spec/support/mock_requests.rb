# frozen_string_literal: true

module MockRequests
  def stub_endpoint(url)
    url = URI(url)
    stub_request(:get, /#{url}/).to_return(status: 200, body: File.read("spec/support/#{url.host}#{url.path}.json"))
  end
end
