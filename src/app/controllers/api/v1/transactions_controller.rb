module Api
  module Api::V1
  class TransactionsController < ApplicationController
    before_action :doorkeeper_authorize!

    def index
      result = Transaction::Operation::Index.call(params: params.to_unsafe_h)
      
      if result.success?
        render json: result[:serialized_data], status: :ok
      else
        render json: { errors: result[:errors] }, status: :unprocessable_entity
      end
    end

    def show
      result = Transaction::Operation::Show.call(params: params.to_unsafe_h)
      
      if result.success?
        render json: result[:serialized_data], status: :ok
      else
        render json: { errors: result[:errors] }, status: :not_found
      end
    end

    def create
      result = Transaction::Operation::Create.call(params: transaction_params)
      
      if result.success?
        render json: result[:serialized_data], status: :created
      else
        render json: { errors: result[:errors] }, status: :unprocessable_entity
      end
    end

    private

    def transaction_params
      params.require(:transaction).permit(
        :transaction_date, :sender_account_number, :receiver_account_number,
        :bank, :reference, :transaction_amount
      )
    end
  end
end
end