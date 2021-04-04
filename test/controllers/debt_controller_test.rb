require 'test_helper'

class DebtControllerTest < ActionDispatch::IntegrationTest
  test "index with invalid borrower" do
    get borrower_debt_index_url(borrower_id: borrowers.last.id + 1), as: :json

    assert_response :not_found
  end

  test "index with valid borrowers" do
    borrowers.each do |borrower|
      get borrower_debt_index_url(borrower_id: borrower.id), as: :json

      assert_response :success
      assert_equal borrower.debts.as_json, JSON.parse(@response.body)["debts"]
    end
  end

  test "cannot create with invalid borrower" do
    post borrower_debt_index_url(borrower_id: borrowers.last.id + 1), as: :json
    assert_response :not_found
  end

  test "cannot create with invalid debt" do
    post borrower_debt_index_url(borrower_id: borrowers.last.id), params: Debt.new, as: :json
    assert_response :bad_request
  end

  test "cannot create with missing attribute" do
    debt = debts.last.dup
    debt.status = nil

    post borrower_debt_index_url(borrower_id: debt.borrower.id), params: debt, as: :json
    assert_response :bad_request
    assert_match "status", response.body
  end

  test "create with valid attributes" do
    debt = debts.last.dup

    post borrower_debt_index_url(borrower_id: debt.borrower.id), params: debt, as: :json
    assert_response :ok
  end

  test "cannot show with invalid borrower" do
    get borrower_debt_url(borrower_id: borrowers.last.id + 1, id: debts.last.id), as: :json
    assert_response :not_found
  end

  test "show" do
    debt = debts.last

    get borrower_debt_url(borrower_id: debt.borrower.id, id: debt.id), as: :json
    assert_response :ok
    assert_equal debt.as_json, JSON.parse(@response.body)["debt"]
  end

  test "autofill" do
    if ENV["SERVICE_CREDENTIALS"].nil?
      skip("Service credentials not set. Skipping")
    end

    debt = debts.last

    put borrower_debt_autofill_url(borrower_id: debt.borrower.id, debt_id: debt.id), as: :json
    assert_response :ok
  end

  test "payoff_amount" do
    debt = debts.last

    get borrower_debt_payoff_amount_url(borrower_id: debt.borrower.id, debt_id: debt.id), as: :json

    assert_response :ok
    assert_equal debt.payoff_amount.as_json, JSON.parse(@response.body)["payoff_amount"]
  end
end
