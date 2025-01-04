class MantenanceServicesController < ApplicationController
  before_action :set_mantenance_service, only: [:show, :update, :destroy]

  # GET /mantenance_services
  def index
    @mantenance_services = MantenanceService.all

    render json: @mantenance_services
  end

  # GET /mantenance_services/1
  def show
    render json: @mantenance_service
  end

  # POST /mantenance_services
  def create
    @mantenance_service = MantenanceService.new(mantenance_service_params)

    if @mantenance_service.save
      render json: @mantenance_service, status: :created, location: @mantenance_service
    else
      render json: @mantenance_service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mantenance_services/1
  def update
    if @mantenance_service.update(mantenance_service_params)
      render json: @mantenance_service
    else
      render json: @mantenance_service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /mantenance_services/1
  def destroy
    @mantenance_service.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mantenance_service
      @mantenance_service = MantenanceService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mantenance_service_params
      params.require(:mantenance_service).permit(:description, :car_id, :status, :date)
    end
end
