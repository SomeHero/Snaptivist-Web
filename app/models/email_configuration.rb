class EmailConfiguration < ActiveRecord::Base
  belongs_to :email_type
  belongs_to :campaign
  #attr_accessible :email_type_id, :campaign, :email_type, :email_template, :from_address, :from_name, :enabled, :last_id_sent, :subject

  # generate json
  def to_api

    results = {
      'email_configuration_id' => id,
      'email_type' => email_type.to_api,
      'email_template' => email_template,
      'from_address' => from_address,
      'from_name' => from_name,
      'subject' => subject
    }


    return results;
  end

end
