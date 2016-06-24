require 'spec_helper'

describe Spree::Admin::SalePricesController do
  stub_authorization!

  let!(:product) { create(:product) }
  let!(:sale_price) { product.create_sale(value: '10').first }

  context '#index' do
    render_views

    xit 'should display list of sale prices when they exist' do
      spree_get :index, product_id: product.slug
      expect(response.code).to eq('200')
      expect(response.body).to include('Listing Sale Prices')
    end
  end

  context '#create' do
    let!(:variant) { create(:variant, product: product) }
    let(:params) do
        { sale_price: { value: '6' } }
    end

    context 'for a product that exists' do
      xit 'creates a special price associated with the variant and product' do
        expect {
          spree_post :create, params
          expect(response).to redirect_to(spree.admin_product_sale_prices_path(product))
        }.to change(Spree::SalePrice, :count).by(1)
      end
    end

    context 'for an invalid object' do
      xit 'render new page' do
        expect {
          spree_post :create, params
        }.to change(Spree::SalePrice, :count).by(0)
      end
    end
  end

  context '#destroy' do
    let(:product) { create(:product) }
    let!(:variant) { create(:variant, product: product) }

    context 'for a sale price product that exist' do
      xit 'deletes the associated sale price' do
        expect {
          spree_delete :destroy, sale_price: { product_id: product.slug }
          expect(response).to redirect_to(spree.admin_product_sale_prices_path(product))
        }.to change(Spree::SalePrice, :count).by(-1)
      end
    end
  end
end