angular
  .module 'enapparte'
  .directive 'deleteConfirm', ->
    priority: 100
    restrict: 'A'
    link: pre: (scope, element, attrs) ->
      msg = attrs.confirm or 'Are you sure?'
      element.bind 'click', (event) ->
        if !confirm(msg)
          event.stopImmediatePropagation()
          event.preventDefault
        return
      return
