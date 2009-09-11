module Liquify
  module Filters
    def inherit(content)
      page, part_name = @context['page'], @context['part_name']
      while (content.nil? and not page.parent.nil?) do
        page = page.parent.to_liquid
        content = page.parts[part_name]
      end
      content
    end
  end
end