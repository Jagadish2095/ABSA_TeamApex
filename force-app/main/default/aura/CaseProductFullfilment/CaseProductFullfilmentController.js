({
	doInit : function(component, event, helper) {
       helper.inithelper(component, event, helper);
	},
    handlesuccess : function(component, event, helper){
        component.find('notifLib').showToast({
            "title": "Success!",
            "variant":"success",
            "message": "Application product details updated Successfully."
        });
        component.set("v.productdetailmodal",false);
        component.set("v.IsSpinner",false);
        helper.inithelper(component, event, helper);
    },
    handlesuccessparent : function(component, event, helper){
        component.find('notifLib').showToast({
            "title": "Success!",
            "variant":"success",
            "message": "Application product details updated Successfully."
        });
        component.set("v.IsSpinner",false);
        $A.get('e.force:refreshView').fire();
    },
    handleerrors : function(component, event, helper){
        component.find('notifLib').showToast({
            "title": "Error!",
            "variant":"error",
            "message": event.getParam("message")
        });
        component.set("v.IsSpinner",false);
    },
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    handleRowAction: function (component, event, helper) {
        component.set("v.IsSpinner",true);
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'view':
                component.set("v.productdetailid",row.Id);
                component.set("v.productdetailtype",'view');
                helper.getcolumndetails(component, event, helper, row);
                break;
            case 'edit':
                component.set("v.productdetailid",row.Id);
                component.set("v.productdetailtype",'edit');
                helper.getcolumndetails(component, event, helper, row);
                break;
            case 'delete':
                helper.deleteappproduct(component, event, helper, row.Id);
                break;
        }
    },
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        var issuefields = 0;
        var reqfields = component.find('requiredField');
        var validations = 0;
        var errormsg = '';
        for(var i=0; i<reqfields.length; i++){
             var fieldval =reqfields[i].get('v.value');
             var fieldname =reqfields[i].get('v.fieldName');
             var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if(!fieldval || fieldval==''){
                issuefields=issuefields+1;
            }else if(fieldname==='Guarantee_Created_Date__c' && fieldval>today){
                validations = validations+1;
                errormsg = 'Guarantee Created Date cannot be a future date';
            }else if(fieldname==='Guarantee_Expiry_Date__c' && fieldval<today){
                validations = validations+1;
                errormsg = 'Guarantee Expiry Date cannot be a past date';
            }else if(fieldname==='Contract_Date__c' && fieldval>today){
                validations = validations+1;
                errormsg = 'Contract Date cannot be a future date';
            }
        }
        if(issuefields>0){
            component.find('notifLib').showToast({
                "title": "Error!",
                "variant":"error",
                "message": 'Please fill all mandatory fields'
            });
        }else if(validations>0){
            component.find('notifLib').showToast({
                "title": "Error!",
                "variant":"error",
                "message": errormsg
            });
        }else{
            var fields = event.getParam('fields');
            if(fields.Construction_Guarantee_Type__c==='Variable' &&
               (fields.Reducing_to_the_Guaranteed_Sum_1__c==null || fields.Reducing_to_the_Guaranteed_Sum_1_Text__c=='' 
                || fields.Reducing_to_the_Guaranteed_Sum_2__c==null || fields.Reducing_to_the_Guaranteed_Sum_2_Text__c==''
                || fields.Reducing_to_the_Guaranteed_Sum_3__c==null || fields.Reducing_to_the_Guaranteed_Sum_3_Text__c=='')){
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "variant":"error",
                    "message": "Please fill the Reducing to the Guaranteed Sum fields"
                });
            }else{
               component.find('myRecordForm').submit(fields);
            }
        }
    },
    handleSubmitParent : function(component, event, helper) {
        event.preventDefault();
        var issuefields = 0;
        var reqfields = component.find('requiredFieldparent');
        var validations = 0;
        var errormsg = '';
        for(var i=0; i<reqfields.length; i++){
             var fieldval =reqfields[i].get('v.value');
             var fieldname =reqfields[i].get('v.fieldName');
             var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if(!fieldval || fieldval==''){
                issuefields=issuefields+1;
            }
        }
        if(issuefields>0){
            component.find('notifLib').showToast({
                "title": "Error!",
                "variant":"error",
                "message": 'Please fill all mandatory fields'
            });
        }else{
            var fields = event.getParam('fields');
            component.find('myRecordFormparent').submit(fields);
        }
    },
    closeModel : function(component, event, helper) {
        component.set("v.productdetailmodal",false);
        component.set("v.IsSpinner",false);
    },
    handlecancel : function(component, event, helper) {
        component.set("v.productdetailmodal",false);
        component.set("v.IsSpinner",false);
    },
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Application_Product__c"
        });
        createRecordEvent.fire();
    }
})