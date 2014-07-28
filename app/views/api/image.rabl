object @image
attributes :id, 
  :created_at
  :updated_at
  node :sizes do |i| 
    i.get_sizes()
  end
