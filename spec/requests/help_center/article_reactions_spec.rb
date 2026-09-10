# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HelpCenter::ArticleReactions', type: :request do
  let(:account) { create(:account) }
  let(:domain) { create(:domain, :custom, :dns_verified, account: account, value: 'support.example.com', status: :active) }
  let!(:portal) { create(:help_center_portal, account: account, domain: domain, status: :active) }

  before do
    set_tenant_host(domain)
  end

  describe 'POST /articles/:article_id/reaction' do
    it 'creates a happy reaction for an article' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        post article_reaction_path(article_id: article.id), params: {
          article_reaction: { reaction_type: 'happy' }
        }

        expect(response).to have_http_status(:redirect)
        expect(HelpCenter::ArticleReaction.find_by(article: article, reaction_type: 'happy')).to be_present
      end
    end

    it 'creates a sad reaction via turbo_stream format' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        post article_reaction_path(article_id: article.id), params: {
          article_reaction: { reaction_type: 'sad' }
        }, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
        expect(HelpCenter::ArticleReaction.find_by(article: article, reaction_type: 'sad')).to be_present
      end
    end

    it 'updates existing reaction when same IP submits a new reaction type' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        post article_reaction_path(article_id: article.id), params: {
          article_reaction: { reaction_type: 'happy' }
        }
        expect(HelpCenter::ArticleReaction.where(article: article).count).to eq(1)
        expect(HelpCenter::ArticleReaction.find_by(article: article).reaction_type).to eq('happy')

        post article_reaction_path(article_id: article.id), params: {
          article_reaction: { reaction_type: 'sad' }
        }
        expect(HelpCenter::ArticleReaction.where(article: article).count).to eq(1)
        expect(HelpCenter::ArticleReaction.find_by(article: article).reaction_type).to eq('sad')
      end
    end

    it 'returns unprocessable entity via turbo stream when reaction type is invalid' do
      account.with_shard do
        category = create(:help_center_category, account: account, portal: portal, status: :active)
        article = create(:help_center_article, account: account, portal: portal, primary_category: category, status: :published)

        post article_reaction_path(article_id: article.id), params: {
          article_reaction: { reaction_type: 'invalid_reaction_type' }
        }, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:unprocessable_content).or have_http_status(:unprocessable_entity)
      end
    end
  end
end
