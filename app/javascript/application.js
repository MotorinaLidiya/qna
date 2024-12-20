import $ from 'jquery'
import gon from 'gon';
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import 'bootstrap'
import '@oddcamp/cocoon-vanilla-js'

window.gon = gon;
import './channels/questions'
import './channels/answers'
// import './channels/comments'
import './utilities/answers'
import './utilities/questions'
import './utilities/reactions'
import "../assets/stylesheets/application.scss";

Rails.start()
ActiveStorage.start()
window.$ = window.jQuery = $
