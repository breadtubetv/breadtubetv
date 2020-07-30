class AddDiscardedAtToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :discarded_at, :datetime
    add_index :videos, :discarded_at
  end
end
