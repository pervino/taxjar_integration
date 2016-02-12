module TaxjarIntegration
  module Service
    class Base
      attr_reader :taxjar, :config, :payload

      def initialize(config, payload)
        @config = config
        @payload = payload
        @taxjar = create_service
      end

      private

      def create_service
        Taxjar::Client.new(api_key: config.fetch(:taxjar_api_key))
      end
    end
  end
end