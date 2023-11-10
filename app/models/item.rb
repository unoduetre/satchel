# frozen_string_literal: true

# Item in an item list identified by its title
class Item < ApplicationRecord
  SORTING_COLUMNS = %w[updated_at title created_at].freeze
  SORTING_DIRECTIONS = %w[desc asc].freeze

  validates :title, presence: true, uniqueness: true, length: { minimum: 5 }

  scope :ordered, ->(column, direction) { order(Item.sorting_column(column) => Item.sorting_direction(direction)) }
  scope :from_date_or_newer_than, ->(date) { date.present? ? where(updated_at: date..) : itself }
  scope :from_date_or_older_than, ->(date) { date.present? ? where(updated_at: ..date) : itself }
  scope :with_text_in_title, ->(text) { where('title ILIKE ?', "%#{text}%") }
  scope :searched_in_description, ->(searched) { basic_search(description: searched) }

  class << self
    def searchable_language
      'english'
    end

    def searchable_columns
      %i[title description]
    end

    def sorting_column(column)
      return SORTING_COLUMNS.first.to_sym unless SORTING_COLUMNS.include?(column)

      column.to_sym
    end

    def sorting_direction(direction)
      return SORTING_DIRECTIONS.first.to_sym unless SORTING_DIRECTIONS.include?(direction)

      direction.to_sym
    end
  end
end
