require 'spec_helper'

describe AuthenticationsController do
  describe '#new' do
    let(:user) { create(:user) }
    let!(:authentication_1) { create(:authentication, :user_id => user.id) }
    let!(:authentication_2) { create(:authentication, :user => user) }

    context 'signed in' do
      it 'should return a list of registered authorizations' do
        sign_in(user)
        get :new, :format => :html

        expect(response).to be_success
        expect(OmniAuth::Builder.providers.length).to eq 1
        expect(OmniAuth::Builder.providers.first).to eq(:desk)
        authorizations = assigns(:connected_authentications)

        expect(authorizations.length).to eq 2
        expect(authorizations.first.user_id).to eq user.id
        expect(authorizations.last.user_id).to eq user.id
      end
    end
    context 'not signed in' do
      it 'should raise an error' do
        get :new, :format => :html
        expect(response).to_not be_success
      end
    end
  end

  describe '#desk_show' do
    let(:user) { create(:user) }
    let(:authentication_1) { create(:authentication, :user_id => user.id) }

    context 'signed in' do
      xit 'should show the desk dashboard' do
        Desk::ApiWrapper.stub(:get).and_return()
        sign_in(user)
        get :desk_show, :id => authentication_1.id, :format => :html
        expect(response).to be_success
      end

      it 'should handle token exceptions' do
        Desk::ApiWrapper.stub(:patch).and_return(Desk::AccessTokenError)
        sign_in(user)
        get :desk_show, :id => authentication_1.id, :format => :html

        expect(response).to be_redirect
        expect(flash[:error]).to be_present
      end
    end

    context 'not signed in' do
      it 'should raise an error' do
        get :desk_show, :id => authentication_1.id, :format => :html
        expect(response).to_not be_success
      end
    end
  end

  describe '#desk_update' do
    let(:user) { create(:user) }
    let(:authentication_1) { create(:authentication, :user_id => user.id) }
    let(:resource) { 1 }

    context 'signed in' do
      context 'success' do
        it 'should create a new label' do
          Desk::ApiWrapper.stub(:patch).and_return('201')

          sign_in(user)
          patch :desk_update, :authentication_id => authentication_1.id, :id => resource, :format => :html
          expect(response).to be_redirect
          expect(flash[:notice]).to be_present
        end
      end

      context 'failure' do
        it 'should handle the error' do
          Desk::ApiWrapper.stub(:patch).and_return('400')

          sign_in(user)
          patch :desk_update, :authentication_id => authentication_1.id, :id => resource, :format => :html
          expect(response).to be_redirect
          expect(flash[:error]).to be_present
        end

        it 'should handle token exceptions' do
          Desk::ApiWrapper.stub(:patch).and_return(Desk::AccessTokenError)
          sign_in(user)
          patch :desk_update, :authentication_id => authentication_1.id, :id => resource, :format => :html

          expect(response).to be_redirect
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'not signed in' do
      it 'should raise an error' do
        patch :desk_update, :authentication_id => authentication_1.id, :id => resource, :format => :html
        expect(response).to_not be_success
      end
    end
  end

  describe '#desk_create' do
    let(:user) { create(:user) }
    let(:authentication_1) { create(:authentication, :user_id => user.id) }

    context 'signed in' do
      context 'success' do
        it 'should create a new label' do
          Desk::ApiWrapper.stub(:post).and_return('200')

          sign_in(user)
          post :desk_create, :id => authentication_1.id, :format => :html
          expect(response).to be_redirect
          expect(flash[:notice]).to be_present
        end
      end

      context 'failure' do
        it 'should handle the error' do
          Desk::ApiWrapper.stub(:post).and_return('400')

          sign_in(user)
          post :desk_create, :id => authentication_1.id, :format => :html
          expect(response).to be_redirect
          expect(flash[:error]).to be_present
        end

        it 'should handle token exceptions' do
          Desk::ApiWrapper.stub(:patch).and_return(Desk::AccessTokenError)
          sign_in(user)
          post :desk_create, :id => authentication_1.id, :format => :html

          expect(response).to be_redirect
          expect(flash[:error]).to be_present
        end
      end
    end

    context 'not signed in' do
      it 'should raise an error' do
        post :desk_create, :id => authentication_1.id, :format => :html
        expect(response).to_not be_success
      end
    end
  end

  describe '#create' do
    let(:user) { create(:user) }
    let(:authentication_1) { create(:authentication, :user_id => user.id) }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:desk]
    end

    context 'signed in' do
      it 'should redirect' do
        sign_in(user)
        expect(Authentication.count).to eq 0
        get :create, :provider => 'desk', :format => :html
        expect(response).to be_redirect
        expect(Authentication.count).to eq 1
      end
    end

    context 'not signed in' do
      it 'should raise an error' do
        get :create, :provider => 'desk', :format => :html
        expect(response).to_not be_success
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }
    let!(:authentication_1) { create(:authentication, :user_id => user.id) }

    context 'signed in' do
      it 'should show the desk dashboard' do
        sign_in(user)
        expect(Authentication.count).to eq 1
        delete :destroy, :id => authentication_1.id, :format => :html
        expect(response).to redirect_to(new_authentication_path)
        expect(authentication_1)
        expect(Authentication.count).to eq 0
      end
    end

    context 'not signed in' do
      it 'should raise an error' do
        delete :destroy, :id => authentication_1.id, :format => :html
        expect(response).to_not be_success
      end
    end
  end

end
