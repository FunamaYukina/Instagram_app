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


$(function () {
    fileField = $('#file');
    preview = $('#img_field');

    $(fileField).on('change', fileField, function (e) {
        file = e.target.files[0];
        reader = new FileReader(),
            reader.onload = (function (file) {
                return function (e) {
                    preview.empty();
                    preview.append($('<img>').attr({
                        src: e.target.result,
                        width: "140px",
                        class: "preview",
                        title: file.name
                    }));
                };
            })(file);
        reader.readAsDataURL(file);
    });

    $("#delete").click(()=>{
        preview.empty();
    })
});
$(function () {
    fileInput = $('#profile_file');
    previewProfile = $('#profile_img_field');

    $(fileInput).on('change', fileInput, function (e) {
        file = e.target.files[0];
        reader = new FileReader(),
            reader.onload = (function (file) {
                return function (e) {
                    previewProfile.empty();
                    previewProfile.append($('<img>').attr({
                        src: e.target.result,
                        width: "50px",
                        height: "50px",
                        title: file.name,
                        style:'border-radius:25px;'
                    }));
                };
            })(file);
        reader.readAsDataURL(file);
    });
});