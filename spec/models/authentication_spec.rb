require 'spec_helper'

describe Authentication do

  context 'a new user' do
    let(:user) { create(:user) }
    let(:authentication) { create(:authentication, :user => user) }

    it 'should have one user' do
      authentication.should respond_to :user
      expect(authentication.provider).to eq 'desk'
      expect(authentication.site).to eq 'https://rmf34.desk.com'
      expect(authentication.reload.user).to eq user
    end
  end

end
