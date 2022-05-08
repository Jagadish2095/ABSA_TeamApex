({
    doInit : function(component, event, helper) {
        helper.checkpendingapprovals(component);
    },
    
    handleCreateLoad : function(component, event, helper) {
        helper.checkcategory(component,event);
    },
    
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        helper.showSpinner(component);
        var fields = event.getParam("fields");
        var showValidationError = false;
        console.log('fields=='+JSON.stringify(fields));
    	console.log('discount=='+fields["Discount__c"]);
        if($A.util.isUndefinedOrNull(fields["Discount__c"]) || fields["Discount__c"] == ''){
            var toast = helper.getToast("Validation Warning", "Discount value is Required", "warning");
            toast.fire();
            helper.hideSpinner(component);
            return;
        }else if(fields["Discount__c"] > 10) {
            var reqfields = component.find("iDiscountfield");
            reqfields.forEach(function (field) {
                if($A.util.isEmpty(field.get("v.value"))){
                    showValidationError = true;
                }
            });
            if(showValidationError){
                var toast = helper.getToast("Validation Warning", "All fields are Required as discount is greater than 10%", "warning");
                toast.fire();
                helper.hideSpinner(component);
                return;
            }
        }
        console.log("Discunt=="+fields["Discount__c"]);
        if(fields["Discount__c"] < 11) {
            fields.Discount_Approved__c = true;
        }
        component.find('createDiscountForm').submit(fields);
    },
    
    handleSuccess : function(component, event, helper) {      
        helper.initiateapprovalprocess(component,event);
    },
})