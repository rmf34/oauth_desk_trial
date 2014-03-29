class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_authentication, :only => [:show, :destroy]

  def index
    @connected_authentications = Authentication.where(:user_id => current_user.id)
    @possible_authentications = OmniAuth::Builder.providers.map(&:to_s)
  end

  def show
  end

  def create
    auth = request.env['omniauth.auth']
    current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
    flash[:notice] = "#{auth['provider'].capitalize} successfully authorized."
    redirect_to authentications_url
  end

  def destroy
    if @authentication.destroy
      flash[:notice] = "#{@authentication.provider.capitalize} authentication destroyed."
      redirect_to authentications_url
    else
      flash[:notice] = 'Something went wrong destroying the Authentication.'
    end
  end

  private

    def load_authentication
      @authentication = Authentication.find(params[:id])
    end

end
