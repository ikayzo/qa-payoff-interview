require 'test_helper'

class BorrowerControllerTest < ActionDispatch::IntegrationTest
  test "can create borrower with name" do
    post "/borrower", params: { name: Faker::Name.name }, as: :json

    assert_response :success
  end

  test "cannot create borrower without name" do
    post "/borrower", params: { }, as: :json

    assert_response :bad_request
  end

  test "cannot create borrower malformed parameters" do
    post "/borrower", params: "{ name: }", as: :text

    assert_response :bad_request
  end

  test "can show borrowers with matching IDs" do
    borrowers.each do |borrower|
      get borrower_url(id: borrower.id), as: :json

      assert_response :success
      assert_equal borrower.name, JSON.parse(@response.body)["borrower"]["name"]
    end
  end

  test "404 for non-matching borrower ID" do
    get borrower_url(id: borrowers.last.id + 1), as: :json
    assert_response :not_found
  end
end
