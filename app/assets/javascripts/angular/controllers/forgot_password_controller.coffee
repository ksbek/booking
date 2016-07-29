class ForgotPasswordController extends @NGController
  @register window.App, 'ForgotPasswordController'

  @$inject: [
    '$scope'
    '$uibModalInstance'
    'Auth'
    'Flash'
    '$rootScope'
  ]

  user:
    email: ''
    password: ''

  ok: ()=>
    @Auth
      .sendResetPasswordInstructions @scope.user, {}
      .then (user)=>
        @uibModalInstance.close(@scope.user)
        @Flash.showSuccess @scope, 'Instructions was sent successfully!'
      , (e)=>
        if e.data.error
          @Flash.showError @scope, e.data.error
        if e.data.errors
          angular.forEach e.data.errors, (v, k)=>
            @Flash.showError @scope, k.charAt(0).toUpperCase() + k.slice(1) + ': ' + v

  cancel: ()=>
    @uibModalInstance.dismiss('cancel')
