# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::ImageHelper, type: :helper do
  describe '#picture_tag' do
    it 'returns empty string when attachment is not attached' do
      attachment = double('Attachment', attached?: false)
      expect(helper.picture_tag(attachment)).to eq('')
    end
  end

  describe '#lazy_picture_tag' do
    it 'returns empty string when attachment is not attached' do
      attachment = double('Attachment', attached?: false)
      expect(helper.lazy_picture_tag(attachment)).to eq('')
    end
  end
end
