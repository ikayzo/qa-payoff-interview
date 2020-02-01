class DebtController < ApplicationController
  before_action :load_borrower
  before_action :load_debt, except: [:index, :create]

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
    render json: { debt: @debt }, status: :ok
  end

  def autofill
    begin
      @debt.autofill!
      render json: { debt: @debt }, status: :ok
    rescue Debt::DebtServiceError => e
      render json: { errors: e }, status: :service_unavailable
    end
  end

  def payoff_amount
    num_days_before_payoff = params[:num_days_before_payoff] || Debt::DEFAULT_NUM_DAYS_BEFORE_PAYOFF

    begin
      render json: { payoff_amount: @debt.payoff_amount(num_days_before_payoff) }, status: :ok
    rescue ArgumentError => e
      render json: { errors: e }, status: :internal_server_error
    end
  end

  private

  def load_borrower
    @borrower = Borrower.find_by(id: params[:borrower_id])

    if @borrower.nil?
      render json: {error: "Borrower not found" }, status: :not_found
    end
  end

  def load_debt
    @debt = @borrower.debts.find_by(id: params[:debt_id] || params[:id])

    if @debt.nil?
      render json: {error: "Debt not found" }, status: :not_found
    end
  end
end
