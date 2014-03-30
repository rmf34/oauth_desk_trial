class Desk::ApiWrapper

  def self.get(authentication, resource, count, search_param, options = {})
    access_token = self.build_access_token(authentication)

    if access_token.present?
      response = access_token.get("#{authentication.site}/api/v2/#{resource}?#{search_param[0]}=#{search_param[1]}").body

      if options[:convert_json] == true
        response = JSON.parse(response)
      end

      if options[:embedded] == true
        response = response['_embedded']['entries']
      end

      if response.is_a?(Array) && options[:ostruct] == true
        collection = []
        response.each do |entry|
          collection << OpenStruct.new(entry)
        end
        response = collection
      end

      return self.return_count(response, count)
    else
      raise StandardError, 'Problem building access token'
    end
  end

  def self.patch(authentication, resource, resource_id)
    access_token = self.build_access_token(authentication)

    if access_token.present?
      response = access_token.put("#{authentication.site}/api/v2/#{resource}/#{resource_id}").body

      return response
    else
      raise StandardError, 'Problem building access token'
    end
  end


  private

    def self.return_count(collection, count)
      if count == 1
        return collection.first
      else
        return collection[0...count]
      end
    end

    def self.build_access_token(authentication)
      consumer = OAuth::Consumer.new(ENV["#{authentication.provider.upcase}_KEY"], ENV["#{authentication.provider.upcase}_SECRET"], :site => authentication.site, :scheme => :header)

      OAuth::AccessToken.new(consumer, authentication.token, authentication.secret)
    end

end
