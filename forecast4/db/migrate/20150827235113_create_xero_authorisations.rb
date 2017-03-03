class CreateXeroAuthorisations < ActiveRecord::Migration
  def change
    create_table :xero_authorisations do |t|
      t.string :request_token
      t.string :request_secret
      t.string :access_token
      t.string :access_key
      t.string :oauth_verifier
      t.string :host
      t.datetime :access_token_updated_at
      t.references :seller

      t.timestamps null: false
    end
  end
end
