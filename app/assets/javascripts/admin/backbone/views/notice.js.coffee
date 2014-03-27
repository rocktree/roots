class Admin.Views.Notice extends Backbone.View

  el: '.notice'

  events:
    'click .close-notice': 'closeNotice'

  closeNotice: (e) =>
    e.preventDefault()
    $(@el).fadeOut()
