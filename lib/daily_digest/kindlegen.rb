require 'erb'
require 'fileutils'
require 'digest'
require 'uri'

module DailyDigest
  class Kindlegen
    include ERB::Util

    def render(articles, path)
      output = ERB.new(template).result(binding)
      File.open(path, 'w') {|f| f.write(output) }
    end

    def template
      <<-EOF.gsub /^\s+/, ''
        <html>
        <head>
        <meta http-requiv="Content-Type" content="text/html;charset=utf-8">
        <title>Daily Digest <%= Time.now.strftime('%Y/%m/%d') %></title>
        </head>
        <body>
          <% articles.each do |article| %>
          <h2 class="chapter"><%=h article.title %></h2>
          <div style="text-align:right"><% if article.author %><%=h article.author %> | <% end %><a href="<%=h article.url %>"><%=h article.domain %></a></div>
          <hr>
          <%= render_article(article.content) %>
          <% end %>
        </body>
        </html>
      EOF
    end

    def render_article(content)
      expand_inline_images(content).gsub('<h2', '<h3')
    end

    def expand_inline_images(content)
      content.gsub(/src="(http.*?)"/) { %Q{src="#{expand_image(URI.parse($1))}"} }
    end

    def expand_image(url)
      cache = cache_path(url)
      system 'wget', '-nc', url.to_s, '-O', cache
      cache
    end

    def cache_path(url)
      cache_dir + "/" + Digest::SHA1.hexdigest(url.to_s) + (File.extname(url.path) || '.png')
    end

    def cache_dir
      begin
        FileUtils.mkdir('_cache')[0]
      rescue Errno::EEXIST
        '_cache'
      end
    end

    def convert(html, mobi)
      system "ebook-convert", html, mobi, "--mobi-keep-original-image", "--mobi-file-type", "both"
    end
  end
end
