class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: {unique: true}
      # Add an index to columns that query
      # often. It'll improve the performance of the
      # query, especially as your app grows in size.
      # An index achieves this by creating an ordered
      # list (technically a binary tree) tree gives the
      # database a faster a way to search for certain values
      
      t.string :password_digest

      t.timestamps
    end
  end
end
