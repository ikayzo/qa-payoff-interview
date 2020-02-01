require 'test_helper'

class BorrowerTest < ActiveSupport::TestCase
  test "invalid without name" do
    assert_not Borrower.new.valid?
  end

  test "valid with name" do
    assert Borrower.new(name: Faker::Name.name).valid?
  end
  
  test "debts match" do
    borrowers.each do |borrower|
      test_borrower = Borrower.find_by(id: borrower.id)
      assert_not test_borrower.nil?

      assert_equal test_borrower.debts, borrower.debts
    end
  end
end
