class CreateSignatureActions < ActiveRecord::Migration
  def change
    create_table :signature_actions do |t|

      t.timestamps
    end
  end
end
