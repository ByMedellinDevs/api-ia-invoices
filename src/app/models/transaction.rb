class Transaction < ApplicationRecord
  validates :transaction_date, presence: true
  validates :sender_account_number, presence: true, length: { in: 8..20 }
  validates :receiver_account_number, presence: true, length: { in: 8..20 }
  validates :bank, presence: true
  validates :reference, presence: true, uniqueness: true
  validates :transaction_amount, presence: true, numericality: { greater_than: 0 }

  validate :different_accounts

  private

  def different_accounts
    if sender_account_number == receiver_account_number
      errors.add(:receiver_account_number, "must be different from sender account")
    end
  end
end