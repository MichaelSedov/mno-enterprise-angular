angular.module 'mnoEnterpriseAngular'
  .service('greeting', ->
    greeting = this
    greeting.message = 'Default')
  .controller('DashboardMarketplaceCtrl', (MnoeMarketplace, greeting) ->
    'ngInject'

    vm = this
    vm.greeting = greeting

    #====================================
    # Initialization
    #====================================
    vm.isLoading = true
    vm.selectedCategory = ''
    vm.searchTerm = ''

    #====================================
    # Scope Management
    #====================================
    vm.linkFor = (app) ->
      "#/marketplace/#{app.id}"

    vm.appsFilter = (app) ->
      if (vm.searchTerm? && vm.searchTerm.length > 0) || !vm.selectedCategory
        return true
      else
        return _.contains(app.categories, vm.selectedCategory)


    #====================================
    # Calls
    #====================================
    MnoeMarketplace.getApps().then(
      (response) ->
        # Remove restangular decoration
        response = response.plain()

        vm.categories = response.categories
        vm.apps = response.apps

        vm.isLoading = false
    )

    return
)
