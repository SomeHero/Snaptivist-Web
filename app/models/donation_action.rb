class DonationAction < Action

  def to_api

    results = {
      'id' => id,
      'type' => 'donation_action',
      'name' => name,
      'count' => get_count
    }

    return results;

  end


end
