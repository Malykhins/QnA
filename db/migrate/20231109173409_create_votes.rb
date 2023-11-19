class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :value, default: 0, null: false

      t.timestamps
    end
  end
end
