class ConceptController extends @NGController
  @register window.App, 'ConceptController'

  @$inject: [
    '$scope'
    '$uibModalInstance'
    'Auth'
    'Flash'
    '$rootScope'
  ]

  cancel: ()=>
    @uibModalInstance.dismiss('cancel')
