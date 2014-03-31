require 'spec_helper'

describe Desk::ApiWrapper do
  let(:user) { create(:user) }
  let(:authentication) { create(:authentication, :user => user) }

  before(:each) do
    consumer = OAuth::Consumer.new(ENV["#{authentication.provider.upcase}_KEY"], ENV["#{authentication.provider.upcase}_SECRET"], :site => authentication.site, :scheme => :header)

    Desk::ApiWrapper.stub(:build_access_token).and_return(OAuth::AccessToken.new(consumer, authentication.token, authentication.secret))
  end

  describe '.get' do
    context 'access token built successfully' do
      before(:each) do
        mock_request
      end

      it 'should handle OpenStruct' do
        request = Desk::ApiWrapper.get(authentication, :labels, 50, [nil, nil], {:embedded => true, :ostruct => true, :convert_json => true})

        expect(request.length).to eq 13
        expect(request.first.class).to eq OpenStruct
      end

      it 'should return desired count of ruby hashes' do
        request = Desk::ApiWrapper.get(authentication, :labels, 1, [nil, nil], {:embedded => true, :ostruct => false, :convert_json => true})

        expect(request.keys.count).to eq 6
        expect(request['name']).to eq 'Abandoned Chats'
        expect(request.class).to eq Hash
      end

      def mock_request
        stub_request(:get, "https://rmf34.desk.com/api/v2/labels?=").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'OAuth gem v0.4.7'}).
         to_return(:status => 200, :body => "{\"total_entries\":13,\"page\":1,\"_links\":{\"self\":{\"href\":\"/api/v2/labels?page=1&per_page=50\",\"class\":\"page\"},\"first\":{\"href\":\"/api/v2/labels?page=1&per_page=50\",\"class\":\"page\"},\"last\":{\"href\":\"/api/v2/labels?page=1&per_page=50\",\"class\":\"page\"},\"previous\":null,\"next\":null},\"_embedded\":{\"entries\":[{\"name\":\"Abandoned Chats\",\"description\":\"Abandoned Chats\",\"enabled\":true,\"types\":[\"case\",\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720387\",\"class\":\"label\"}}},{\"name\":\"another label\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"blue\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1721656\",\"class\":\"label\"}}},{\"name\":\"Another label 2\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"blue\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1721657\",\"class\":\"label\"}}},{\"name\":\"Escalated\",\"description\":\"Escalated\",\"enabled\":true,\"types\":[\"case\",\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720386\",\"class\":\"label\"}}},{\"name\":\"Example\",\"description\":\"Example\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720384\",\"class\":\"label\"}}},{\"name\":\"Feedback\",\"description\":\"Feedback\",\"enabled\":true,\"types\":[\"case\",\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720382\",\"class\":\"label\"}}},{\"name\":\"More Info\",\"description\":\"More Info\",\"enabled\":true,\"types\":[\"case\",\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720383\",\"class\":\"label\"}}},{\"name\":\"Negative Feedback\",\"description\":\"Negative Feedback\",\"enabled\":true,\"types\":[\"case\",\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720385\",\"class\":\"label\"}}},{\"name\":\"pink label\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"pink\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1721671\",\"class\":\"label\"}}},{\"name\":\"prove it\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"blue\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1721655\",\"class\":\"label\"}}},{\"name\":\"red 11\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"red\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1721670\",\"class\":\"label\"}}},{\"name\":\"Sample Macros\",\"description\":\"Sample Macros\",\"enabled\":true,\"types\":[\"macro\"],\"color\":\"default\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1720381\",\"class\":\"label\"}}},{\"name\":\"Test label desk\",\"description\":\"A Test Label\",\"enabled\":true,\"types\":[\"case\"],\"color\":\"yellow\",\"_links\":{\"self\":{\"href\":\"/api/v2/labels/1722715\",\"class\":\"label\"}}}]}}", :headers => {})
      end
    end

    context 'access token error' do
      let(:user) { create(:user) }
      let(:authentication) { create(:authentication, :user => user) }

      it 'should raise an error' do
        Desk::ApiWrapper.stub(:build_access_token).and_return(nil)

        expect{
          Desk::ApiWrapper.get(authentication, :cases, 1, [nil, nil])
        }.to raise_error(Desk::AccessTokenError)
      end
    end
  end

  describe '.patch' do
    context 'access token built successfully' do

      it 'updates successfully' do
        mock_request
        request = Desk::ApiWrapper.patch(authentication, :cases, 1, 'New Red label', 'false')

        expect(request).to eq '200'
      end

      def mock_request
        stub_request(:put, "https://rmf34.desk.com/api/v2/cases/1").
         with(:body => "{\"subject\":\"Updated\",\"status\":\"pending\",\"labels\":\"New Red label\",\"label_action\":\"append\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'89', 'User-Agent'=>'OAuth gem v0.4.7'}).
         to_return(:status => 200, :body => '', :headers => {})
      end
    end

    context 'access token error' do
      let(:user) { create(:user) }
      let(:authentication) { create(:authentication, :user => user) }

      it 'should raise an error' do
        Desk::ApiWrapper.stub(:build_access_token).and_return(nil)

        expect{
          Desk::ApiWrapper.patch(authentication, :cases, 1, 'New Label Name', false)
        }.to raise_error(Desk::AccessTokenError)
      end
    end
  end

  describe '.post' do
    context 'access token built successfully' do
      it 'creates a label successfully' do
        mock_request
        request = Desk::ApiWrapper.post(authentication, :labels, 'New Red label', 'Red')

        expect(request).to eq '201'
      end

      def mock_request
       stub_request(:post, "https://rmf34.desk.com/api/v2/labels").
         with(:body => "{\"name\":\"New Red label\",\"description\":\"A Test Label\",\"types\":[\"case\"],\"color\":\"red\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'84', 'User-Agent'=>'OAuth gem v0.4.7'}).
         to_return(:status => 201, :body => '', :headers => {})
      end

    end

    context 'access token error' do
      let(:user) { create(:user) }
      let(:authentication) { create(:authentication, :user => user) }

      it 'should raise an error' do
        Desk::ApiWrapper.stub(:build_access_token).and_return(nil)

        expect{
          Desk::ApiWrapper.post(authentication, :cases, 'Label Name', 'red')
        }.to raise_error(Desk::AccessTokenError)
      end
    end
  end

end
