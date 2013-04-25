class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :short_url
      t.string :full_url
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
