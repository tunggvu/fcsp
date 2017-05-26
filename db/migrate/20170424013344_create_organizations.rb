class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.integer :org_type, default: 1
      t.string :name

      t.timestamps
    end

    add_index :organizations, :name
  end
end
