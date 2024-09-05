class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.boolean :read, default: false, null: false # 通知機能のための追記

      t.timestamps
    end
  end
end