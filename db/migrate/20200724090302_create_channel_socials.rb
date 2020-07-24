class CreateChannelSocials < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_socials do |t|
      t.references :channel, null: false, foreign_key: true
      t.string :url
      t.string :ident
      t.string :type, null: false

      t.timestamps
    end
  end
end
