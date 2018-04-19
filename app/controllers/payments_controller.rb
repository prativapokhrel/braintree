class PaymentsController < ApplicationController

  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def new 
    @client_token = Braintree::ClientToken.generate
    @payment = Payment.new
  end 

  def show 
    @transaction = Braintree::Transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
  end 

  def create 
    amount = params["payment"]["amount"]
    nonce = params["payment_method_nonce"]

    result = Braintree::Transaction.sale(
      amount: amount,
      merchant_account_id: ENV['MERCHANT_OWNER_ID'],
      payment_method_nonce: nonce,

      :customer => {
        :first_name => payment_params[:first_name],
        :last_name => payment_params[:last_name],
        :phone => payment_params[:phone],
        :email => payment_params[:email]
      },

      :custom_fields => {
        :note => payment_params[:note]
      },

      :options => {
        :submit_for_settlement => true,
        :store_in_vault_on_success => true,
      }
    )

    @payment = Payment.new(payment_params)
    @payment.save

    if result.success? || result.transaction
      @payment.update_attributes(amount: amount)
      flash[:success] = "Your payment was successful. Thank you"

      redirect_to payment_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_payment_path
    end
  end 

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Success!",
        :icon => "success",
        :message => "Your payment was done successfully."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end
  end

  private 

  def payment_params
    params.require(:payment).permit(:amount, :first_name, :last_name, :email, :note, :phone)
  end 
end 