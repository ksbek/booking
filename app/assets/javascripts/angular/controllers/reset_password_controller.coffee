class ResetPasswordController extends @NGController
  @register window.App, 'ResetPasswordController'

  @$inject: [
    '$scope'
    '$uibModalInstance'
    'Auth'
    'Flash'
    '$rootScope'
    '$stateParams'
    '$state'
  ]

  user:
    email: ''
    password: ''

  ok: ()=>
    @scope.user.reset_password_token = @stateParams.reset_password_token
    @Auth
      .resetPassword @scope.user, {}
      .then (user)=>
        @uibModalInstance.close(@scope.user)
        @Flash.showSuccess @scope, 'Password was changed successfully!'
      , (e)=>
        if e.data.error
          @Flash.showError @scope, e.data.error
        if e.data.errors
          angular.forEach e.data.errors, (v, k)=>
            @Flash.showError @scope, k.charAt(0).toUpperCase() + k.slice(1) + ': ' + v

  cancel: ()=>
    @uibModalInstance.dismiss('cancel')
