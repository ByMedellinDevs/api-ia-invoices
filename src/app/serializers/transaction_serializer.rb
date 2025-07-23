class TransactionSerializer
  include JSONAPI::Serializer
  
  set_type :transaction
  
  attributes :transaction_date, :sender_account_number, :receiver_account_number, 
             :bank, :reference, :transaction_amount, :created_at, :updated_at
end