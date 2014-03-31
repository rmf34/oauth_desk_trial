class Desk::AccessTokenError < StandardError

  def message
    'Problem building access token'
  end
end
