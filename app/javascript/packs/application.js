// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "jquery";
import "bootstrap";

//= require i18n
//= require i18n.js
//= require i18n/translations
//= require localization
//= require turbolinks

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import I18n from "i18n-js";
window.I18n = I18n;

$(function () {
  $(document).on("turbolinks:load", function () {
    $("#micropost_image").bind("change", function () {
      var size_in_megabytes = this.files[0].size / 1024 / 1024;
      if (size_in_megabytes > Settings.img.size_limit) {
        alert(I18n.micropost.img_alert);
      }
    });
  });
});
