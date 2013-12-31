object false

node :results do 
	partial('tweet', :object => @signatures)
end

node :total	do
	@total
end