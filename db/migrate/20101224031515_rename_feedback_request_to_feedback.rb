class RenameFeedbackRequestToFeedback < ActiveRecord::Migration
  def self.up
    drop_table :feedback_requests
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :email
      t.string :category
      t.string :subject
      t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
    create_table :feedback_requests do |t|
      t.integer :user_id
      t.string :email
      t.string :category
      t.string :status
      t.string :subject
      t.text :message
      t.timestamps
    end
  end
end
