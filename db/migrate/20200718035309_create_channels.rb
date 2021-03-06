class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :image
      t.text :tags, array: true, default: []

      t.timestamps
    end
    add_index :channels, :slug, unique: true
  end
end
