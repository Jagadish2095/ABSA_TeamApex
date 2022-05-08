({
	 getDocumentData : function (component, event,helper, docId)  {
       
        var action = component.get("c.getDocumentContent");
        action.setParams({
            "docId": docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('Data :' + data);
                var data = response.getReturnValue();
                console.log('PDF DATA '+data);
                //if(actionName == 'view'){
                    component.set("v.pdfData", data);
                    component.set("v.isShowPreview",true);
               // }
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
       
        });
        $A.enqueueAction(action);
    },
    
    getCase : function (component, event,helper){
        var action = component.get("c.isAOL");
        action.setParams({
            "caseId": component.get("v.caseId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue(); 
                component.set("v.isAOLRecordType", data);
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
       // this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
      //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})