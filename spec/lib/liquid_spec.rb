require File.dirname(__FILE__) + '/../spec_helper'

describe "Standard Tags" do
  dataset :users_and_pages, :file_not_found, :snippets
  
  it "should should allow access to current page" do
    page(:home).should render('{% title %}').as('Home')
  end

  [:breadcrumb, :slug, :title, :url].each do |attr|
    it "{% #{attr} %} should render the '#{attr}' attribute" do
      value = page(:home).send(attr)
      page.should render("{% #{attr} %}").as(value.to_s)
    end
  end

  it "{% url %} with a nil relative URL root should scope to the relative root of /" do
    ActionController::Base.relative_url_root = nil
    page(:home).should render("{% url %}").as("/")
  end

  it '{% url %} with a relative URL root should scope to the relative root' do
    page(:home).should render("{% url %}").with_relative_root("/foo").as("/foo/")
  end

  it '{% parent %} should change the local context to the parent page' do
    page(:parent).should render('{% parent %}{% title %}{% endparent %}').as(pages(:home).title)
  end

  it "{% page.children %} should iterate over current page's children" do
    page(:home).should \
      render('{% for child in page.children %}{{ child.title }}{% endfor %}').
      as(page_eachable_children(page).map(&:title).join(''))
    # would also work as {% for page in page.children %}{% title %}{% endfor %}
    # because context['page'] would be overridden on each iteration
  end

  it "{% children %} should respect scope of {% parent %}" do
    page(:parent).should \
      render("{% parent %}{% for child in page.children %}{{ child.title }}{% endfor %}{% endparent %}").
      as(page_eachable_children(pages(:home)).map(&:title).join(""))
    # would also work as ...{% for page in page.children %}{% title %}{% endfor %}...
    # (see above)
  end

  it "{% parent %} should respect scope of {% children %}" do
    page(:parent).should \
      render('{% for page in page.children %}{% parent %}{% title %}{% endparent %}{% endfor %}').
      as(page.title * page.children.count)
    # would also work as ...{% parent %}{{ page.title }}{% endparent %}...
    # but at this point the local context is hard to understand
  end

  it '{% if page.parent %} should render the contained block if the current page has a parent page' do
    page(:parent).should render('{% if page.parent %}true{% endif %}').as('true')
    page(:home).should render('{% if page.parent %}true{% endif %}').as('')
  end

  it '{% unless page.parent %} should render the contained block unless the current page has a parent page' do
    page(:home).should render('{% unless page.parent %}true{% endunless %}').as('true')
    page(:parent).should render('{% unless page.parent %}true{% endunless %}').as('')
  end

  it '{% if page.children any %} should render the contained block if the current page has child pages' do
    page(:home).should render('{% if page.children any %}true{% endif %}').as('true')
    page(:childless).should render('{% if page.children any %}true{% endif %}').as('')
  end

  it '{% unless page.children any %} should render the contained block if the current page has no child pages' do
    page(:home).should render('{% unless page.children any %}true{% endunless %}').as('')
    page(:childless).should render('{% unless page.children any %}true{% endunless %}').as('true')
  end

  describe "{% for child in page.children %}" do
    it "should iterate through the children of the current page" do
      page(:parent).should \
        render("{% for page in page.children %}{% title %} {% endfor %}").
        as('Child Child 2 Child 3 ')
    end

    it "should retain access to parent page while iterating" do
      page(:parent).should \
        render('{% for child in page.children %}{{ page.slug }}/{{ child.slug }} {% endfor %}').
        as('parent/child parent/child-2 parent/child-3 ')
    end

    it "should not list draft pages" do
      page.should \
        render('{% for child in page.children.published %}{{ child.slug }} {% endfor %}').
        as('a b c d e f g h i j ')
    end

    it 'should include draft pages with status="all"' do
      page.should \
        render('{% for child in page.children.all %}{{ child.slug }} {% endfor %}').
        as('draft a b c d e f g h i j ')
    end
    
    it "should respect a sort clause" do
      page.should \
        render('{% for child in page.children.all|sort:"slug" %}{{ child.slug }} {% endfor %}').
        as('a b c d draft e f g h i j ')
    end

    it "should include draft pages by default on the dev host" do
      page.should \
        render('{% for child in page.children %}{{ child.slug }} {% endfor %}').
        as('draft a b c d e f g h i j ').on('dev.site.com')
    end

  end

  private

    def page(symbol = nil)
      if symbol.nil?
        @page ||= page(:assorted)
      else
        @page = pages(symbol)
      end
    end

    def page_children_each_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:each#{attr}><r:slug /> </r:children:each>"
    end

    def page_children_first_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:first#{attr}><r:slug /></r:children:first>"
    end

    def page_children_last_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:last#{attr}><r:slug /></r:children:last>"
    end

    def page_eachable_children(page)
      page.children.published.physical
    end
end