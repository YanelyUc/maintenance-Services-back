module Api
  module V1
    class CarsController < ApplicationController
      before_action :set_car, only: %i[show update destroy]

      # GET /cars
      def index
        filter_status = params[:filter_status]

        case filter_status
        when 'deleted'
          @cars = Car.deleted
        when 'both'
          @cars = Car.all
        else
          @cars = Car.active
        end

        render json: { success: true, data: @cars }, status: :ok
      end

      # GET /cars/1
      def show
        if @car.nil?
          error_response("The car with id '#{params[:id]}' doesn't exists", :not_found)
        else
          render json: @car
        end
      end

      # POST /cars
      def create
        @car = Car.new(car_params)

        if @car.save
          render json: @car, status: :created, location: api_v1_car_url(@car)
        else
          error_response(@car.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      # PATCH/PUT /cars/1
      def update
        return error_response("The car with id '#{params[:id]}' doesn't exists", :not_found) if @car.nil?

        if @car.update(car_params)
          render json: @car
        else
          error_response(@car.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      # DELETE /cars/1
      def destroy
        return error_response("The car with id '#{params[:id]}' doesn't exists", :not_found) if @car.nil?

        ActiveRecord::Base.transaction do
          @car.active_maintenance_services.map do |maintenance_service|
            maintenance_service.update(active: false)
          end

          if @car.update(active: false)
            render status: :ok
          else
            error_response(@car.errors, :unprocessable_entity)
          end
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_car
        @car = Car.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def car_params
        params.permit(:plate_number, :model, :year, :filter_status)
      end
    end
  end
end
