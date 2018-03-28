module Spree
  class SalePrice < ActiveRecord::Base
    acts_as_paranoid

    belongs_to :price, class_name: 'Spree::Price', touch: true
    delegate :currency, :currency=, to: :price, allow_nil: true
    delegate :variant_id, to: :price, allow_nil: true

    has_one :variant, through: :price
    has_one :product, through: :variant
    has_one :calculator, class_name: "Spree::Calculator", as: :calculable, dependent: :destroy

    validates :value, :calculator, :price, presence: true
    accepts_nested_attributes_for :calculator

    scope :ordered, -> { order('start_at IS NOT NULL, start_at ASC') }
    scope :active, -> { where(enabled: true).where('(start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)', Time.now, Time.now) }

    def self.for_product(product)
      ids = product.variants_including_master
      ordered.where(price_id: Spree::Price.where(variant_id: ids))
    end

    def calculator_type
      calculator.class.to_s if calculator
    end

    def calculated_price
      calculator.compute(self)
    end

    def enable
      update_attributes(enabled: true)
    end

    def disable
      update_attribute(:enabled, false)
    end

    def active?
      active.include?(self)
    end

    def start(end_time = nil)
      end_time = nil if end_time.present? && end_time <= Time.now # if end_time is not in the future then make it nil (no end)
      attr = { end_at: end_time, enabled: true }
      attr[:start_at] = Time.now if self.start_at.present? && self.start_at > Time.now # only set start_at if it's not set in the past
      update_attributes(attr)
    end

    def stop
      update_attributes(end_at: Time.now, enabled: false)
    end

    def update(attrs={})
      update_attributes(attrs.except(:variant_id))
      price.update_attribute(:variant_id, attrs[:variant_id])
    end

    # Convenience method for displaying the price of a given sale_price in the table
    def display_price
      Spree::Money.new(value || 0, { currency: price.currency })
    end
  end
end
