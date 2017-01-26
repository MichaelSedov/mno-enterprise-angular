# Service for managing the comments and reviews.
@App.service 'MnoeReviews', (MnoeAdminApiSvc) ->
  _self = @

  # GET List /mnoe/jpi/v1/admin/app_reviews
  @list = () ->
    MnoeAdminApiSvc.all('app_reviews').getList().then(
      (response) ->
        response
      (error) ->
        # Display an error
        $log.error('Error while fetching reviews', error)
        toastr.error('An error occured while fetching the reviews.')
    )

  # UPDATE /mnoe/jpi/v1/admin/app_reviews/1
  @updateRating = (review) ->
    promise = MnoeAdminApiSvc.one('app_reviews', review.id).patch({status: review.status}).then(
      (response) ->
        response
      (error) ->
        # Display an error
        $log.error('Error while updating review', error)
        toastr.error('An error occured while updating the review.')
    )

  @updateDescription = (review) ->
    promise = MnoeAdminApiSvc.one('app_reviews', review.id).patch({description: review.description}).then(
      (response) ->
        response
      (error) ->
        # Display an error
        $log.error('Error while updating review', error)
        toastr.error('An error occured while updating the review.')
    )

  @replyQuestion = (review, replyText) ->
    promise = MnoeAdminApiSvc.all("/app_answers").post({app_answer: {description: replyText, question_id: review.id, organization_id: review.organization_id}}).then(
      (response) ->
        response
      (error) ->
        # Display an error
        $log.error('Error while updating review', error)
        toastr.error('An error occured while updating the review.')
    )

  return @
