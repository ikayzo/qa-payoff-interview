class Debt < ApplicationRecord
  belongs_to :borrower

  validates :borrower, :account_number, :description, :status, presence: true 
end
