class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
