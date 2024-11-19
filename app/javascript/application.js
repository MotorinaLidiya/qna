import $ from 'jquery'
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import 'bootstrap'
import '@oddcamp/cocoon-vanilla-js'

import './utilities/answers'
import './utilities/questions'
import "../assets/stylesheets/application.scss";

Rails.start()
ActiveStorage.start()
window.$ = window.jQuery = $
