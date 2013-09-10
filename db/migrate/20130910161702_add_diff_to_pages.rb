class AddDiffToPages < ActiveRecord::Migration
  def change
    add_column :pages, :difference, :integer
  end
end
