({
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        //alert("Files uploaded : " + uploadedFiles.Id);
       // alert(uploadedFiles.Name);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        uploadedFiles.forEach(file => alert(file.Id));
        uploadedFiles.forEach(file => alert(file.name));
    }
})