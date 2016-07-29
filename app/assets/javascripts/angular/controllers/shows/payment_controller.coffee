class ShowPaymentController extends @NGController
  @register window.App, 'ShowPaymentController'

  @$inject: [
    '$scope'
    '$rootScope'
    'Show'
    'User'
    'Booking'
    'Flash'
    '$state'
    '$stateParams'
    '$uibModal'
  ]

  show: {}
  card: {}

  init: ()=>
    id = @stateParams.id
    date = moment.unix(@stateParams.date).toDate()

    @scope.booking = new @Booking
      date: date
      spectators: @stateParams.spectators

    @User
      .get(1)
      .then (user)=>
        @scope.user = user
        @scope.user.creditCards.unshift({last4: '', brand: 'Paypal'})
        @scope.user.creditCards.unshift({last4: '', brand: 'Add New Card'})
        @scope.user.addresses.unshift({fullAddress: 'Add New Address'})
    if @stateParams.show
      @scope.show = @stateParams.show
    else
      if id
        @Show
          .get id
          .then (show)=>
            @scope.show = show
            if @scope.show.pricePerson
              @scope.booking.price     = @scope.show.price * @scope.show.commission * @scope.booking.spectators
            else
              @scope.booking.price     = @scope.show.price * @scope.show.commission
            @scope.bannerStyle =
              'background-image' : "url(\"" + @scope.show.bannerUrl + "\")"
            # set selected
            for picture in @scope.show.pictures
              picture.selected = true  if picture.id == @scope.show.coverPictureId
              picture._destroy = 0
      else
        # @window.location.href = '/'

  applyCoupon: () =>
    @scope.booking.applyCoupon(@scope.booking.coupon)
    .then (result) =>
      if result.success
        if @scope.show.pricePerson
          @scope.booking.price     = @scope.show.price * @scope.show.commission * @scope.booking.spectators * 0.9
        else
          @scope.booking.price     = @scope.show.price * @scope.show.commission * 0.9

  addNewCard: () =>
    modalInstance = @uibModal.open
      animation: true
      templateUrl: 'shows/add_new_card.html'
      backdrop  : 'static'
      controller: ['$scope', '$uibModalInstance', '$state', 'Flash', '$locale', 'CreditCard', ($scope, $uibModalInstance, $state, Flash, $locale, CreditCard)->
        $scope.months = $locale.DATETIME_FORMATS.SHORTMONTH
        currentYear = new Date().getFullYear()
        $scope.years = _.range(currentYear, currentYear + 10)
        $scope.addNewCard = () ->
          $scope.card.pending = true
          Stripe.card.createToken
            number: $scope.card.number
            cvc: $scope.card.cvc
            exp_month: $scope.card.exp_month
            exp_year: $scope.card.exp_year.toString().substr(2, 2)
          , (status, response) =>
            if response.error
              Flash.showError @scope, response.error.message
              $scope.card.pending = false
            else
              cardToken = response.id
              new CreditCard(card_token: cardToken).create()
                .then (card) =>
                  $scope.card = {}
                  Flash.showNotice $scope, 'Card is successfully saved!'
                  $scope.card.pending = false
                  $uibModalInstance.close card
                , (error) =>
                  Flash.showError $scope, 'Failed to create new card'
                  $scope.card.pending = false
                  $uibModalInstance.close false
      ]
    .result
    .then (result)=>
      if result
        @scope.user.creditCards.push(result)
        @scope.user.payment = result

  bookingCreate: ()=>
    @scope.user.save()
      .then (user)=>
        @scope.booking.status    = 2
        @scope.booking.addressId = @scope.user.address.id
        @scope.booking.creditCardId = @scope.user.payment.id
        @scope.booking.showId    = @scope.show.id
        @scope.booking.save()
          .then (booking)=>
            @state.go 'shows.payment_finish'
            @Flash.showNotice @scope, 'Booking saved successfully!'
          , (error)->
      , (error)->

  bookingOrder: (form)=>
    if form.$valid && @scope.user
      @scope.bookingCreate()

