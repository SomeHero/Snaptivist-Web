class PremiumOffer < ActiveRecord::Base
  attr_accessible :call_to_action_button_text, :headline_text, :name

  # generate the premium offer json
  def to_api

    results = {
      'premium_offer_id' => id,
      'name' => name,
      'headline_text' => headline_text,
      'call_to_action_button_text' => call_to_action_button_text
    }

    return results;

  end
  
end
