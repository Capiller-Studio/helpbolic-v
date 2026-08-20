# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HelpCenter::AvatarHelper, type: :helper do
  describe '#display_name' do
    it 'prioritizes display_name if present' do
      user = double('User', display_name: 'John D.', name: 'John Doe', first_name: 'John', middle_name: nil, last_name: 'Doe', email: 'john@example.com')
      expect(helper.display_name(user)).to eq('John D.')
    end

    it 'falls back to name if display_name is blank' do
      user = double('User', display_name: nil, name: 'John Doe', first_name: 'John', middle_name: nil, last_name: 'Doe', email: 'john@example.com')
      expect(helper.display_name(user)).to eq('John Doe')
    end

    it 'falls back to first, middle, last name combination' do
      user = double('User', display_name: nil, name: nil, first_name: 'Alice', middle_name: 'Marie', last_name: 'Smith', email: 'alice@example.com')
      expect(helper.display_name(user)).to eq('Alice Marie Smith')
    end

    it 'falls back to email if names are blank' do
      user = double('User', display_name: nil, name: nil, first_name: nil, middle_name: nil, last_name: nil, email: 'user@example.com')
      expect(helper.display_name(user)).to eq('user@example.com')
    end
  end

  describe '#initials' do
    it 'returns the uppercase first letter of the display name' do
      user = double('User', display_name: 'sarah', name: nil, first_name: nil, middle_name: nil, last_name: nil, email: nil)
      expect(helper.initials(user)).to eq('S')
    end

    it 'returns "?" if display name is blank' do
      user = double('User', display_name: nil, name: nil, first_name: nil, middle_name: nil, last_name: nil, email: nil)
      expect(helper.initials(user)).to eq('?')
    end
  end
end
