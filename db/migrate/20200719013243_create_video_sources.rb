class CreateVideoSources < ActiveRecord::Migration[6.0]
  def change
    create_table :video_sources do |t|
      t.references :video, null: false, foreign_key: true
      t.string :ident, null: false
      t.string :url, null: false
      t.string :type, null: false
      t.integer :view_count
      t.integer :like_count
      t.integer :dislike_count
      t.integer :favorite_count
      t.integer :comment_count
      t.integer :duration
      t.string :length
      t.integer :scheduled
      t.datetime :scheduled_at
      t.text :tags, array: true, default: []

      t.timestamps
    end
  end
end
