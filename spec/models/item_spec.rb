# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  describe 'columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(primary: true) }
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: true) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:title).unique }
    it { is_expected.to have_db_index(:created_at) }
    it { is_expected.to have_db_index(:updated_at) }
  end

  describe 'validations' do
    subject { create(:item) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(5) }
  end

  shared_context 'when items in database' do
    let!(:item2) { create(:item, title: 'Second', created_at: 5.days.ago, updated_at: 3.days.ago) }
    let!(:item1) { create(:item, title: 'First', created_at: 10.days.ago, updated_at: 1.day.ago) }
    let!(:item3) { create(:item, title: 'Third', created_at: 7.days.ago, updated_at: 2.days.ago) }
  end

  describe '.ordered' do
    include_context 'when items in database'

    context 'when ordering by title ascending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('title', 'asc').to_a).to eq([item1, item2, item3])
      end
    end

    context 'when ordering by title descending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('title', 'desc').to_a).to eq([item3, item2, item1])
      end
    end

    context 'when ordering by created_at ascending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('created_at', 'asc').to_a).to eq([item1, item3, item2])
      end
    end

    context 'when ordering by created_at descending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('created_at', 'desc').to_a).to eq([item2, item3, item1])
      end
    end

    context 'when ordering by updated_at ascending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('updated_at', 'asc').to_a).to eq([item2, item3, item1])
      end
    end

    context 'when ordering by updated_at descending' do
      it 'returns items in the correct order' do
        expect(described_class.ordered('updated_at', 'desc').to_a).to eq([item1, item3, item2])
      end
    end
  end

  describe '.from_date_or_newer_than' do
    include_context 'when items in database'

    it 'returns only correct items' do
      expect(described_class.from_date_or_newer_than(item3.updated_at)).to contain_exactly(item1, item3)
    end
  end

  describe '.from_date_or_older_than' do
    include_context 'when items in database'

    it 'returns only correct items' do
      expect(described_class.from_date_or_older_than(item3.updated_at)).to contain_exactly(item2, item3)
    end
  end

  describe '.searched_in_description' do
    let!(:item4) { create(:item, description: 'Whatever is there in Dublin.') }
    let!(:item1) { create(:item, description: 'Some words in the description') }
    let!(:item3) { create(:item, description: 'Nothing else but the title') }
    let!(:item2) { create(:item, description: 'Other words or pictures') }

    it 'finds correct items' do
      expect(described_class.searched_in_description('word')).to contain_exactly(item1, item2)
    end
  end

  describe '.with_text_in_title' do
    let!(:item4) { create(:item, title: 'Whatever is there in Dublin.') }
    let!(:item1) { create(:item, title: 'Some words in the description') }
    let!(:item3) { create(:item, title: 'Nothing else but the title') }
    let!(:item2) { create(:item, title: 'Other words or pictures') }

    it 'finds correct items' do
      expect(described_class.with_text_in_title('word')).to contain_exactly(item1, item2)
    end
  end

  describe '.searchable_language' do
    it 'return english' do
      expect(described_class.searchable_language).to eq('english')
    end
  end

  describe '.searchable_columns' do
    it 'returns title and description' do
      expect(described_class.searchable_columns).to contain_exactly(:title, :description)
    end
  end

  describe '.sorting_column' do
    context 'when given title column' do
      it 'converts it to symbol' do
        expect(described_class.sorting_column('title')).to be(:title)
      end
    end

    context 'when given created_at column' do
      it 'converts it to symbol' do
        expect(described_class.sorting_column('created_at')).to be(:created_at)
      end
    end

    context 'when given updated_at column' do
      it 'converts it to symbol' do
        expect(described_class.sorting_column('updated_at')).to be(:updated_at)
      end
    end

    context 'when given other column' do
      it 'returns updated_at sorting column converted to symbol' do
        expect(described_class.sorting_column('other')).to be(:updated_at)
      end
    end
  end

  describe '.sorting_direction' do
    context 'when given asc direction' do
      it 'converts it to symbol' do
        expect(described_class.sorting_direction('asc')).to be(:asc)
      end
    end

    context 'when given desc direction' do
      it 'converts it to symbol' do
        expect(described_class.sorting_direction('desc')).to be(:desc)
      end
    end

    context 'when given other direction' do
      it 'returns asc direction converted to symbol' do
        expect(described_class.sorting_direction('other')).to be(:desc)
      end
    end
  end
end
