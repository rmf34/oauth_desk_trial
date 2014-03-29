module AuthenticationHelper

  def already_authenticated?(provider)
    Authentication.where(:user_id => current_user.id, :provider => provider).present?
  end

end
