	class UpdateTargetStateInformation < ActiveRecord::Migration
  def up
  	StateInformation.all.each do |state|
  		say "#{state.short_code}"
  		Target.update_all("state_information_id = " + state.id.to_s, "state = '" + state.short_code + "'")
	end
  end

  def down
  		Target.update_all("state_information_id = null")
  end
end
