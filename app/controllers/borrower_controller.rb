class BorrowerController < ApplicationController
  def create
    begin
      borrower_hash = JSON.parse(request.body.read)
    rescue StandardError => e
      render json: { errors: e }, status: :bad_request
      return
    end

    borrower = Borrower.new(borrower_hash)

    if borrower.save
      render json: { borrower: borrower }, status: :ok
    else
      render json: { errors: borrower.errors }, status: :bad_request
    end
  end

  def show
    @borrower = Borrower.find_by(id: params[:id])

    if @borrower
      render json: { borrower: @borrower }, status: :ok
    else
      render json: {}, status: :not_found
    end
  end
end
