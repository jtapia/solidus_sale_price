module Spree
  module Admin
    class SalePricesController < ResourceController
      before_filter :load_data

      def index
        @sale_prices = @product.sale_prices
      end

      def create
        if @product.create_sale(value: sale_price_params[:value], start_at: sale_price_params[:start_at], end_at: sale_price_params[:end_at])
          flash.now[:success] = Spree.t(:successfully_created)
          redirect_to admin_product_sale_prices_path(@product)
        else
          render :new
        end
      end

      def update
        if @product.update_sale(sale_price_params)
          flash.now[:success] = Spree.t(:successfully_updated)
        else
          flash.now[:error] = Spree.t(:error_on_update)
        end

        render :edit
      end

      def stop
        if @product.stop_sale
          flash[:success] = Spree.t(:sale_price_stopped)

          respond_with(@product) do |format|
            format.html { redirect_to admin_product_sale_prices_path(@product) }
            format.js { redirect_to admin_product_sale_prices_path(@product) }
          end
        end
      end

      def enable
        if @product.enable_sale(end_at: nil)
          flash[:success] = Spree.t(:sale_price_enabled)

          respond_with(@product) do |format|
            format.html { redirect_to admin_product_sale_prices_path(@product) }
            format.js { redirect_to admin_product_sale_prices_path(@product) }
          end
        end
      end

      private

      def sale_price_params
        params.require(:sale_price).permit(permitted_sale_price_attributes)
      end

      def permitted_sale_price_attributes
        [ :value, :start_at, :end_at ]
      end

      def load_data
        @product = Spree::Product.friendly.find(params[:product_id])
      end
    end
  end
end