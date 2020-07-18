class CreateChannelSources < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_sources do |t|
      t.references :channel, null: false, foreign_key: true
      t.string :url
      t.string :kind

      t.timestamps
    end
  end
end
