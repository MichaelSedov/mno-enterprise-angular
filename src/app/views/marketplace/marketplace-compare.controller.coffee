angular.module 'mnoEnterpriseAngular'
  .controller('DashboardMarketplaceCompareCtrl', ($q, $scope, $stateParams, $state,
    MnoeMarketplace, $uibModal, MnoeOrganizations, MnoeCurrentUser, MnoeAppInstances, MnoErrorsHandler, REVIEWS_CONFIG, PRICING_CONFIG) ->

      vm = this

      vm.app = {}
      # The already installed app instance of the app, if any
      vm.appInstance = null
      # An already installed app, conflicting with the app because it contains a common subcategory
      # that is not multi instantiable, if any
      vm.conflictingApp = null

      vm.isPriceShown = PRICING_CONFIG && PRICING_CONFIG.enabled

      #====================================
      # Initialization
      #====================================
      vm.isLoading = true

      currency = (PRICING_CONFIG && PRICING_CONFIG.currency) || 'AUD'
      vm.pricing_plans = [currency] || 'AUD' || 'default'

      vm.appInstallationStatus = () ->
        if vm.appInstance
          if vm.app.multi_instantiable
            "INSTALLABLE"
          else
            if vm.app.app_nid != 'office-365' && vm.app.stack == 'connector' && !vm.app.oauth_keys_valid
              "INSTALLED_CONNECT"
            else
              "INSTALLED_LAUNCH"
        else
          if vm.conflictingApp
            "CONFLICT"
          else
            "INSTALLABLE"

      vm.provisionApp = () ->
        vm.isLoadingButton = true
        MnoeAppInstances.clearCache()

        # Get the authorization status for the current organization
        if MnoeOrganizations.role.atLeastPowerUser(vm.user_role)
          purchasePromise = MnoeOrganizations.purchaseApp(vm.app, MnoeOrganizations.selectedId)
        else  # Open a modal to change the organization
          purchasePromise = openChooseOrgaModal().result

        purchasePromise.then(
          ->
            $state.go('home.impac')

            switch vm.app.stack
              when 'cloud' then displayLaunchToastr(vm.app)
              when 'cube' then displayLaunchToastr(vm.app)
              when 'connector'
                if vm.app.nid == 'office-365'
                  # Office 365 must display 'Launch'
                  displayLaunchToastr(vm.app)
                else
                  displayConnectToastr(vm.app)
          (error) ->
            toastr.error(vm.app.name + " has not been added, please try again.")
            MnoErrorsHandler.processServerError(error)
        ).finally(-> vm.isLoadingButton = false)

      #====================================
      # Calls
      #====================================
      MnoeMarketplace.getApps().then(
        (response) ->
          response = response.plain()
          vm.apps = response.apps

          vm.isLoading = false
      )

      return
  )
