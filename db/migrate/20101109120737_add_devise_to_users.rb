class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :email
      t.database_authenticatable
      t.recoverable
      t.rememberable
      t.trackable
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :encrypted_password
      t.remove :password_salt
      t.remove :reset_password_token
      t.remove :remember_token
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
    end
  end
end
