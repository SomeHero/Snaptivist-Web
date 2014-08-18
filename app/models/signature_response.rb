class SignatureResponse < ActionResponse


  def to_api

    results = {
      'id' => id,
      'type' => 'signature_action',
      'user' => user
    }

    return results;

  end

end
