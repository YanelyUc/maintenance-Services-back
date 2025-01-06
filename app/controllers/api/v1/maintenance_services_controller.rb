module Api
  module V1
    class MaintenanceServicesController < ApplicationController
      before_action :set_maintenance_service, only: %i[show update destroy]

      # GET /maintenance_services
      def index
        filter_status = params[:filter_status]

        case filter_status
        when 'deleted'
          @maintenance_services = MaintenanceService.deleted
        when 'both'
          @maintenance_services = MaintenanceService.all
        else
          @maintenance_services = MaintenanceService.active
        end

        render json: { success: true, data: @maintenance_services }, status: :ok
      end

      # GET /maintenance_services/1
      def show
        if @maintenance_service.nil?
          error_response("The maintenance service with id '#{params[:id]}' doesn't exists", :not_found)
        else
          render json: @maintenance_service
        end
      end

      # POST /maintenance_services
      def create
        @maintenance_service = MaintenanceService.new(maintenance_service_params)

        if @maintenance_service.save
          render json: @maintenance_service,
                 status: :created,
                 location: api_v1_maintenance_service_url(@maintenance_service)
        else
          error_response(@maintenance_service.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      # PATCH/PUT /maintenance_services/1
      def update
        if @maintenance_service.nil?
          return error_response("The maintenance service with id '#{params[:id]}' doesn't exists", :not_found)
        end

        if @maintenance_service.update(maintenance_service_params)
          render json: @maintenance_service
        else
          error_response(@maintenance_service.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      # DELETE /maintenance_services/1
      def destroy
        if @maintenance_service.nil?
          return error_response("The maintenance service with id '#{params[:id]}' doesn't exists", :not_found)
        end

        if @maintenance_service.update(active: false)
          render status: :ok
        else
          error_response(@maintenance_service.errors, :unprocessable_entity)
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_maintenance_service
        @maintenance_service = MaintenanceService.find_by(id: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def maintenance_service_params
        params.permit(:description, :car_id, :status, :date, :filter_status)
      end
    end
  end
end
