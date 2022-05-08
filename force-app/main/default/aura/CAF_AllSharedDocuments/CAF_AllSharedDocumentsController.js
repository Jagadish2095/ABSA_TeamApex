({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Document Type Requested', fieldName: 'documentTypeRequested', type: 'text'},
            {label: 'Document Selected', fieldName: 'documentSelected', type: 'text'},
            {label: 'Source', fieldName: 'source', type: 'text'},
            {label: 'Required', fieldName: 'required', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Updated', fieldName: 'updated', type: 'text'}
        ]);

        var fetchData = {
            documentTypeRequested: "Bank Statement of Applicant",
            documentSelected : "Document 4",
            source : "Uploaded",
            required : "YES",
            status: "No signature needed, Complete",
            updated : "28 May 2020"        
        };


        //helper.fetchData(cmp, fetchData, 10);
    }
});