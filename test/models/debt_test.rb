require 'test_helper'

class DebtTest < ActiveSupport::TestCase
  test "invalid without borrower" do
    debt = debts(:miles_student)
    debt.borrower = nil

    assert_not debt.valid?
    assert_not debt.save
    assert_includes debt.errors.messages.keys, :borrower
  end

  test "presence validators" do
    [:account_number, :description, :status].each do |attribute|
      debt = debts(:miles_student)
      debt.update_attribute(attribute, nil)

      assert_not debt.valid?
      assert_not debt.save
      assert_includes debt.errors.messages.keys, attribute
    end
  end

  test "autofill!" do
    if ENV["SERVICE_CREDENTIALS"].nil?
      skip("Service credentials not set. Skipping")
    end

    debt = Debt.new(
      account_number: Faker::Number.number(digits: 10),
      description: Faker::Lorem.sentence,
      status: "Open"
    )
    debt.borrower = Borrower.find(borrowers.first.id)
    debt.autofill!

    assert debt.valid?
    assert debt.save
  end

  test "payoff_amount" do
    debt = debts.first

    (0..90).each do |num_days_before_payoff|
      daily_interest_rate = (debt.outstanding_interest_amount / 100) / 365
      daily_interest_amount = debt.current_balance * daily_interest_rate
      accumulated_interest_before_payoff = daily_interest_amount * num_days_before_payoff

      assert_equal(
        (debt.current_balance + accumulated_interest_before_payoff),
        debt.payoff_amount(num_days_before_payoff)
      )
    end
  end

  test "payoff_amount defaults to #{Debt::DEFAULT_NUM_DAYS_BEFORE_PAYOFF} days" do
    debt = debts.first

    daily_interest_rate = (debt.outstanding_interest_amount / 100) / 365
    daily_interest_amount = debt.current_balance * daily_interest_rate
    accumulated_interest_before_payoff = daily_interest_amount * Debt::DEFAULT_NUM_DAYS_BEFORE_PAYOFF

    assert_equal (debt.current_balance + accumulated_interest_before_payoff), debt.payoff_amount
  end

  test "payoff_amount throws error with negative parameter" do
    assert_raises(ArgumentError) { debts.first.payoff_amount(-1) }
  end

  test "payoff_amount throws error with nil" do
    assert_raises(ArgumentError) { debts.first.payoff_amount(nil) }
  end
end
