class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string  :group_name,   null: false
      t.text    :introduction, null: false
      t.integer :owner_id,     null: false
      t.references :user,      foreign_key: true

      t.timestamps
    end
  end
end
