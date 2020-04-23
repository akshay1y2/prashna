json.head t('.header_new')
json.body t('.body_new', size: @notifications.size, link: "<a href='/'>click here</a>")
