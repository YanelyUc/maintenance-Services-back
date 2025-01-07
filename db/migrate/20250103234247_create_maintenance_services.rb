class CreateMaintenanceServices < ActiveRecord::Migration[6.1]
  def change
    create_table :maintenance_services do |t|
      t.string :description
      t.references :car, null: false, foreign_key: true
      t.integer :status, default: 0
      t.date :date

      t.timestamps
    end
  end
end
