require "spec_helper"

module TaxjarIntegration
  describe Order do
    let(:payload) { {order: Factories.order}.with_indifferent_access }
    let(:config) { Factories.config.with_indifferent_access }
    subject { TaxjarIntegration::Order.new(config, payload) }

    context "add_or_update_order" do
      context "when transaction isn't present" do
        it "creates a new order transaction" do
          VCR.use_cassette("order/create") do
            status, message = subject.add_or_update
            expect(status).to eq(200)
            expect(message).to match("Created order transaction")
          end
        end
      end

      context "when transaction is present" do
        it "updates the exisintg order transaction" do
          VCR.use_cassette("order/update") do
            status, message = subject.add_or_update
            expect(status).to eq(200)
            expect(message).to match("Updated order transaction")
          end
        end
      end
    end
  end
end