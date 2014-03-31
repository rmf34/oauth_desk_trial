require 'spec_helper'

describe Desk::ApiWrapper do

  describe '.get' do
    context 'access token built successfully' do
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

