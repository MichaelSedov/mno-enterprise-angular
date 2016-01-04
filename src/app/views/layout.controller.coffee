angular.module 'mnoEnterpriseAngular'
  .controller 'LayoutController', ($stateParams, $location, MnoeCurrentUser, MnoeOrganizations, MnoeMarketplace) ->
    'ngInject'

    layout = this

    # App initialization
    MnoeCurrentUser.get().then(
      (response) ->
        # Load the current organization if defined (url param, cookie or first)
        MnoeOrganizations.getCurrentId(response, $stateParams.dhbRefId)

        # Pre-load the market place
        MnoeMarketplace.getApps()

        # Remove param from url
        $location.search('dhbRefId', null)
    )

    return
