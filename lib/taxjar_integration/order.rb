module TaxjarIntegration
  class Order < Base

    def add_or_update
      begin
        order = order_service.show
      rescue Taxjar::Error::NotFound => e
        add
      rescue Taxjar::Error => e
        [500, e.message]
      else
        update
      end
    end

    protected

    def add
      begin
        order = order_service.create
        [200, "Created order transaction #{order.transaction_id}"]
      rescue Taxjar::Error => e
        [500, e.message]
      end
    end

    def update
      begin
        order = order_service.update
        [200, "Updated order transaction #{order.transaction_id}"]
      rescue Taxjar::Error => e
        [500, e.message]
      end
    end

    private

    def order_service
      @order_service ||= Service::Transaction::Order.new(config, payload)
    end
  end
end