// Vendor
import Rails from '@rails/ujs'
Rails.start()

require('jquery')
import 'bootstrap/dist/js/bootstrap'

// Views
import './views/experiences/index'
import './views/experiences/new'
import './views/experiences/experiences'
import './views/experiences/search'
import ApiDocs from './views/api/docs'

document.addEventListener('DOMContentLoaded', function () {
  if (document.getElementById('swagger-ui-container') != null) { ApiDocs.loadSearch() }
})
