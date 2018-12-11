# To run all your remaining migrations, do:
# rails db:migrate

# To generate a model, do:
# rails g model <model-name> <...column-names>

# Find the official guide to migrations at:
# https://edgeguides.rubyonrails.org/active_record_migrations.html

class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      # Automatically generates an "id" column that
      # auto-increments and acts as our primary key
      t.string :title # This creates a VARCHAR(255) column named "title"
      t.text :body # This creates a TEXT column named "body"

      t.timestamps
      # This will create two columns "created_at"  and "updated_at"
      # which will auto-update.
    end
  end
end
