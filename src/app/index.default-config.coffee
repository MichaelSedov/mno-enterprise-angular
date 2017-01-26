# For backward compatibility with the mnoe backend
# Define null/default values for all the constants so that if the backend hasn't been upgraded
# to define this constants you don't get errors like:
#   Uncaught Error: [$injector:unpr] Unknown provider: INTERCOM_IDProvider <- INTERCOM_ID <- AnalyticsSvc
angular.module('mnoEnterprise.defaultConfiguration', [])
  .constant('IMPAC_CONFIG', {})
  .constant('I18N_CONFIG', {})
  .constant('PRICING_CONFIG', {enabled: true})
  .constant('DOCK_CONFIG', {enabled: true})
  .constant('DEVELOPER_SECTION_CONFIG', compare: {enabled: false})
  .constant('MARKETPLACE_CONFIG', {enabled: true})
  .constant('GOOGLE_TAG_CONTAINER_ID', null)
  .constant('APP_NAME', null)
  .constant('INTERCOM_ID', null)
