class DebtController < ApplicationController
  before_action :load_borrower

  def index
    render json: { debts: @borrower.debts }, status: :ok
  end

  def create
    begin
      debt_hash = JSON.parse(request.body.read)
    rescue StandardError => e
      render json: { errors: e }, status: :bad_request
      return
    end

    debt = Debt.new(debt_hash)
    debt.borrower = @borrower

    if debt.save
      render json: { debt: debt }, status: :ok
    else
      render json: { errors: debt.errors }, status: :bad_request
    end
  end

  def show
    @debt = @borrower.debts.find_by(id: params[:id])

    if @debt
      render json: { debt: @debt }, status: :ok
    else
      render json: { error: "Debt not found" }, status: :not_found
    end
  end

  private

  def load_borrower
    @borrower = Borrower.find_by(id: params[:borrower_id])

    if @borrower.nil?
      render json: {error: "Borrower not found" }, status: :not_found
    end
  end
end
