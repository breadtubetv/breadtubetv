class CreateFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :features do |t|
      t.references :channel, null: false, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
