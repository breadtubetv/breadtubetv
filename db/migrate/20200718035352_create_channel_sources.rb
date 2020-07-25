class CreateChannelSources < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_sources do |t|
      t.references :channel, null: false, foreign_key: true
      t.string :ident, null: false
      t.string :url, null: false
      t.string :type, null: false
      t.timestamp :synced_at

      t.timestamps
    end
  end
end
