({
    openModal : function(component, event, helper) {
		component.set('v.isModalOpen',true);
	},
    closeModal : function(component, event, helper) {
		component.set('v.isModalOpen',false);
	},
    doInit: function(component, event, helper) {
        var actions = [
            { label: "Download", name: "download" },
            { label: "Upload", name: "upload" }
        ];
       /* component.set("v.columns", [
            { label: "Field Name", fieldName: "missingData", type: "text" },
            { label: "Issue", fieldName: "issue", type: "text" },
            { label: "Required", fieldName: "required", type: "text" },
            { label: "Source", fieldName: "source", type: "text" },
            { label: "Document Name", fieldName: "name", type: "text" },
            { type:  'action', typeAttributes: { rowActions: actions }}
        ]); */
        component.set("v.columns", [
            { label: "Client's Missing Info", fieldName: "missingData", type: "text" },
            { label: "Missing Documents", fieldName: "missingDoc", type: "text" },
            { label: "Required", fieldName: "required", type: "text" },
            { label: "Source", fieldName: "source", type: "text" },
            { label: "Status", fieldName: "status", type: "text" },
            { type:  'action', typeAttributes: { rowActions: actions }}
        ]);
        helper.fetchData(component);
    },

//To scroll down to FICA requirements section on clicking the compliance status tile on Dashboard
    clickHandler: function(component, event, helper) {
        var element = document.getElementById("Target");
        var rect = element.getBoundingClientRect();
        scrollTo({top: rect.top, behavior: "smooth"});
    },

//Get column headers and fields server side controller
    getColumnHeaders: function(component, event, helper) {
        helper.getClientFieldSet(component, event);
    },
    //Hl_navigate
    navigatetoAttest: function(component, event, helper) {

        helper.attestCustomer(component, event,helper);
    },

//To handle the row actions of Lightning Data Table displayed in FICA Requirements Section
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        var missingData = row.missingData;
        //var issue = row.issue;
        var missingDoc = row.missingDoc;


        switch (action.name) {
           /* case 'download':
                if( issue == 'Missing Document' || issue == 'Reusable Document' || issue == 'Refreshable Document') {
                    helper.download(cmp, row);
                    break;
                } else{
                    var message = 'You Can Only Download Client\'s Documents';
                    var type = 'info';
                    helper.showToast(cmp, event, message, type);
                    break;
                }  */
                case 'download':
                if( missingDoc != '' && missingDoc != '--' ) {
                    helper.download(cmp, row);
                    break;
                } else{
                    var message = 'You Can Only Download Client Missing Documents';
                    var type = 'info';
                    helper.showToast(cmp, event, message, type);
                    break;
                }
                case 'upload':
                if( missingDoc != '' && missingDoc != '--') {
                    cmp.set("v.isTrue", true);
                    cmp.set("v.fileType", missingDoc);
                    break;
                } else{
                    var message = 'You Can Only Upload Client Missing Documents';
                    var type = 'info';
                    helper.showToast(cmp, event, message, type);
                    break;
                }
           /* case 'upload':
                if( issue == 'Missing Document') {
                    cmp.set("v.isTrue", true);
                    cmp.set("v.fileType", missingData);
                    break;
                } else{
                    var message = 'You Can Only Upload Client\'s Missing Documents';
                    var type = 'info';
                    helper.showToast(cmp, event, message, type);
                    break;
                }  */
        }
    },

//To submit conflictiong information details
    submitDetails : function(component, event, helper) {
        var CIF = component.get("v.selectedCIFAddress");
        var goldenSource = component.get("v.selectedGoldenSourceAddress");
        if(CIF != null || goldenSource != null){
      		helper.callCIFService(component);
        }else{
            var message = 'Please Select An Address To Resolve Conflicts';
            var type = 'info';
            helper.showToast(component, event, message, type);
        }
    },

//To Open/Close the upload the missing/reusable/refreshable document functionality
    closeModel : function(component, event, helper) {
        component.set("v.isTrue",false);
        component.set("v.fileName", 'No File Selected..');
    },

//To handle the file change in the upload missing/reusable/refreshable document section
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },

//To save the uploaded missing/reusable/refreshable document
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select A Valid File');
            component.set("v.fileName", 'No File Selected..');
        }
    },

//To display Attest Client button in the bottom right of the dashboard
    initiateRefresh : function(component, event, helper) {
        component.set("v.isShowInit",true);
    },

//To display Remediate Client button in the bottom right of the FICA
    initiateRemediate : function(component, event, helper) {
        component.set("v.isShowRemediate",true);
    },
})