angular
  .module 'enapparte'
  .controller 'MainController', ['$rootScope', '$scope', '$sanitize', '$uibModal', 'Auth', '$state', ($rootScope, $scope, $sanitize, $uibModal, Auth, $state)->

    $rootScope.Math = window.Math

    $scope.broadcast = (event)->
      $scope.$broadcast event

    $rootScope.range = (n)->
      new Array(n)

    $rootScope.isAuthenticated = ()->
      Auth.isAuthenticated()

    $rootScope.isPerformer = ()->
      Auth._currentUser.role in ["admin", "performer"]

    $rootScope.logout = ()->
      Auth.logout().then ()->
        $rootScope.currentUser = null
        $state.go 'home'

    $rootScope.$on('$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $state.current = toState

    $scope.isSearchPage = () ->
      $state.current.name == "shows.search" || $state.current.name == "artists.show"

    $scope.goPerformer = ->
      $state.go 'performer'
)
]
