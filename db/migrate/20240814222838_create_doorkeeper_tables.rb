# frozen_string_literal: true

class CreateDoorkeeperTables < ActiveRecord::Migration[7.1]
  def change
    create_table :oauth_access_tokens do |t|
      t.references :resource_owner, index: true

      # Remove `null: false` if you are planning to use Password
      # Credentials Grant flow that doesn't require an application.
      t.integer :application_id

      # If you use a custom token generator you may need to change this column
      # from string to text, so that it accepts tokens larger than 255
      # characters. More info on custom token generators in:
      # https://github.com/doorkeeper-gem/doorkeeper/tree/v3.0.0.rc1#custom-access-token-generator
      #
      # t.text :token, null: false
      t.string :token, null: false

      t.string   :refresh_token
      t.integer  :expires_in
      t.datetime :revoked_at
      t.datetime :created_at, null: false
      t.string   :scopes

      # The authorization server MAY issue a new refresh token, in which case
      # *the client MUST discard the old refresh token* and replace it with the
      # new refresh token. The authorization server MAY revoke the old
      # refresh token after issuing a new refresh token to the client.
      # @see https://tools.ietf.org/html/rfc6749#section-6
      #
      # Doorkeeper implementation: if there is a `previous_refresh_token` column,
      # refresh tokens will be revoked after a related access token is used.
      # If there is no `previous_refresh_token` column, previous tokens are
      # revoked as soon as a new access token is created.
      #
      # Comment out this line if you want refresh tokens to be instantly
      # revoked after use.
      # t.string   :previous_refresh_token, null: false, default: ""
    end

    add_index :oauth_access_tokens, :token, unique: true
    add_index :oauth_access_tokens, :refresh_token, unique: true

    # Uncomment below to ensure a valid reference to the resource owner's table
    # add_foreign_key :oauth_access_grants, <model>, column: :resource_owner_id
    # add_foreign_key :oauth_access_tokens, <model>, column: :resource_owner_id
  end
end
