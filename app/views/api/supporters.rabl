object false

node :results do 
	partial('supporter', :object => @supporters)
end

node :total	do
	@total
end