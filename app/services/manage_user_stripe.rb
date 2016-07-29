class ManageUserStripe
  def initialize(user)
    @user = user
  end

  def create_credit_card(token)
    create_stripe_customer if @user.customer_id.nil?
    customer = Stripe::Customer.retrieve @user.customer_id

    card = customer.sources.create(source: token)
    customer.default_source = card.id
    customer.save

    card = CreditCard.new(
      stripe_id: card.id,
      brand: card.brand,
      country: card.country,
      exp_month: card.exp_month,
      exp_year: card.exp_year,
      funding: card.funding,
      last4: card.last4,
      user: @user
    )
    card.save
    card.set_default!
    card
  end

  def change_default_create_card(card_id)
    card = @user.credit_cards.find(card_id)
    customer = Stripe::Customer.retrieve @user.customer_id
    customer.default_source = card.stripe_id
    customer.save

    card.set_default!
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(
      email: @user.email
    )
    @user.update(customer_id: customer.id)
  end

  def disconnect_stripe
    @user.update(stripe_user_id: nil, stripe_pub_key: nil, stripe_access_code: nil)
  end
end
