object false

node :results do 
	partial('share', :object => @shares)
end

node :total	do
	@total
end