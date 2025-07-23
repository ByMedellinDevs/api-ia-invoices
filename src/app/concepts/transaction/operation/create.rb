module Transaction::Operation
  class Create < Trailblazer::Operation
    step :validate_contract
    step :create_transaction
    step :serialize_data

    private

    def validate_contract(ctx, params:, **)
      contract = Transaction::Contract::Create.new
      result = contract.call(params)
      
      if result.success?
        ctx[:validated_params] = result.to_h
        true
      else
        ctx[:errors] = result.errors.to_h
        false
      end
    end

    def create_transaction(ctx, validated_params:, **)
      transaction = Transaction.new(validated_params)
      
      if transaction.save
        ctx[:model] = transaction
        true
      else
        ctx[:errors] = transaction.errors.as_json
        false
      end
    end

    def serialize_data(ctx, model:, **)
      ctx[:serialized_data] = TransactionSerializer.new(model).serializable_hash
      true
    end
  end
end