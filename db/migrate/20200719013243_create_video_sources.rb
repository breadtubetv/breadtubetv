class CreateVideoSources < ActiveRecord::Migration[6.0]
  def change
    create_table :video_sources do |t|
      t.references :video, null: false, foreign_key: true
      t.string :ident, null: false
      t.string :url, null: false
      t.string :type, null: false

      t.timestamps
    end
  end
end
