class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.datetime :published_at
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
