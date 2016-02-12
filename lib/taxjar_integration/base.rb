module TaxjarIntegration
  class Base
    attr_accessor :config, :payload

    def initialize(config, payload = {})
      @config = config
      @payload = payload
    end
  end
end