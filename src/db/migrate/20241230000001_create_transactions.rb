class CreateMonetaryTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :monetary_transactions do |t|
      t.datetime :transaction_date, null: false
      t.string :sender_account_number, null: false, limit: 20
      t.string :receiver_account_number, null: false, limit: 20
      t.string :bank, null: false
      t.string :reference, null: false
      t.decimal :transaction_amount, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_index :monetary_transactions, :reference, unique: true
    add_index :monetary_transactions, :transaction_date
    add_index :monetary_transactions, :sender_account_number
    add_index :monetary_transactions, :receiver_account_number
    add_index :monetary_transactions, :bank
  end
end