class PetitionAction < Action
  # attr_accessible :title, :body

  def to_api

    results = {
      'id' => id,
      'type' => 'Petition',
      'name' => name,
      'count' => get_count
    }

    return results;

  end

end
