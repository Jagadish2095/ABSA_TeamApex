({
	fetchAuditData: function (component) {
        console.log('Covenant Id ' + component.get("v.recordId"));
        var action = component.get("c.getDocAuditHistoryEmail");
        
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data:' + data);
               
                	data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                      
                	});
                	component.set("v.dataAudit", data);
               
            }
            else {
                console.log("Failed with state: " + state);
            }
           // component.set("v.showSpinner", false);
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
    
    updateDocumentContent : function(component, helper, row){
       component.set('v.showSpinner', true);
        
       var action = component.get('c.updateDocumentContent');
        action.setParams({
            "documentId": row.Id 
        });
        
         action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                 component.set('v.showSpinner', false);
                 
                 var data = response.getReturnValue();
                 var toastEvent
                 if(data == 'Success'){
                   toastEvent = helper.getToast('Success','The document has been deleted successfully' ,'Success');
                   toastEvent.fire();
                   helper.fetchAuditData(component);
                 }else{
                    toastEvent = helper.getToast('Error',data ,'Error');
                    toastEvent.fire();
                 }
                 
             }else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toast = this.getToast("Error", errors[0].message, "error");
               			toast.fire();
                    }
                }
             }
          }));
         $A.enqueueAction(action);
        
    },
    
    getAccountId : function(component){
        var covenantId = component.get('v.recordId');
        var action = component.get("c.getAccountId");
        
        action.setParams({
            "covenantId": covenantId 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                var data = response.getReturnValue();
                console.log("Results -->" , data);
                component.set("v.recordId", data);
            }
            else {
                console.log("Failed with state: " + state);
            }
            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    	 //Show lightning spinner
	showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
        
		 var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        
        return toastEvent;
	}
})