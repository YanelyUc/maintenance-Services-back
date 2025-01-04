module Api
  module V1
    class CarsController < ApplicationController
      before_action :set_car, only: %i[show update destroy]

      # GET /cars
      def index
        @cars = Car.active

        render json: @cars
      end

      # GET /cars/1
      def show
        render json: @car
      end

      # POST /cars
      def create
        @car = Car.new(car_params)

        if @car.save
          render json: @car, status: :created, location: api_v1_car_url(@car)
        else
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /cars/1
      def update
        if @car.update(car_params)
          render json: @car
        else
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      # DELETE /cars/1
      def destroy
        ActiveRecord::Base.transaction do
          @car.active_maintenance_services.map do |maintenance_service|
            maintenance_service.update(active: false)
          end

          if @car.update(active: false)
            render status: :ok
          else
            render json: @car.errors, status: :unprocessable_entity
          end
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_car
        @car = Car.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def car_params
        params.require(:car).permit(:plate_number, :model, :year)
      end
    end
  end
end
