({
    checkcategory : function(component,event) {
        var fieldValue = event.getParam("recordUi");
        var discountapproved = fieldValue.record.fields["Discount_Approved__c"].value;
        component.set("v.isdiscountapproved", discountapproved);
        //console.log('fieldValue=='+JSON.stringify(fieldValue));
        var validcategories = ['Amendment','Cancellation','Query'];
        var category = fieldValue.record.fields["Category__c"].value;
        console.log('category=='+category);
        if(validcategories.indexOf(category) == '-1') {
            component.set("v.isValid", true);
            component.set("v.title","Discount is not Applicable for this case");
        }
    },
    
    checkpendingapprovals : function(component) {
        //Method to check if there is any approval processes in progress
        var action = component.get("c.approvalProccessChecks");
        
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state == "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.isValid", response);
                if(response) {
                    component.set("v.title","Case is currently in an Approval Process");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    initiateapprovalprocess : function(component,event) {
        
        var param = event.getParams(); //get event params
        var fields = param.response.fields;
        console.log('Discount appoved===='+fields.Discount_Approved__c.value);
        
        if(fields.Discount_Approved__c.value && fields.Discount__c.value < 11) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Discount has been Approved",
                "type":"success"
            });
            toastEvent.fire();
            this.hideSpinner(component);
            $A.get("e.force:refreshView").fire();
        } else { 
            var action = component.get("c.submitapproval");
            action.setParams({
                "recId" : component.get("v.recordId")
            });
            
            action.setCallback(this, function(response) {  
                var state = response.getState();
                
                if (component.isValid() && state == "SUCCESS") {
                    var response = response.getReturnValue();
                    component.set("v.isdisabled", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case has been submitted for Discount Approval",
                        "type":"success"
                    });
                    toastEvent.fire();
                    this.hideSpinner(component);
                    $A.get("e.force:refreshView").fire();
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        return toastEvent;
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})