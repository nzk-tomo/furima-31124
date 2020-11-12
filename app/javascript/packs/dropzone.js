(function() {
  var myDropzone;
  Dropzone.autoDiscover = false;
  Dropzone.options.myAwesomeDropzone = {
    paramName: "file",
    parallelUploads: 1,
    acceptedFiles: 'image/*',
    maxFiles: 10,
    maxFilesize: 0.5,
    dictFileTooBig: "uploaded file is too large({{ilesize}}MiB). limit: {{maxFilesize}}MiB.",
    dictInvalidFileType: "Image file only",
    dictMaxFilesExceeded: "10 files limit"
  };
  myDropzone = new Dropzone(".drag-and-drop-area", {
    url: "/images/async_upload"
  });
  return ('.drag-and-drop-area').on({
    click: function(e) {
      return ('#file_input').click();
    },
    mouseover: function(e) {
      (this).removeClass('drag-and-drop-area-out');
      return (this).addClass('drag-and-drop-area-over');
    },
    mouseout: function(e) {
      (this).removeClass('drag-and-drop-area-over');
      return (this).addClass('drag-and-drop-area-out');
    },
    dragover: function(e) {
      (this).removeClass('drag-and-drop-area-out');
      return (this).addClass('drag-and-drop-area-over');
    },
    dragleave: function(e) {
      (this).removeClass('drag-and-drop-area-over');
      return (this).addClass('drag-and-drop-area-out');
    }
  });
});