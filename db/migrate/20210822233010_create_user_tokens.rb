class CreateUserTokens < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :user_tokens, id: :uuid do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
