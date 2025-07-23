module Transaction::Operation
  class Show < Trailblazer::Operation
    step :find_transaction
    step :serialize_data

    private

    def find_transaction(ctx, params:, **)
      transaction = Transaction.find_by(id: params[:id])
      
      if transaction
        ctx[:model] = transaction
        true
      else
        ctx[:errors] = { transaction: ["not found"] }
        false
      end
    end

    def serialize_data(ctx, model:, **)
      ctx[:serialized_data] = TransactionSerializer.new(model).serializable_hash
      true
    end
  end
end