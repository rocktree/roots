class Admin.Views.Accordion extends Backbone.View

  el: 'body'
  collapsedIcon: 'icon-arrow-right'
  expandedIcon: 'icon-arrow-up'

  events:
    'click .accordion .trigger': 'initClick'
    'click .expand-all': 'expandAll'
    'click .collapse-all': 'collapseAll'

  initialize: =>
    @initTriggers()

  initTriggers: =>
    for li in $('.accordion li')
      child = $(li).find('ul > li')
      if child.length > 0
        $(li).prepend "<a href=\"#\" class=\"trigger #{@collapsedIcon}\"></a>"

  initClick: (e) =>
    e.preventDefault()
    target = $(e.target)
    target.toggleClass("active #{@collapsedIcon} #{@expandedIcon}")
    listItem = target.parent('li')
    listItem.children('ul').toggle()

  expandAll: (e) =>
    e.preventDefault()
    $('.accordion .trigger').addClass("active #{@expandedIcon}").removeClass("#{@collapsedIcon}")
    $('.accordion ul').show()

  collapseAll: (e) =>
    e.preventDefault()
    $('.accordion .trigger').removeClass("active #{@expandedIcon}").addClass("#{@collapsedIcon}")
    $('.accordion ul').hide()
