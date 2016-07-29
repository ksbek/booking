# Directive that allows only integer values for input

'use strict;'

angular.module 'enapparte'
  .directive 'inputAllowInteger', [
    () ->
      restrict: 'A'
      link: (scope, element) ->
        element.on 'keydown', (event) ->
          # Allow only backspace and delete
          if event.keyCode is 46 or event.keyCode is 8
            # let it happen, don't do anything
          else
            # Ensure that it is a number and stop the keypress
            if event.keyCode < 48 or event.keyCode > 57
              event.preventDefault()
  ]
