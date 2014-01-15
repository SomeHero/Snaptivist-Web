object false

node :total	do
	@total
end

node :results do |s|
	partial('signature', :object => @signatures)
end