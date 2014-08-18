class PremiumAction < Action

	def to_api

    results = {
      'id' => id,
      'type' => 'premium_action',
      'name' => name,
      'count' => get_count
    }

    return results;

  end

end
