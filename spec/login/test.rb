require 'faraday'
require 'webmock/rspec'

module LoginRequest

  describe 'POST request to login page' do
    WebMock.disable_net_connect!
    login    = 'hello@world.com'
    password = '12345678'

    before(:all) do
      mocked_body = File.read('spec/fixtures/response.json')
      stub_request(:post, 'http://instatestvx.me/api/auth/login')
        .with(headers: { 'Content-Type' => 'application/json' })
        .to_return(status: 401, body: mocked_body)
    end

    it "with login: #{login} and password: #{password} return response status 401" do
      conn = Faraday.new(:url => 'http://instatestvx.me')
      response = conn.post do |req|
        req.url '/api/auth/login'
        req.headers['Content-Type'] = 'application/json'
        req.body = "{ \"login\": \"#{login}\", \"password\": \"#{password}\" }"
      end

      expect(response.status).to be(401)
    end
  end

end