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
end
