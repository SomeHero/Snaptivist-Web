class PermittedParams < Struct.new(:params)
  # example not used anywhere, delete once better example exists
  def topic
    params.require(:topic).permit(*topic_attributes)
  end

  def poll_action
    params.require(:name).permit(*poll_choices_attributes)
  end

  def poll_choices_attributes
    [:label, :position]
  end
end