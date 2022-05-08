({
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
	},
    
    fetchAuditData : function (component) {
        //console.log('Fetch Data');
        //console.log('Data 0-------->'+  component.get("v.documentsUploaded"));
        //console.log('Covenant Id ' + component.get("v.recordId"));
        var action = component.get("c.getDocAuditHistoryEmail");
        
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data:' + data);
                //component.set("v.dataAuditList", data);
                console.log('Data 1-------->'+ component.get("v.dataAuditList").length);
                console.log('Documents is uploaded-------->'+ component.get("v.documentsUploaded"));
                if(data.length > 0){
                    //alert('Inside Response');
                    component.set("v.documentsUploaded", true);
                 }
                    
            }
            else {
                console.log("Failed with state: " + state);
            }
          
        });
            $A.enqueueAction(action);
        },
        
    invokeProcess : function(component,helper){
        console.log('invokeProcess');
        var documentsUploaded = component.get("v.documentsUploaded");
		var action = component.get("c.invokeApprovalProcess");
        var covenantId = component.get("v.recordId");
        var covonentStatus = component.find('icovenantStaus').get('v.value');
        var reason = component.find('icovenantStatusReason').get('v.value');
        var approverId = component.find("AreaManagerCoverage").get("v.value")
        
        if(approverId == null || approverId == ''){
            var toast = helper.getToast("Validation Warning", "Area Coverage Manager Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null; 
        }
        
        if(covonentStatus == null || covonentStatus == ''){
            var toast = helper.getToast("Validation Warning", "Covenant Status Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null; 
        }
        
        if(reason == null || reason == ''){
            var toast = helper.getToast("Validation Warning", "Reason Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null; 
        }
        //console.log('Documents Validation' + docList.length);
        //alert('hi ' + documentsUploaded);
        if(!documentsUploaded){
            var toast = helper.getToast("Validation Warning", "Documents Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        action.setParams({covanentId:covenantId , covonentStatus : covonentStatus ,reason : reason , approverId:approverId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                console.log('-----SUCCESS-----'); 
                var toast = this.getToast("Success", "Covenant successfully submitted for approval", "Success");
            	helper.hideSpinner(component);
            	toast.fire();
            	return null;
            } else if(state === "ERROR"){ 
                helper.hideSpinner(component);
                console.log('Error');
                
                helper.hideSpinner(component);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toast = this.getToast("Error", errors[0].message, "error");
               			toast.fire();
                    }
                }
            } 
        });
        $A.enqueueAction(action);
    }
})