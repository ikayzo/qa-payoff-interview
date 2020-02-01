class Debt < ApplicationRecord

  class DebtServiceError < StandardError; end

  DEFAULT_NUM_DAYS_BEFORE_PAYOFF = 30.freeze

  belongs_to :borrower

  validates :borrower, :account_number, :description, :status, presence: true

  def autofill!
    raise DebtServiceError, "Service credentials unspecified" if ENV["SERVICE_CREDENTIALS"].nil?

    # BEGIN HAND-WAVING
    # For the purpose of this examination, assume that the following is making a service call to retrieve these values.

    self.current_balance = Faker::Number.decimal(l_digits: 5, r_digits: 2)
    self.interest_rate =  Faker::Number.decimal(l_digits: 1, r_digits: 3)
    self.current_balance =  Faker::Number.decimal(l_digits: 5, r_digits: 2)
    self.outstanding_interest_amount =  Faker::Number.decimal(l_digits: 4, r_digits: 2)
    self.servicer_address =  Faker::Address.full_address
    self.last_payment_date =  Faker::Date.backward
    self.last_payment_amount =  Faker::Number.decimal(l_digits: 3, r_digits: 2)
    self.last_statement_balance =  Faker::Number.decimal(l_digits: 3, r_digits: 2)
    self.last_statement_issue_date =  Faker::Date.backward
    self.next_payment_due_date =  Faker::Date.forward

    # END HAND-WAVING

    nil
  end

  def payoff_amount(num_days_before_payoff = DEFAULT_NUM_DAYS_BEFORE_PAYOFF)
    raise ArgumentError, "num_days_before_payoff must be an integer" unless num_days_before_payoff.is_a? Integer
    raise ArgumentError, "num_days_before_payoff must be positive" if num_days_before_payoff < 0

    daily_interest_rate = (self.outstanding_interest_amount / 100) / 365
    daily_interest_amount = self.current_balance * daily_interest_rate
    accumulated_interest_before_payoff = daily_interest_amount * num_days_before_payoff

    self.current_balance + accumulated_interest_before_payoff
  end
end
