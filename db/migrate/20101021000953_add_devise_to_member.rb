class AddDeviseToMember < ActiveRecord::Migration
  def self.up
    change_table :members do |t|
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.rename :password_hash, :encrypted_password
      t.rename :salt, :password_salt
    end

    add_index :members, :email,                :unique => true
    add_index :members, :confirmation_token,   :unique => true
    add_index :members, :reset_password_token, :unique => true
  end

  def self.down
    change_table :members do |t|
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :reset_password_token
      t.remove :remember_token
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
      t.rename :encrypted_password, :password_hash
      t.rename :password_salt, :salt
    end

    remove_index :members, :email
    remove_index :members, :confirmation_token
    remove_index :members, :reset_password_token
  end
end
