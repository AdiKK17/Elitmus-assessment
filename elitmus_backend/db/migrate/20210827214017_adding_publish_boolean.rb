class AddingPublishBoolean < ActiveRecord::Migration[6.1]
  def change
    add_column :advertisements, :publish, :boolean, :default => false
  end
end
