class Admin.Routers.Router extends Backbone.Router

  initialize: =>
    @autoLoad()

  autoLoad: =>
    new Admin.Views.Wysiwyg if $("[class*=_body]").length > 0
    new Admin.Views.Publishable if $("[class*=_active_date]").length > 0
    new Admin.Views.InitCounter if $('input').length > 0 and $('#login-form').length != 1
    new Admin.Views.Paginator if $('table').length > 0
    new Admin.Views.DropdownToggle if $('.dropdown-toggle').length > 0
    new Admin.Views.Notice if $('.notice').length > 0