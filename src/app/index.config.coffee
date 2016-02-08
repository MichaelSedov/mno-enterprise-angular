angular.module 'mnoEnterpriseAngular'

  .config(($logProvider, toastrConfig) ->
    'ngInject'

    # Enable log
    $logProvider.debugEnabled true
    # Set options third-party lib
    toastrConfig.allowHtml = true
    toastrConfig.timeOut = 3000
    toastrConfig.positionClass = 'toast-top-right'
    toastrConfig.preventDuplicates = true
    toastrConfig.progressBar = true
  )

  .config(($httpProvider) ->
    'ngInject'

    $httpProvider.defaults.headers.common['Accept'] = 'application/json'
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'

    if token = $("meta[name='csrf-token']").attr("content")
      $httpProvider.defaults.headers.common['X-CSRF-Token'] = token

    return $httpProvider
  )

  .config ($httpProvider) ->
    $httpProvider.interceptors.push ($q, $window) ->
      {
        responseError: (rejection) ->
          if rejection.status == 401
            # Redirect to login page
            console.log "User is not connected!"
            $window.location.href = '/'

          $q.reject rejection
      }

  .config(($sceDelegateProvider) ->
    'ngInject'

    # Configure SCE to authorize the Maestrano domains
    # (see: https://docs.angularjs.org/api/ng/provider/$sceDelegateProvider)
    $sceDelegateProvider.resourceUrlWhitelist([
      # Allow same origin resource loads.
      'self'
    ])
  )

  .config(($translateProvider, LOCALES) ->
    # Path to translations files
    $translateProvider.useStaticFilesLoader({
      prefix: 'locales/',
      suffix: '.locale.json'
    })

    $translateProvider.preferredLanguage(LOCALES.preferredLocale)
    $translateProvider.fallbackLanguage(LOCALES.fallbackLanguage)
    $translateProvider.useSanitizeValueStrategy('sanitizeParameters')
    $translateProvider.useMissingTranslationHandlerLog()
    $translateProvider.useLocalStorage()
  )

  #======================================================================================
  # IMPAC-ROUTES: Configuring routes
  #======================================================================================
  .config (ImpacRoutesProvider, IMPAC_CONFIG) ->
    data =
      showWidgetPath: "#{IMPAC_CONFIG.protocol}://#{IMPAC_CONFIG.host}#{IMPAC_CONFIG.paths.get_widget}"
      impacKpisBasePath: "#{IMPAC_CONFIG.protocol}://#{IMPAC_CONFIG.host}#{IMPAC_CONFIG.paths.kpis}"
      localKpisBasePath: "/mnoe/impac/v2/kpis"

    ImpacRoutesProvider.configureRoutes(data)