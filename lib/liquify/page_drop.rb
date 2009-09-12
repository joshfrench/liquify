module Liquify

  class PartDrop < Liquid::Drop
    def initialize(page)
      @page = page
    end

    def [](part)
      @context['part_name'] = part if @context
      if part = @page.part(part)
        Liquid::Template.parse(part.content).render(@context)
      end
    end

    alias method_missing []
  end

  class PageDrop < Liquid::Drop
    attr_accessor :page
    delegate :title, :slug, :breadcrumb, :parent, :to => :page

    def initialize(page)
      @page = page
    end

    def author
      if author = @page.created_by
        author.name
      end
    end

    def parts
      PartDrop.new(@page)
    end

  end
end