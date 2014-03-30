class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_authentication, :only => [:destroy, :desk_update, :desk_create]

  def new
    providers = OmniAuth::Builder.providers
    @possible_authentications = providers

    @connected_authentications = Authentication.where(
      :user_id => current_user.id,
      :provider => providers.map(&:to_s))
  end

  def desk_show
    @connected_authentications = Authentication.where(:user_id => current_user.id, :provider => :desk)

    if @connected_authentications.empty?
      redirect_to new_authentication_path
    else
      load_authentication
      @labels = Desk::ApiWrapper.get(@authentication, :labels, 50, [nil, nil], {:embedded => true, :ostruct => true, :convert_json => true})

      @label_list = @labels.map(&:name)

      first_filter_id = Desk::ApiWrapper.get(@authentication, :filters, 1, ['sort_direction', 'asc'], {:embedded => true, :ostruct => false, :convert_json => true})['_links']['self']['href'].split('/').last


      @cases_filter_1 = Desk::ApiWrapper.get(@authentication, :cases, 50, ['filter_id', first_filter_id], {:embedded => true, :ostruct => true, :convert_json => true})

      # this part was a little confusing, as I needed the filter, ID
      # I understand that to be the full url, from here: http://dev.desk.com/API/using-the-api/#identifiers
      # but we still need to split out the numeric id to make a '?filter_id=' request
      # /api/v2/filters/1928837
    end
  end

  def desk_update
    response_code = Desk::ApiWrapper.patch(@authentication, params[:resource_type], params[:id], params[:label], params[:replace])

    if response_code == '201'
      flash[:notice] = "#{params[:label]} Label successfully created."
      redirect_to desk_show_authentication_path(@authentication)
    else
      flash[:error] = "Something went wrong adding the #{params[:label]} label."
      redirect_to desk_show_authentication_path(@authentication)
    end
  end

  def desk_create
    response_code = Desk::ApiWrapper.post(@authentication, params[:resource_type], params[:name], params[:color])

    if response_code == '200'
      flash[:notice] = "#{params[:name]} Label successfully created."
      redirect_to desk_show_authentication_path(@authentication)
    else
      flash[:error] = "Something went wrong creating a #{params[:resource_type]} called #{params[:name]}"
      redirect_to desk_show_authentication_path(@authentication)
    end
  end

  def create
    auth = request.env['omniauth.auth']
    new_auth = current_user.authentications.build(
      :provider => auth['provider'],
      :uid =>    auth['uid'],
      :token =>  auth['credentials']['token'],
      :secret => auth['credentials']['secret'],
      :site =>   auth['info']['site'])

    if new_auth.save
      flash[:notice] = "#{auth['provider'].capitalize} successfully authorized."
      redirect_to desk_show_authentication_path(new_auth.id)
    else
      flash[:error] = "Something went wrong authorizing #{auth['provider'].capitalize}"
      redirect_to new_authentication_path
    end
  end

  def destroy
    if @authentication.destroy
      flash[:notice] = "#{@authentication.provider.capitalize} authentication destroyed."
      redirect_to new_authentication_path
    else
      flash[:error] = 'Something went wrong destroying the Authentication.'
    end
  end

  private

    def load_authentication
      @authentication = Authentication.find(params[:id])
    end

    # skipped strong params in an effort to save time

end
