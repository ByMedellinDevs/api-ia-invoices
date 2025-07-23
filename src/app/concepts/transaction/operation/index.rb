module Transaction::Operation
  class Index < Trailblazer::Operation
    step :set_defaults
    step :apply_filters
    step :apply_pagination
    step :serialize_data

    private

    def set_defaults(ctx, params:, **)
      ctx[:page] = params[:page]&.to_i || 1
      ctx[:per_page] = params[:per_page]&.to_i || 10
      ctx[:per_page] = 100 if ctx[:per_page] > 100 # Limit max per_page
      true
    end

    def apply_filters(ctx, params:, **)
      transactions = Transaction.all

      # Filter by date range
      if params[:start_date].present? && params[:end_date].present?
        transactions = transactions.where(transaction_date: params[:start_date]..params[:end_date])
      end

      # Filter by bank
      transactions = transactions.where(bank: params[:bank]) if params[:bank].present?

      # Filter by sender account
      transactions = transactions.where(sender_account_number: params[:sender_account]) if params[:sender_account].present?

      # Filter by receiver account
      transactions = transactions.where(receiver_account_number: params[:receiver_account]) if params[:receiver_account].present?

      ctx[:filtered_transactions] = transactions
      true
    end

    def apply_pagination(ctx, **)
      transactions = ctx[:filtered_transactions]
      offset = (ctx[:page] - 1) * ctx[:per_page]
      
      ctx[:transactions] = transactions.limit(ctx[:per_page]).offset(offset)
      ctx[:total_count] = transactions.count
      true
    end

    def serialize_data(ctx, **)
      ctx[:serialized_data] = TransactionSerializer.new(ctx[:transactions]).serializable_hash
      true
    end
  end
end