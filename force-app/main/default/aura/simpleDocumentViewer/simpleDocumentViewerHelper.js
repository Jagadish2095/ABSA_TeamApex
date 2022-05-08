({
    
    /**
    * @description function to show spinner.
    **/
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    /**
    * @description function to hide spinner.
    **/   
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    fetchAuditData: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocAuditHistoryEmail");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                //console.log('data:' + data);
                
                data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                });
                component.set("v.dataAudit", data);
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
    
})