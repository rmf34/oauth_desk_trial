require 'spec_helper'

describe User do

  context 'a new user' do
    let(:user) { create(:user) }
    let!(:authentication_1) { create(:authentication, :user_id => user.id) }
    let!(:authentication_2) { create(:authentication, :user => user) }

    it 'should have many authentications' do
      user.should respond_to :authentications
      expect(user.email).to be_present
      expect(user.password).to eq 'password'
      expect(user.authentications.length).to eq 2
    end
  end
end
