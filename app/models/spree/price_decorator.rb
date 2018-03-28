Spree::Price.class_eval do
  has_many :sale_prices, dependent: :destroy

  def put_on_sale(params = {})
    new_sale(params).save
  end
  alias :create_sale :put_on_sale

  def new_sale(params = {})
    sale_price_params = { value: params.fetch(:value, nil),
                          start_at: params.fetch(:start_at, DateTime.now),
                          end_at: params.fetch(:end_at, nil),
                          enabled: params.fetch(:enabled, true),
                          calculator: params.fetch(:calculator_type, Spree::Calculator::FixedAmountSalePriceCalculator.new) }

    return sale_prices.new(sale_price_params)
  end

  def active_sale
    first_sale(sale_prices.active) if on_sale?
  end
  alias :current_sale :active_sale

  def next_active_sale
    first_sale(sale_prices) if sale_prices.present?
  end
  alias :next_current_sale :next_active_sale

  def sale_price
    active_sale.calculated_price if on_sale?
  end

  def sale_price=(value)
    if on_sale?
      active_sale.update_attribute(:value, value)
    else
      put_on_sale(value)
    end
  end

  def discount_percent
    return 0.0 unless original_price > 0
    return 0.0 unless on_sale?
    (1 - (sale_price / original_price)) * 100
  end

  def on_sale?
    sale_prices.active.present? && first_sale(sale_prices.active).value < original_price
  end

  def original_price
    self[:amount]
  end

  def original_price=(value)
    self[:amount] = Spree::LocalizedNumber.parse(value)
  end

  def price
    on_sale? ? sale_price : original_price
  end

  def price=(price)
    if on_sale?
      sale_price = price
    else
      self[:amount] = Spree::LocalizedNumber.parse(price)
    end
  end

  def amount
    price
  end

  def enable_sale
    next_active_sale.enable if next_active_sale.present?
  end

  def disable_sale
    active_sale.disable if active_sale.present?
  end

  def start_sale(end_time = nil)
    next_active_sale.start(end_time) if next_active_sale.present?
  end

  def stop_sale
    active_sale.stop if active_sale.present?
  end

  def update_sale(attrs)
    active_sale.update(attrs) if active_sale.present?
  end

  private

  def first_sale(scope)
    scope.order('created_at DESC').first
  end
end