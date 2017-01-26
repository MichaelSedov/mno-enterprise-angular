@App.directive('mnoeReviewsList', ($filter, $log, $uibModal, MnoeReviews) ->
  restric:'E'
  scope: {
  }
  templateUrl:'app/components/mnoe-reviews-list/mnoe-reviews-list.html'
  link: (scope) ->

    scope.editmode = []
    scope.listOfReviews = []
    scope.statuses = ['approved', 'rejected']

    #====================================
    # Comment modal
    #====================================
    scope.openCommentModal = () ->
      $uibModal.open(
        templateUrl: 'app/components/mnoe-reviews-list/comment-modal.html'
        controller: 'CommentModal'
      )

    scope.openCommentEditModal = (review) ->
      $uibModal.open(
        templateUrl: 'app/components/mnoe-reviews-list/comment-edit-modal.html'
        controller: 'CommentEditModal'
        resolve:
          review: review
      ).result.then(
        (review) ->
          MnoeReviews.updateDescription(review).then(
            (response) ->
              console.log(response);
              # Remove the edit mode for this review
              #delete scope.editmode[review.id]
          )

      )

    scope.openCommentReplyModal = (review) ->
      $uibModal.open(
        templateUrl: 'app/components/mnoe-reviews-list/comment-reply-modal.html'
        controller: 'CommentReplyModal'
      ).result.then(
        (replyText) ->
          MnoeReviews.replyQuestion(review, replyText).then(
            (response) ->
              console.log(response)
              scope.listOfReviews.unshift(response.data.app_comment)
          )

      )

    fetchReviews = () ->
      return MnoeReviews.list().then(
        (response) ->
          scope.listOfReviews = response.data
      )

    scope.update = (review) ->
      MnoeReviews.updateRating(review).then(
        (response) ->
          # Remove the edit mode for this review
          delete scope.editmode[review.id]
      )

    fetchReviews()
    return
)
