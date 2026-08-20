module HelpCenter
  module ReadTimeHelper
    WORDS_PER_MINUTE = 100

    def article_read_time(article)
      configured_time = article.configurations["estimated_read_time"].presence
      return configured_time.to_i if configured_time

      word_count = strip_tags(article.content.to_s).scan(/\w+/).size
      [ (word_count.to_f / WORDS_PER_MINUTE).ceil, 1 ].max
    end
  end
end
