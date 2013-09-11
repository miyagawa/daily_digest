require 'erb'
require 'fileutils'
require 'digest'
require 'uri'

module DailyDigest
  class Kindlegen
    include ERB::Util

    def x(str)
      str.codepoints.map { |code| code > 127 ? "&##{code};" : code.chr }.join("")
    end

    def render(articles, path)
      output = ERB.new(template).result(binding)
      File.open(path, 'w') {|f| f.write(output) }
    end

    def template
      <<-EOF.gsub /^\s+/, ''
        <html>
        <head>
        <meta http-requiv="Content-Type" content="text/html;charset=utf-8">
        <meta name="Author" content="daily_digest">
        <title>Daily Digest <%= Time.now.strftime('%Y/%m/%d') %></title>
        </head>
        <body>
          <% articles.each_with_index do |article, i| %>
          <p><a name="chap<%= i %>"></a><h2 class="chapter"><%=x article.title %></h2></p>
          <div style="text-align:right"><% if article.author %><%=h article.author %> | <% end %><a href="<%=h article.url %>"><%=h article.domain %></a></div>
          <hr>
          <% if article.content %><%= render_article(article.content) %><% end %>
          <mbp:pagebreak/>
          <% end %>

          <p><a name="TOC"><h3>Table of Contents</h3></a></p>
          <ul>
          <% articles.each_with_index do |article, i| %>
          <li><a href="#chap<%= i %>"><%=x article.title %></a></li>
          <% end %>
          </ul>
          <mbp:pagebreak/>
        </body>
        </html>
      EOF
    end

    def render_article(content)
      expand_inline_images(content).gsub('<h2', '<h3').gsub('</h2>', '</h3>')
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
      system "kindlegen", html, "-o", mobi, "-verbose"
    end
  end
end
