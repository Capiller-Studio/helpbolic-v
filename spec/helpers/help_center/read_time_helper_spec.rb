# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::ReadTimeHelper, type: :helper do
  describe '#article_read_time' do
    it 'returns explicit estimated_read_time configuration if present' do
      article = double('Article', configurations: { 'estimated_read_time' => 7 }, content: 'Short text')
      expect(helper.article_read_time(article)).to eq(7)
    end

    it 'calculates reading time from word count (100 words per minute)' do
      # 250 words should be 3 minutes (250 / 100 = 2.5.ceil = 3)
      long_content = "<p>#{([ 'word' ] * 250).join(' ')}</p>"
      article = double('Article', configurations: {}, content: long_content)
      expect(helper.article_read_time(article)).to eq(3)
    end

    it 'returns at least 1 minute for short articles' do
      article = double('Article', configurations: {}, content: 'Hello world')
      expect(helper.article_read_time(article)).to eq(1)
    end

    it 'returns 1 minute for empty content' do
      article = double('Article', configurations: {}, content: '')
      expect(helper.article_read_time(article)).to eq(1)
    end
  end
end
