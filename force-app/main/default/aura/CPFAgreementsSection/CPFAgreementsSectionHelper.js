({
    updateOppFormStatus : function(component, formStatus) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOppFormStatus");
        action.setParams({
            formStatus: formStatus,
            oppId: recordId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    //helper.fireToast("Success!", "Draft document generated successfully.", "success");
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to update Form Status field Failed. Error : [' + JSON.stringify(errors) + ']');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            } else {
                console.log('Callback to update Form Status field Failed.');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    generateCPFDocument : function(component, docName) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.generateDoc");
        action.setParams({
            oppId: recordId,
            templatename: docName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue.success == "true")
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": docName + " document successfully generated.",
                        "type":"success"
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error generating document " + docName,
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to generateDoc Failed. Error : [' + JSON.stringify(errors) + ']');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            } else {
                console.log('Callback to generateDoc Failed.');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchDocuments: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentList");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                    var nm = data.Name;
                    if (component.get("v.draftDocStatus") == 'Need file, Incomplete' && nm.includes("Draft")) {
                        component.set("v.draftDocStatus","No signature needed, complete");
                    }
                    if (component.get("v.pendingCreditApprovalDocStatus") == 'Need file, Incomplete' && nm.includes("Pending Credit Approval")) {
                        component.set("v.pendingCreditApprovalDocStatus","No signature needed, complete");
                    }
                    if (component.get("v.creditApprovalDocStatus") == 'Need file, Incomplete' && nm.includes("Credit Approved")) {
                        component.set("v.creditApprovalDocStatus","No signature needed, complete");
                    }
                    if (component.get("v.standardDocStatus") == 'Need file, Incomplete' && nm.includes("MBBL Standard Terms")) {
                        component.set("v.standardDocStatus","No signature needed, complete");
                    }
                });
                component.set("v.dataAudit", data);
                this.defaultSortData(component, 'v.dataAudit');
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    /**
        * @description download function to download file from ECM.
        **/
    download: function (cmp, row) {
        cmp.set('v.showSpinner', true);
        var action = cmp.get('c.getDocumentContent');
        action.setParams({
            "documentId": row.Id
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', row.Name);
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);
            } else {
                console.log("Download failed ...");
            }
            cmp.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },

    sortBy: function(field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },

    sortData: function(cmp, event,dtName) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var DATA = cmp.get(dtName);
        var cloneData = DATA.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        cmp.set(dtName, cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },

    defaultSortData: function(cmp,dtName) {
        var sortedBy = 'CreatedDate';
        var sortDirection = 'desc';
        var DATA = cmp.get(dtName);
        var cloneData = DATA.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        cmp.set(dtName, cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },

      getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);

                if (getprodNamelst[0].Product_Name__c == 'CPF Development Loan') {
                    var action2 = component.get("c.getSingleOrMultiPhase");
                    action2.setParams({
                        "oppId": component.get("v.recordId"),
                    });
                    action2.setCallback(this, function(response) {
                        var state2 = response.getState();
                        if (state2 === "SUCCESS"){
                            var singleOrMulti = response.getReturnValue();
                            component.set("v.singleOrMulti",singleOrMulti);
                        }
                    });
                    $A.enqueueAction(action2);
                }

            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });
        $A.enqueueAction(action);
    },

    allowWOrdDocGen : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.enableWordDocGen");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set('v.enableWordDocGen',responseValue);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
})