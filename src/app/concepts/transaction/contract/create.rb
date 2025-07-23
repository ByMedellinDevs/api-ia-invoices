require 'dry/validation'

module Transaction::Contract
  class Create < Dry::Validation::Contract
    params do
      required(:transaction_date).filled(:date_time)
      required(:sender_account_number).filled(:string)
      required(:receiver_account_number).filled(:string)
      required(:bank).filled(:string)
      required(:reference).filled(:string)
      required(:transaction_amount).filled(:decimal)
    end

    rule(:sender_account_number) do
      key.failure('must be between 8 and 20 characters') if value.length < 8 || value.length > 20
    end

    rule(:receiver_account_number) do
      key.failure('must be between 8 and 20 characters') if value.length < 8 || value.length > 20
    end

    rule(:transaction_amount) do
      key.failure('must be positive') if value <= 0
    end

    rule(:reference) do
      if Transaction.exists?(reference: value)
        key.failure('must be unique')
      end
    end

    rule(:sender_account_number, :receiver_account_number) do
      if values[:sender_account_number] == values[:receiver_account_number]
        key.failure('sender and receiver accounts must be different')
      end
    end
  end
end