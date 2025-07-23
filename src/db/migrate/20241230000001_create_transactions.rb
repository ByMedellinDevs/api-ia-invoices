class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.datetime :transaction_date, null: false
      t.string :sender_account_number, null: false, limit: 20
      t.string :receiver_account_number, null: false, limit: 20
      t.string :bank, null: false
      t.string :reference, null: false
      t.decimal :transaction_amount, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_index :transactions, :reference, unique: true
    add_index :transactions, :transaction_date
    add_index :transactions, :sender_account_number
    add_index :transactions, :receiver_account_number
    add_index :transactions, :bank
  end
end