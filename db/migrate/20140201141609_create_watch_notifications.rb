class CreateWatchNotifications < ActiveRecord::Migration
  def change
    create_table :watch_notifications do |t|
      t.references :user
      t.references :proposal

      t.timestamps
    end
  end
end
