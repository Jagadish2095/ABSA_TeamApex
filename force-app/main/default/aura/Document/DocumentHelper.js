({
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    fetchData: function (cmp) {
        var action = cmp.get('c.getDocumentList');
        console.log("AssetId: " + cmp.get("v.recordId"));
        action.setParams({
            "parentId": cmp.get("v.recordId"), "parentFieldName": "AssetId__c" 
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(JSON.parse(response.getReturnValue()) != null) {               
                    cmp.set('v.columns', [
                        { label: 'Document Name', fieldName: 'Name', type: 'text'},
                        { label: 'Type', fieldName: 'Type__c', type: 'text'},
                        { label: 'Reference', fieldName: 'Reference__c', type: 'text'},
                        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date',
                                            typeAttributes: {
                                                weekday: 'short',
                                                year: 'numeric',
                                                month: 'short',
                                                day: 'numeric',
                                                hour: '2-digit',
                                                minute: '2-digit'
                                            }},
                        {type: "button", typeAttributes: {
                            label: 'Download',
                            name: 'Download',
                            title: 'Download',
                            disabled: false,
                            value: 'download',
                            iconPosition: 'left'
                        }}
                    ]);
                    cmp.set('v.data', JSON.parse(response.getReturnValue()));
                } else {
                    cmp.set("v.noResults", "No records to display");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                cmp.set("v.noResults", "An error occurred: No records to display");
            }
        }));
        $A.enqueueAction(action);
    },
    
    download: function (cmp, row) {
    	cmp.set('v.showSpinner', true);
        var action = cmp.get('c.getDocumentContent');
        action.setParams({
            "docId": row.Id 
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var byteCharacters = atob(data);
                var byteNumbers = new Array(byteCharacters.length);
                for (var i = 0; i < byteCharacters.length; i++) {
                    byteNumbers[i] = byteCharacters.charCodeAt(i);
                }
                var byteArray = new Uint8Array(byteNumbers);
                var blob = new Blob([byteArray], {
                    type: 'application/pdf'
                });
                var source = URL.createObjectURL(blob);
                var element = document.createElement('a');
                element.setAttribute('href', source);
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
    
    refresh: function(cmp) {
        console.log("Refreshing documents ...");
        cmp.set('v.showSpinner', true);
        var action = cmp.get('c.refreshDocuments');
        action.setParams({
            "parentId": cmp.get("v.recordId")
        });    	
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(JSON.parse(response.getReturnValue()) != null) {
                    cmp.set('v.columns', [
                        { label: 'Document Name', fieldName: 'Name', type: 'text'},
                        { label: 'Type', fieldName: 'Type__c', type: 'text'},
                        { label: 'Reference', fieldName: 'Reference__c', type: 'text'},
                        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date',
                                            typeAttributes: {
                                                weekday: 'short',
                                                year: 'numeric',
                                                month: 'short',
                                                day: 'numeric',
                                                hour: '2-digit',
                                                minute: '2-digit'
                                            }}, 
                        {type: "button", typeAttributes: {
                            label: 'Download',
                            name: 'Download',
                            title: 'Download',
                            disabled: false,
                            value: 'download',
                            iconPosition: 'left'
                        }}
                    ]);
                    cmp.set('v.data', JSON.parse(response.getReturnValue()));
                } else {
                    cmp.set("v.noResults", "No records to display");
                }
            }
            cmp.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);   
    }
})