class CreateDebts < ActiveRecord::Migration[6.0]
  def change
    create_table :debts do |t|
      t.integer    "borrower_id",                null: false
      t.string     "account_number"
      t.string     "description"
      t.string     "status"
      t.decimal    "interest_rate"
      t.decimal    "current_balance"
      t.decimal    "outstanding_interest_amount"
      t.string     "servicer_address"
      t.date       "last_payment_date"
      t.decimal    "last_payment_amount"
      t.decimal    "last_statement_balance"
      t.date       "last_statement_issue_date"
      t.date       "next_payment_due_date"
      t.timestamps
    end
  end
end
