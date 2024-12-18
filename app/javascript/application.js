import $ from 'jquery'
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import 'bootstrap'
import '@oddcamp/cocoon-vanilla-js'

import './channels/questions'
import './utilities/answers'
import './utilities/questions'
import './utilities/reactions'
import "../assets/stylesheets/application.scss";

Rails.start()
ActiveStorage.start()
window.$ = window.jQuery = $
