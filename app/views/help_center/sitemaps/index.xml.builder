xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9", 'xmlns:xhtml' => "http://www.w3.org/1999/xhtml" do
  
  xml.tag! 'url' do
    xml.tag! 'loc', root_url
    xml.lastmod Time.current.strftime("%F")
  end
  
  if @current_portal.contact_form_enabled?
    xml.tag! 'url' do
      xml.tag! 'loc', contact_url
      xml.lastmod Time.current.strftime("%F")
    end
  end

  @categories.each do |category|
    xml.tag! 'url' do
      xml.tag! 'loc', category_url(id: category.slug.presence || category.id)
      xml.lastmod (category.updated_at || Time.current).strftime("%F")
    end
  end

  @articles.each do |article|
    xml.tag! 'url' do
      xml.tag! 'loc', article_url(id: article.slug.presence || article.id)
      xml.lastmod (article.updated_at || Time.current).strftime("%F")
    end
  end
end
