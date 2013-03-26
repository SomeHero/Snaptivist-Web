module HasRetrievalKey
  module HasMethods
    def has_retrieval_key(options = {}, solr_options = {})
      include InstanceMethods
      extend ClassMethods
      
      # note: cannot use before_save here, as we need to allow other before_create and before_update actions to take place before
      # set_indexing_flag.  Note that before_save actions take place before before_create and before_update actions.
      before_create :set_retrieval_key
    end
  end
  
  module InstanceMethods
    KEY_POOL_SIZE = 1000000000

    # set the retrieval key for this
    def set_retrieval_key
      base = rand(KEY_POOL_SIZE)
      first_digit = (base / (KEY_POOL_SIZE / 10)).to_i
      remainder = base % (KEY_POOL_SIZE / 10)

      self.retrieval_key = first_digit.to_s + rand(1000000000).to_s(36)
      if self.class.find_by_retrieval_key(retrieval_key)
        # that one is already used - go get another
        set_retrieval_key
      end
    end
  end
  
  module ClassMethods
  end
end


# reopen ActiveRecord and include the has_retrieval_key method
ActiveRecord::Base.extend HasRetrievalKey::HasMethods