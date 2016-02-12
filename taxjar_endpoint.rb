require_relative 'lib/taxjar_integration'

class TaxjarEndpoint < EndpointBase::Sinatra::Base
  set :logging, true
  set :public, 'public'

  post '/add_or_update_order' do
    code, summary = TaxjarIntegration::Order.new(@config, @payload).add_or_update
    result code, summary
  end
end