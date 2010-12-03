class AddHasTemplateToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :has_template, :boolean
  end

  def self.down
    remove_column :pages, :has_template
  end
end
