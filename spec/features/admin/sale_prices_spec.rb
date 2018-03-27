require 'spec_helper'

describe 'Admin sale prices' do
  stub_authorization!

  let(:product) { create(:product) }
  let(:small) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'S')])
  end
  let(:medium) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'M')])
  end
  let(:large) do
    create(:variant, product: product,
                     option_values: [create(:option_value, presentation: 'L')])
  end

  context 'when listing sale prices' do
    before { product.put_on_sale(value: 20.25, start_at: 1.hour.from_now) }

    xscenario 'with the master variant the product sale is shown' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)

      expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 1)

      within('[data-hook="admin_sale_prices_index_rows"]:first') do
        expect(page).to have_content(product.sku)
      end
    end

    context 'with multiple variants' do
      before do
        small.put_on_sale(value: 10.95, start_at: 5.days.from_now)
        medium.put_on_sale(value: 11.95, start_at: 10.days.from_now)
        large.put_on_sale(value: 32.21, start_at: 2.hours.from_now)
      end

      xscenario 'a list of variant sale prices is shown and sorted by start_at' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)

        expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 4)

        within('[data-hook="admin_sale_prices_index_rows"]:first') do
          expect(page).to have_content(product.sku)
        end

        within('[data-hook="admin_sale_prices_index_rows"]:nth-child(2)') do
          expect(page).to have_content(small.sku)
        end

        within('[data-hook="admin_sale_prices_index_rows"]:nth-child(3)') do
          expect(page).to have_content(medium.sku)
        end

        within('[data-hook="admin_sale_prices_index_rows"]:last') do
          expect(page).to have_content(large.sku)
        end
      end
    end
  end

  context 'when adding sale prices', js: true do
    xscenario 'a new sale price is added to the list' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)
      click_link('New Sale Price')

      within('form.new_sale_price') do
        fill_in('Value', with: 32.33)
        fill_in('Start At', with: '2016/12/11')
        fill_in('End At', with: '2016/12/17')
        click_button('Create')
      end

      within('[data-hook="admin_sale_prices_index_rows"]') do
        expect(page).to have_content(product.sku)
        expect(page).to have_content(32.33)
        expect(page).to have_content('December 11, 2016')
        expect(page).to have_content('December 17, 2016')
      end
    end

    context 'with a master variant' do
      before { small }

      xscenario 'a new sale price is added to the list' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)
        click_link('New Sale Price')

        within('form.new_sale_price') do
          fill_in('Value', with: 32.33)
          fill_in('Start At', with: '2016/12/11')
          fill_in('End At', with: '2016/12/17')
          click_button('Create')
        end

        expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 1)
      end

      xscenario 'only certain variant are added if selected' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)
        click_link('New Sale Price')

        within('form.new_sale_price') do
          fill_in('Value', with: 32.33)
          fill_in('Start At', with: '2016/12/11')
          fill_in('End At', with: '2016/12/17')
          select(small.sku_and_options_text, from: 'variant_id', visible: false)
          click_button('Create')
        end

        expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 1)
      end

      xscenario 'only non-master variants are added if selected' do
        visit spree.admin_product_sale_prices_path(product_id: product.slug)
        click_link('New Sale Price')

        within('form.new_sale_price') do
          fill_in('Value', with: 32.33)
          fill_in('Start At', with: '2016/12/11')
          fill_in('End At', with: '2016/12/17')
          select(small.sku_and_options_text, from: 'variant_id', visible: false)
          click_button('Create')
        end

        expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 1)
      end
    end
  end

  context 'when editing sale prices', js: true do
    around { |example| Timecop.freeze { example.run } }

    before do
      small.put_on_sale(value: 54.95, start_at: 1.day.ago, end_at: 1.day.from_now)
      medium
    end

    xscenario 'updates the sale price inplace' do
      visit spree.admin_product_sale_prices_path(product_id: product.slug)

      find('[data-action="edit"]').click

      expect(find_field('Value', with: '54.95')).to be_visible
      expect(find_field('Start At', with: 1.day.ago.strftime('%Y/%m/%d'))).to be_visible
      expect(find_field('End At', with: 1.day.from_now.strftime('%Y/%m/%d'))).to be_visible

      within('form.edit_sale_price') do
        fill_in('Value', with: 32.33)
        fill_in('Start At', with: 2.days.ago.strftime('%Y/%m/%d'))
        fill_in('End At', with: 2.days.from_now.strftime('%Y/%m/%d'))

        click_button('Update')
      end

      expect(page).to have_selector('[data-hook="admin_sale_prices_index_rows"]', count: 1)

      within('[data-hook="admin_sale_prices_index_rows"]') do
        expect(page).to have_content(small.sku)
        expect(page).to have_content('32.33')
        expect(page).to have_content(format_date(2.days.ago))
        expect(page).to have_content(format_date(2.days.from_now))
      end
    end
  end
end