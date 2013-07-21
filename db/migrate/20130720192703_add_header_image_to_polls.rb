class AddHeaderImageToPolls < ActiveRecord::Migration
  def change
  	add_attachment :polls, :header_image
  end
end
