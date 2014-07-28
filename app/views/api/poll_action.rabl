object @poll
attributes :id, 
  :name, 
  :type,
  :created_at,
  :updated_at

child :poll_choices do
	attributes :id,
		:label,
		:position
	node do |c| {
		:vote_count => c.get_count
	}
	end
	node do |c| {
		:percentage => c.get_percentage*100
	}
	end
end