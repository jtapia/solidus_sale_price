Deface::Override.new(
  virtual_path: 'spree/shared/_products',
  name: 'add_sale_price_to_product',
  replace: 'span.price'
) do
  "<% if product.on_sale? %>
    <span class='price sale' itemprop='sale_price'><%= number_to_currency(product.sale_price) %></span>
    <span class='price selling' itemprop='price'><%= display_price(product) %></span>
  <% else %>
    <span class='price selling' itemprop='price'><%= display_price(product) %></span>
  <% end %>"
end
