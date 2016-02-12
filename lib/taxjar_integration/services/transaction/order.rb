module TaxjarIntegration
  module Service
    module Transaction
      class Order < Base

        def show
          taxjar.show_order order_number
        end

        def create
          taxjar.create_order order_params
        end

        def update
          taxjar.update_order order_params
        end

        def delete
          taxjar.delete_order order_number
        end

        private

        def order
          payload[:order]
        end

        def order_number
          order[:number] || order[:id]
        end

        def order_params
          order_params = {
              transaction_id: order_number,
              transaction_date: order[:placed_on]
          }

          # Either an address on file or from_ parameters are
          # required to perform tax calculations.
          order_params[:from_state] = config[:from_state] if config[:from_state]
          order_params[:from_city] = config[:from_city] if config[:from_city]
          order_params[:from_street] = config[:from_street] if config[:from_street]
          order_params[:from_country] = config[:from_country] if config[:from_country]
          order_params[:from_zip] = config[:from_zip] if config[:from_zip]

          order_params[:to_country] = order['shipping_address']['country']
          order_params[:to_state] = order['shipping_address']['state']
          order_params[:to_city] = order['shipping_address']['city']
          order_params[:to_street] = order['shipping_address']['address1']
          order_params[:to_zip] = order['shipping_address']['zipcode']

          order_params[:amount] = order['totals']['order']
          order_params[:shipping] = order['totals']['shipping']
          order_params[:sales_tax] = order['totals']['tax']

          unless false && config[:send_line_items]
            order_params[:line_items] = order['line_items'].map do |line_item|
              {
                  id: line_item['id'],
                  quantity: line_item['quantity'],
                  production_indetifier: line_item['sku'],
                  product_tax_code: line_item['tax_code'],
                  description: line_item['name'],
                  unit_price: line_item['price'],
                  discount: line_item['discount'],
                  sales_tax: line_item['sales_tax']
              }
            end
          end

          order_params
        end
      end
    end
  end
end