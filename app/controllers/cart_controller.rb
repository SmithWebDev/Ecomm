class CartController < ApplicationController
  before_action :authenticate_user!, except: [:add_to_cart, :view_order]
  def order_complete
    @order  = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Rails Stripe customer',
      :currency => 'usd'
    )

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to cart_path
  end

  def add_to_cart
    @order = current_order
    line_item = @order.line_items.find_by(product_id: params[:product_id])

    if !line_item.blank?
      line_item.update(quantity: line_item.quantity += params[:quantity].to_i)
      line_item.update(line_item_total: line_item.quantity * line_item.product.price)
    else
      line_item = @order.line_items.new(product_id: params[:product_id], quantity: params[:quantity])

      @order.save
      session[:order_id] = @order.id
      line_item.update(line_item_total: (line_item.quantity * line_item.price))
    end

    redirect_back(fallback_location: root_path)
    # line_item = LineItem.create(product_id: params[:product_id], quantity: params[:quantity])
    # line_item.update(line_item_total: (line_item.quantity * line_item.product.price))
    # redirect_back(fallback_location: root_path)
  end

  def view_order
    @line_items = current_order.line_items
    # @line_items = LineItem.all
  end

  def checkout
    line_items = current_order.line_items

    unless line_items.length == 0
      current_order.update(user_id: current_user.id, subtotal: 0)
      
      @order = current_order

      line_items.each do |li|
        li.product.update(quantity: (line_item.product.quantity - line_tem.quantity))
        @order.order_items[li.product_id] = li.quantity
        @order.subtotal += li.line_item_total
      end
      @order.save

      @order.update(sales_tax: (@order.subtotal * 0.08))
      @order.update(grand_total: (@order.sales_tax + @order.subtotal))
      session[:order_id] = nil
    end

    # line_items = LineItem.all
    # @order = Order.create(user_id: current_user.id, subtotal: 0)

    # line_items.each do |line_item| 
    #   line_item.product.update(quantity: (line_item.product.quantity - line_item.quantity))
    #   @order.order_items[line_item.product_id] = line_item.quantity
    #   @order.subtotal += line_item.line_item_total
    # end
    @order.save

    @order.update(sales_tax: (@order.subtotal * 0.08))
    @order.update(grand_total: (@order.sales_tax + @order.subtotal))
    
    # line_items.destroy_all
  end
end
