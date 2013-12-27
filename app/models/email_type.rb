class EmailType < ActiveRecord::Base
  attr_accessible :default_subject, :default_email_template, :description, :name, :default_state, :position


  # generate json
  def to_api

    results = {
      'email_type_id' => id,
      'name' => name,
      'description' => description
    }

    return results;
  end
end
