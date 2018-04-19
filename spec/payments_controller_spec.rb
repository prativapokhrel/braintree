require 'rails_helper'
require 'support/mock_data'

Rspec.describe PaymentsController, type: :controller do 
  include_context 'mock_data'

  describe "GET #new" do
    it "returns http success" do
      expect(Braintree::ClientToken).to receive(:generate).and_return("your_client_token")
      get :new
      expect(response).to have_http_status(:success)
    end

    it "adds the Braintree client token to the page" do
      expect(Braintree::ClientToken).to receive(:generate).and_return("your_client_token")
      get :new
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "returns http success" do
      amount = "10.00"
      nonce = "fake-valid-nonce"

      expect(Braintree::Transaction).to receive(:sale).with(
        amount: amount,
        merchant_account_id: nil,
        payment_method_nonce: nonce,
        :customer => {
          :first_name => "test",
          :last_name => "test",
          :phone => nil,
          :email => nil,
        },

        :custom_fields => {
          :note => "testing"
        },

        :options => {
          :submit_for_settlement => true,
          :store_in_vault_on_success => true
        }
      ).and_return(
        Braintree::SuccessfulResult.new(transaction: mock_transaction)
      )

      post :create, params: { payment_method_nonce: nonce, payment: { amount: amount, first_name: "test", last_name: "test", note: "testing" }, merchant_account_id: nil }

      expect(response).to redirect_to(payment_path(mock_transaction.id))
    end
  end 
end 