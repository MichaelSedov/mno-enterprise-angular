angular.module 'mnoEnterpriseAngular'

#======================================================================================
# IMPAC-ROUTES: Configuring routes
#======================================================================================
.config((ImpacRoutesProvider, IMPAC_CONFIG) ->
  mnoHub = IMPAC_CONFIG.settings.paths.mnohub_api
  impacPrefix = "/impac"

  data =
    mnoHub: mnoHub
    impacPrefix: impacPrefix
    impacApi: "#{IMPAC_CONFIG.settings.protocol}://#{IMPAC_CONFIG.settings.host}/api"
    dashboards:
      index: "#{mnoHub}#{impacPrefix}/dashboards"
    widgets:
      index: "#{mnoHub}#{impacPrefix}/widgets"
      create: "#{mnoHub}#{impacPrefix}/dashboards/:dashboard_id/widgets"
    kpis:
      index: "#{mnoHub}#{impacPrefix}/kpis"
      create: "#{mnoHub}#{impacPrefix}/dashboards/:dashboard_id/kpis"
      update: "#{mnoHub}#{impacPrefix}/kpis/:id"
      del: "#{mnoHub}#{impacPrefix}/kpis/:id"
    alerts:
      index: "#{mnoHub}#{impacPrefix}/alerts"
      create: "#{mnoHub}#{impacPrefix}/kpis/:kpi_id/alerts"
      del: "#{mnoHub}#{impacPrefix}/alerts/:id"

  ImpacRoutesProvider.configureRoutes(data)
)

#======================================================================================
# IMPAC-THEMING: Configuring colour theme, layout, labels, descriptions, and features
#======================================================================================
.config((ImpacThemingProvider) ->
  options =
    dataNotFoundConfig:
      linkUrl: '#/marketplace'
    dhbErrorsConfig:
      firstTimeCreated:
        note: ''

  ImpacThemingProvider.configure(options)
)

#======================================================================================
# IMPAC-ASSETS: Configuring assets
#======================================================================================
.config((ImpacAssetsProvider) ->
  options =
    defaultImagesPath: '/dashboard/images'

  ImpacAssetsProvider.configure(options)
)

#======================================================================================
# IMPAC-LINKING: Configuring linking
#======================================================================================
.run((ImpacLinking, ImpacConfigSvc, IMPAC_CONFIG) ->
  data =
    user: ImpacConfigSvc.getUserData
    organizations: ImpacConfigSvc.getOrganizations

  pusher_key = IMPAC_CONFIG.keys.pusher_client

  angular.merge(data, {pusher_key: pusher_key}) if pusher_key

  ImpacLinking.linkData(data)
)
