#Bootstrap is used to style bits of the demo. Remove it from the config, gemfile and stylesheets to stop using bootstrap
require "uglifier"
require "exifr/jpeg"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :livereload
# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "/admin/*", layout: false

activate :blog do |blog|
  blog.permalink = "blog/{title}.html"
  blog.sources = "posts/{title}.html"
  blog.layout = "blog"
end

month_labels = ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december']

start_date = Date.new(2022, 5, 1)
date = Date.today

all_months = (start_date..date).map { |d| { year: d.year, month: d.month } }.uniq.map { |val| val.merge(param: "#{month_labels[val[:month] - 1]}-#{val[:year]}", label: "#{month_labels[val[:month] - 1]} #{val[:year]}") }

all_months.each do |month|
  proxy "fotos/#{month[:param]}.html", "fotos.html", locals: { month: month }
end

config[:all_months] = all_months.reverse

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy product.yml files to product.html

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# pretty urls
activate :directory_indexes

helpers do
  #helper to set background images with asset hashes in a style attribute
  def background_image(image)
    "background-image: url('" << image_path(image) << "')"
  end

  def nav_link(link_text, url, options = {})
    options[:class] ||= ""
    options[:class] << " active" if url == current_page.url
    link_to(link_text, url, options)
  end

  def markdown(content)
     Tilt['markdown'].new(context: @app) { content }.render
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  # Minify css on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript, ignore: "**/admin/**", compressor: ::Uglifier.new(mangle: true, compress: { drop_console: true }, output: {comments: :none})

  # Use Gzip
  activate :gzip

  #Use asset hashes to use for caching
  #activate :asset_hash

end
