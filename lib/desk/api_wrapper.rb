class Desk::ApiWrapper

  LABEL_COLORS = %w(default blue white yellow red orange green black purple brown grey pink).freeze

  def self.get(authentication, resource, count, search_param, options = {})
    access_token = self.build_access_token(authentication)
    raise Desk::AccessTokenError

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

      self.return_count(response, count)
    else
      raise Desk::AccessTokenError
    end
  end

  def self.patch(authentication, resource, resource_id, label, tag_replace)
    access_token = self.build_access_token(authentication)

    if access_token.present?
      label_action = tag_replace == 'true' ? 'replace' : 'append'

      case_hash = {
        :subject => 'Updated',
        :status => 'pending',
        :labels => label,
        :label_action => label_action
      }.to_json

      access_token.put("#{authentication.site}/api/v2/#{resource}/#{resource_id}", case_hash).code
    else
      raise Desk::AccessTokenError
    end
  end

  def self.post(authentication, resource, name, color)
    access_token = self.build_access_token(authentication)

    if access_token.present?
      label_hash = {
        :name => name,
        :description => 'A Test Label',
        :types => ['case'],
        :color => color.downcase
      }.to_json

      access_token.post("#{authentication.site}/api/v2/#{resource}", label_hash).code
    else
      raise Desk::AccessTokenError
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
