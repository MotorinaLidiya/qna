import $ from 'jquery'
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
ActiveStorage.start()
window.$ = window.jQuery = $
