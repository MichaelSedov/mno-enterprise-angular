angular.module 'frontendAdmin'
.controller('CommentReplyModal', ($scope, $uibModalInstance) ->

  $scope.replyText = ''

  # Close the current modal
  $scope.closeModal = ->
    $uibModalInstance.dismiss()

  $scope.submitIteraction = ->
    $uibModalInstance.close($scope.replyText)

  return
)
