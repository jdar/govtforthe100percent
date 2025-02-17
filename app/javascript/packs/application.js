// Vendor
import Rails from '@rails/ujs'
Rails.start()

require('jquery')
import 'bootstrap/dist/js/bootstrap'

// Views
import './views/travesties/index'
import './views/travesties/new'
import './views/travesties/travesties'
import './views/travesties/search'
import ApiDocs from './views/api/docs'

document.addEventListener('DOMContentLoaded', function() {
  if (document.getElementById('swagger-ui-container') != null ) { ApiDocs.loadSearch() }
})
