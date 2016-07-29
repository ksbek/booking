angular
  .module 'enapparte'
  .controller 'TabsController', ($scope)->

    $scope.tabs =
      [
        { heading: 'Dashboard', route: 'dashboard.index' }
        { heading: 'Profil', route: 'dashboard.profile.personal', routeActive: 'dashboard.profile' }
        { heading: 'Messages', route: 'dashboard.messages' }
        { heading: 'Mes performances', route: 'dashboard.performances.current', routeActive: 'dashboard.performances' }
        { heading: 'Mes réservations', route: 'dashboard.reservations.current', routeActive: 'dashboard.reservations' }
        { heading: 'Compte', route: 'dashboard.account.payment', routeActive: 'dashboard.account' }
      ]

    $scope.panes = []

    $scope.selectPane = (pane)->
      for p in $scope.panes
        p.active = false
      pane.active = true

    addPane: (pane)->
      pane.active = true  if $scope.panes.length == 0
      $scope.panes.push pane


