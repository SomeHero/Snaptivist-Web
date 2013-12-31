object false

node :results do 
	partial('signature', :object => @signatures)
end

node :total	do
	@total
end