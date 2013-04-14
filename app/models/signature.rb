class Signature < ActiveRecord::Base
  belongs_to :user
  belongs_to :petition, :counter_cache => true
  attr_accessible :comment

  validates :user, :presence => true
  
     # generate the petition
  def to_api

    results = {
      'signature_id' => id,
      'petition_id' => petition.id,
      'user_id' => user.id,
      'comment' => comment,
      'created_at' => created_at,
      'updated_at' => updated_at
    }

    return results;

  end
  
end

