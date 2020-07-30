class AddDiscardedAtToChannels < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :discarded_at, :datetime
    add_index :channels, :discarded_at
  end
end
