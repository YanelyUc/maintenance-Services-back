class AddActiveToCars < ActiveRecord::Migration[6.1]
  def change
    add_column :cars, :active, :boolean, default: true
  end
end
