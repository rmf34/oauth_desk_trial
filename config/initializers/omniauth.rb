module OmniAuth
  class Builder < ::Rack::Builder
    def provider_patch(klass, *args, &block)
      @@providers ||= []
      @@providers << klass
      old_provider(klass, *args, &block)
    end
    alias old_provider provider
    alias provider provider_patch
    class << self
      def providers
        @@providers
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :desk, ENV['DESK_KEY'], ENV['DESK_SECRET'], :site => 'https://rmf34.desk.com'
end
