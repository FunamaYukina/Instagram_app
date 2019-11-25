// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require_tree .

const readImage = (fileField, preview, options) => {
    $(fileField).on('change', fileField, function (e) {
        file = e.target.files[0];
        reader = new FileReader(),
            reader.onload = (function (file) {
                return function (e) {
                    preview.empty();
                    let attributes = {
                        src: e.target.result,
                        title: file.name
                    }
                    preview.append($('<img>').attr(Object.assign(attributes, options)));
                };
            })(file);
        reader.readAsDataURL(file);
    });
}

$(function () {
    var fileField = "";
    var preview = "";
    var options = {};
    if ($('#top_page').length) {
        fileField = $('#post_file');
        preview = $('#post_image');
        options = {
            width: "140px",
            class: "preview",
        };
        $("#delete").click(() => {
            preview.empty();
            fileField.remove();
        })
    } else if ($('#profile_file').length) {
        fileField = $('#profile_file');
        preview = $('#profile_image');
        options={
            width: "50px",
            height: "50px",
            style: 'border-radius:25px;'
        }
    } else {
        return
    }
    readImage(fileField, preview, options);
});