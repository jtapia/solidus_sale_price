require 'spec_helper'

describe Spree::Admin::SalePricesController, type: :controller do
  stub_authorization!

  context '#index' do
    let(:product) { create(:product) }
    let(:sale_price) { product.create_sale(value: '10').first }
    let(:params) { { product_id: product.slug } }

    it 'should display list of sale prices when they exist' do
      get :index, params: params
      expect(response.code).to eq('200')
    end
  end

  context '#create' do
    context 'for a product that exists' do
      let(:product) { create(:product) }
      let(:variant) { create(:variant, product: product) }
      let(:params) do
          { sale_price: { value: '6' }, product_id: product.slug }
      end

      it 'creates a special price associated with the variant and product' do
        expect {
          post :create, params: params
          expect(response).to redirect_to(spree.admin_product_sale_prices_path(product))
        }.to change(Spree::SalePrice, :count).by(1)
      end
    end

    context 'for an invalid object' do
      let(:product) { create(:product) }
      let(:variant) { create(:variant, product: product) }
      let(:params) do
        { sale_price: { value: '' }, product_id: product.slug }
      end

      it 'render new page' do
        expect {
          post :create, params: params
        }.to change(Spree::SalePrice, :count).by(0)
      end
    end
  end
end