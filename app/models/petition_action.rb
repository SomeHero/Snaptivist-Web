class PetitionAction < Action
  # attr_accessible :title, :body

  def to_api

    results = {
      'id' => id,
      'type' => 'signature_action',
      'name' => name,
      'count' => get_count
    }

    return results;

  end

end
