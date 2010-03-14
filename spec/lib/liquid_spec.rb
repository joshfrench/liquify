require File.dirname(__FILE__) + '/../spec_helper'

describe "Standard Tags" do
  dataset :users_and_pages, :file_not_found, :snippets
  
  it "should should allow access to current page" do
    pages(:home).should render('{% title %}').as('Home')
  end

  [:breadcrumb, :slug, :title, :url].each do |attr|
    it "{% #{attr} %} should render the '#{attr}' attribute" do
      page = pages(:home)
      value = page.send(attr)
      page.should render("{% #{attr} %}").as(value.to_s)
    end
  end

  it "{% url %} with a nil relative URL root should scope to the relative root of /" do
    ActionController::Base.relative_url_root = nil
    pages(:home).should render("{% url %}").as("/")
  end

  it '{% url %} with a relative URL root should scope to the relative root' do
    pages(:home).should render("{% url %}").with_relative_root("/foo").as("/foo/")
  end

  it '{% parent %} should change the local context to the parent page' do
    pages(:parent).should render('{% parent %}{% title %}{% endparent %}').as(pages(:home).title)
  end

  it "{% page.children %} should iterate over current page's children" do
    pages(:home).should render('{% for child in page.children %}{{ child.title }}{% endfor %}').as(pages(:home).children.map(&:title).join(''))
    # would also work as {% for page in page.children %}{% title %}{% endfor %}
    # because context['page'] would be overridden on each iteration
  end

  it "{% children %} should respect scope of {% parent %}" do
    pages(:parent).should \
      render("{% parent %}{% for child in page.children %}{{ child.title }}{% endfor %}{% endparent %}").
      as(pages(:home).children.collect(&:title).join(""))
    # would also work as ...{% for page in page.children %}{% title %}{% endfor %}...
    # (see above)
  end

  it "{% parent %} should respect scope of {% children %}" do
    pages(:parent).should \
      render('{% for page in page.children %}{% parent %}{% title %}{% endparent %}{% endfor %}').
      as(pages(:parent).title * pages(:parent).children.count)
    # would also work as ...{% parent %}{{ page.title }}{% endparent %}...
    # but at this point the local context is hard to understand
  end

  it '{% if page.parent %} should render the contained block if the current page has a parent page' do
    pages(:parent).should render('{% if page.parent %}true{% endif %}').as('true')
    pages(:home).should render('{% if page.parent %}true{% endif %}').as('')
  end

  it '{% unless page.parent %} should render the contained block unless the current page has a parent page' do
    pages(:home).should render('{% unless page.parent %}true{% endunless %}').as('true')
    pages(:parent).should render('{% unless page.parent %}true{% endunless %}').as('')
  end

  it '{% if page.children any %} should render the contained block if the current page has child pages' do
    pages(:home).should render('{% if page.children any %}true{% endif %}').as('true')
    pages(:childless).should render('{% if page.children any %}true{% endif %}').as('')
  end

  it '{% unless page.children any %} should render the contained block if the current page has no child pages' do
    pages(:home).should render('{% unless page.children any %}true{% endunless %}').as('')
    pages(:childless).should render('{% unless page.children any %}true{% endunless %}').as('true')
  end

  describe "{% for child in page.children %}" do
    it "should iterate through the children of the current page" do
      pages(:parent).should render("{% for page in page.children %}{% title %} {% endfor %}").as('Child Child 2 Child 3 ')
    end

    it "should retain access to parent page while iterating" do
      pages(:parent).should render('{% for child in page.children %}{{ page.slug }}/{{ child.slug }} {% endfor %}').as('parent/child parent/child-2 parent/child-3 ')
    end

    it "should not list draft pages" do
      pages(:assorted).should render('{% for child in page.children.published %}{{ child.slug }} {% endfor %}').as('a b c d e f g h i j ')
    end
  end

end