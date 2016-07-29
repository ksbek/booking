class DashboardAccountController extends @NGController
  @register window.App, 'DashboardAccountController'

  @$inject: [
    '$scope'
    '$rootScope'
    'Flash'
    'User'
    '$state',
    'CreditCard',
    '$locale',
    '_'
  ]

  tabsAccount: []
  user: {}
  creditCards: []
  card:
    pending: false
  months: []
  years: []

  tabsAccount: [
    { heading: 'Payment', route: 'dashboard.account.payment' }
    { heading: 'Information', route: 'dashboard.account.information' }
    { heading: 'Security', route: 'dashboard.account.security' }
  ]

  init: ->
    @scope.months = @locale.DATETIME_FORMATS.SHORTMONTH
    currentYear = new Date().getFullYear()
    @scope.years = _.range(currentYear, currentYear + 10)

    @User
      .get(1)
      .then (user) =>
        @scope.user = user
        @scope.creditCards = user.creditCards
        if @scope.user.role in ['performer']
          @scope.tabsAccount = tabsAccount
        else
          @scope.tabsAccount = tabsAccount
          @scope.tabsAccount.splice(1, 1)

  changePassword: =>
    @userSave 'Password was changed successfully.'

  changeEmail: =>
    @userSave 'Email was changed successfully.'

  addNewCard: =>
    @scope.card.pending = true
    Stripe.card.createToken
      number: @scope.card.number
      cvc: @scope.card.cvc
      exp_month: @scope.card.exp_month
      exp_year: @scope.card.exp_year.toString().substr(2, 2)
    , (status, response) =>
      if response.error
        @Flash.showError @scope, response.error.message
        @scope.card.pending = false
      else
        cardToken = response.id
        new @CreditCard(card_token: cardToken).create()
          .then (card) =>
            @scope.card = {}
            _.each(@scope.creditCards, (card) -> card.default = false)
            @scope.creditCards.push card
            @scope.card.pending = false
            @Flash.showNotice @scope, 'Card is successfully saved!'
          , (error) =>
            @Flash.showError @scope, 'Failed to create new card'
            @scope.card.pending = false

  makeDefaultCard: (cardId) =>
    @CreditCard.updateDefault(cardId)
      .then (cards) =>
        @scope.creditCards = cards
        @Flash.showNotice @scope, 'Card is successfully marked as your default.'

  disconnectStripe: =>
    if @scope.user
      @scope.user.disconnectStripe()
        .then (user) =>
          @scope.user = user
          @Flash.showNotice @scope, "Stripe successfully disconnected"

  userSave: (notice)=>
    if @scope.user
      @scope.user.save()
        .then (user)=>
          @scope.user = user
          @Flash.showNotice @scope, notice
        , (error)->
          # @Flash.showError @scope, 'User was saved successfully.'
