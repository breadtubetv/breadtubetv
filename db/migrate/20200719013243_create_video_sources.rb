class CreateVideoSources < ActiveRecord::Migration[6.0]
  def change
    create_table :video_sources do |t|
      t.references :video, null: false, foreign_key: true
      t.string :url
      t.string :kind

      t.timestamps
    end
  end
end
