angular
  .module 'enapparte'
  .directive 'inputEnum', ()->
    strict: 'E'
    templateUrl: 'directives/input_enum.html'
    scope:
      dtModel: '='
    replace: true
    link: (scope, element, attrs)->
      scope.dtLabel = attrs.dtLabel
      scope.elementId = 'input_' + scope.$id

      scope.options = []
      enums = JSON.parse(attrs.dtEnum)
      for value, label of enums
        scope.options.push { value: value, label: label }

  .directive 'inputString', ['$timeout', ($timeout)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_string.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      scope.hint = attrs.hint
      if attrs.focus != undefined
        $timeout ->
          element.find('input').focus()
  ]

  .directive 'inputText', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_text.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

  .directive 'inputCkeditor', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_ckeditor.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

  .directive 'inputDate', ()->
    strict: 'E'
    templateUrl: 'directives/input_date.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs)->
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.elementDayId = scope.elementId + '-day'
      scope.elementMonthId = scope.elementId + '-month'
      scope.elementYearId = scope.elementId + '-year'
      scope.required = attrs.required != undefined

      scope.$watch 'model', (newValue, oldValue)->
        if newValue && !scope.day
          scope.day = moment(newValue).date()
          scope.month = moment(newValue).month() + 1
          scope.year = moment(newValue).year()

      scope.$watchGroup ['day', 'month', 'year'], (newValue)->
        if scope.day && scope.month && scope.year
          scope.model = moment([scope.year, scope.month - 1, scope.day + 1]).toDate()

      scope.days = [1..31]
      scope.monthes = [1..12]
      scope.monthNames = []
      for month in scope.monthes
        scope.monthNames.push moment().month(month-1).format("MMMM")
      currentYear = new Date().getFullYear()
      scope.years = [currentYear - 70..currentYear - 5].reverse()

  .directive 'inputInteger', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_integer.html'
    scope:
      model: '='
      max: '='
      min: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

  .directive 'inputSelect', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_select.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.options = element.data('collection')
      scope.required = attrs.required != undefined

      scope.$watch 'model', (newValue, oldValue)->
        if newValue && !scope.selectedOption
          for option in scope.options
            if option.value == newValue
              scope.selectedOption = option

      scope.$watch 'selectedOption', (newValue)->
        if scope.selectedOption
          scope.model = scope.selectedOption.value

  .directive 'inputSelectGeneral', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_select_general.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.options = element.data('collection')
      scope.required = attrs.required != undefined

      scope.$watch 'model', (newValue, oldValue)->
        if newValue && !scope.selectedOption
          for option in scope.options
            if option.value == newValue
              scope.selectedOption = option

      scope.$watch 'selectedOption', (newValue)->
        if scope.selectedOption
          scope.model = scope.selectedOption.value


  .directive 'inputImage', ['Flash', (Flash)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_image.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      scope.model = []  unless scope.model
      fileTypes = [
        'jpg'
        'jpeg'
        'png'
        'gif'
        'bmp'
        'tiff'
      ]
      element.bind 'change', (changeEvent) ->
        for file in changeEvent.target.files
          extension = file.name.split('.').pop().toLowerCase()
          isSuccess = fileTypes.indexOf(extension) > -1
          if isSuccess
            reader = new FileReader()
            reader.onload = (loadEvent) ->
              scope.$apply ->
                scope.model.push { src: loadEvent.target.result }
            reader.readAsDataURL file
          else
            Flash.showError(scope, "Please select only image!")
  ]


  .directive 'inputProfileImageButton', ['Flash', (Flash)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_image_button.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

      fileTypes = [
        'jpg'
        'jpeg'
        'png'
        'gif'
        'bmp'
        'tiff'
      ]
      element.bind 'change', (changeEvent) ->
        for file in changeEvent.target.files
          extension = file.name.split('.').pop().toLowerCase()
          isSuccess = fileTypes.indexOf(extension) > -1
          if isSuccess
            reader = new FileReader()
            reader.onload = (loadEvent) ->
              scope.$apply ->
                scope.model = { src: loadEvent.target.result, changed: true }
            reader.readAsDataURL file
          else
            Flash.showError(scope, "Please select only image!")
  ]


  .directive 'inputImageButton', ['Flash', (Flash)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_image_button.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      fileTypes = [
        'jpg'
        'jpeg'
        'png'
        'gif'
        'bmp'
        'tiff'
      ]

      # hover effect for button
      element.find('input')
        .mouseenter ()->
          element.find('input').prev().addClass('hover')
        .mouseleave ()->
          element.find('input').prev().removeClass('hover')

      element.bind 'change', (changeEvent) ->
        for file in changeEvent.target.files
          extension = file.name.split('.').pop().toLowerCase()
          isSuccess = fileTypes.indexOf(extension) > -1
          if isSuccess
            reader = new FileReader()
            reader.onload = (loadEvent) ->
              scope.$apply ->
                scope.model = { src: loadEvent.target.result, changed: true }
            reader.readAsDataURL file
          else
            Flash.showError(scope, "Please select only image!")
  ]
  .directive 'inputImagesButton', ['Flash', (Flash)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_images_button.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      scope.model = []  unless scope.model
      scope.msgValidate = false
      fileTypes = [
        'jpg'
        'jpeg'
        'png'
        'gif'
        'bmp'
        'tiff'
      ]

      element.bind 'change', (changeEvent) ->
        for file in changeEvent.target.files
          extension = file.name.split('.').pop().toLowerCase()
          isSuccess = fileTypes.indexOf(extension) > -1
          if isSuccess
            reader = new FileReader()
            reader.onload = (loadEvent) ->
              scope.$apply ->
                scope.model.push { src: loadEvent.target.result }
                $('.msg-validate-photo').hide()
            reader.readAsDataURL file
          else
            Flash.showError(scope, "Please select only image!")
  ]

  .directive 'inputTime', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_time.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

      scope.options = []
      for h in [0..23]
        for min in [0, 30]
          time = ('0' + h).slice(-2) + ':' + ('0' + min).slice(-2)
          scope.options.push { name: time, value: time }

  .directive 'inputDatetime', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_datetime.html'
    scope:
      model: '='
      startDate: '@'
      endDate: '@'
      timeFrom: '@'
      timeTo: '@'
      minuteStep: '@'
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.linkId = 'link_' + scope.$id
      scope.required = attrs.required != undefined

      element.find('datetimepicker').prop 'datetimepickerConfig',
        dropdownSelector: '#' + scope.linkId
        minuteStep: 30

      # element.find('input').datetimepicker
      #   format: attrs.dateFormat
      #   autoclose: true

      # scope.$watch 'startDate', (newValue)->
      #   element.find('input').datetimepicker 'setStartDate', moment(newValue).toDate()

      # scope.$watch 'endDate', (newValue)->
      #   element.find('input').datetimepicker 'setEndDate', moment(newValue).toDate()

      scope.beforeRender = ($view, $dates, $leftDate, $upDate, $rightDate)->
        if $view == 'day'
          for date in $dates
            date.selectable = (scope.startDate == undefined || moment(date.utcDateValue) >= moment(scope.startDate)) && (scope.endDate == undefined || moment(date.utcDateValue) <= moment(scope.endDate))
        timeFrom = String('00000' + scope.timeFrom).slice(-5)
        timeTo = String('00000' + scope.timeTo).slice(-5)
        if $view == 'hour' || $view == 'minute'
          for hour in $dates
            time = moment(hour.utcDateValue).format('HH:mm')
            hour.selectable = not ((scope.timeFrom == undefined || time > timeFrom) && (scope.timeTo == undefined || time < timeTo))

      scope.onTimeSet = (newDate, oldDate)->
        $('#' + scope.linkId).dropdown('toggle')
        return

      # element.find('input').datetimepicker 'update', scope.model
      #   .on 'changeDate', (e)->
      #     scope.$apply ->
      #       scope.model = e.date

  .directive 'inputEmail', ['$timeout', ($timeout)->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_email.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      scope.disabled = attrs.disabled != undefined
      if attrs.focus != undefined
        $timeout ->
          element.find('input').focus()
  ]

  .directive 'inputPassword', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_password.html'
    scope: {
      model: '='
    }
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.elementConfirmationId = 'input_confirmation_' + scope.$id
      scope.required = attrs.required != undefined
      scope.confirmation = attrs.confirmation != undefined

      if scope.confirmation
        scope.data =
          confirmation: null
        scope.$watch 'data.confirmation', (newValue)->
          scope.form[scope.elementConfirmationId].$setValidity 'confirmation', scope.model == scope.data.confirmation
        scope.$watch 'model', (newValue)->
          scope.form[scope.elementConfirmationId].$setValidity 'confirmation', scope.model == scope.data.confirmation

  .directive 'inputBoolean', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input-boolean.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined

  .directive 'inputRadio', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input-radio.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.options = JSON.parse attrs.collection
      scope.required = attrs.required != undefined

      scope.data =
        model: null

      scope.$watch 'data.model', (newValue)->
        scope.model = newValue

  .directive 'inputPhone', ()->
    require: '^form'
    strict: 'E'
    templateUrl: 'directives/input_phone.html'
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' + scope.$id
      scope.required = attrs.required != undefined
      scope.focus = attrs.focus != undefined
      scope.hint = attrs.hint

      # IntlTelInput
      element.find('input').intlTelInput
        onlyCountries: ["fr"]
        initialCountry: "fr"
        preferredCountries: "fr"
  .directive 'inputCheckbox', ()->
    require: '^form'
    strict: 'E'
    templateUrl: "directives/input_checkbox.html"
    scope:
      model: '='
    replace: true
    link: (scope, element, attrs, form)->
      scope.form = form
      scope.label = attrs.label
      scope.elementId = 'input_' +scope.$id
      scope.data =
        model: null
      scope.$watch 'data.model', (newValue)->
        scope.model = newValue

