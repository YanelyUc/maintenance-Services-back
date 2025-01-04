class AddActiveToMaintenanceServices < ActiveRecord::Migration[6.1]
  def change
    add_column :maintenance_services, :active, :boolean, default: true
  end
end
