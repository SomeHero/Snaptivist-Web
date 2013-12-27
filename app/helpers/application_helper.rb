module ApplicationHelper

  def angular_templates(path)
    path_base = "#{Rails.root}/app/views/"
    out = []
    
    Dir.glob("#{path_base}#{path}/**.ng.*").each do |template_path|
      local_path = template_path.gsub(path_base, '')
      partial_path = local_path.sub(/\/_/, '/')
      name_path = partial_path.sub(/\..*$/, '')

      out << %Q{<script type="text/ng-template" id="#{name_path}">}
      out << render(partial_path)
      out << %Q{</script>}
    end
    out.join.html_safe
  end

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

end
