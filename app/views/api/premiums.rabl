object false

node :results do 
	partial('premium', :object => @premiums)
end

node :total	do
	@total
end