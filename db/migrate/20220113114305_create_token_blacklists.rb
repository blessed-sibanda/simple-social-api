class CreateTokenBlacklists < ActiveRecord::Migration[7.0]
  def change
    create_table :token_blacklists do |t|
      t.string :token

      t.timestamps
    end
    add_index :token_blacklists, :token
  end
end
