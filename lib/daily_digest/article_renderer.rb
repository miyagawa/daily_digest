module DailyDigest
  class ArticleRenderer
    def render(articles)
      articles.each do |article|
        article.rendered_content = render_article(article.content)
      end
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
      cache.sub(/\.[a-zA-Z]+$/, '_r.jpg').tap do |dest|
        system 'convert', '-quality', '60', '-resize', '768x>', cache, dest
      end
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
  end
end
