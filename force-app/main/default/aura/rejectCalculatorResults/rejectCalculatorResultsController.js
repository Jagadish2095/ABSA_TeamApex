({
    openModal:function(component, event, helper) {
        component.set("v.opportunityRecord.Reason_for_Not_Taken_Up__c", null);
        helper.fadeInOpenDialog(component);
    },

    //attempt record save
    handleSaveRecord: function(component, event, helper) {
        component.set("v.loadingSpinner", true);
        component.set("v.opportunityRecord.StageName", "Closed");
        component.set("v.opportunityRecord.CheckMandatoryDocuments__c", false);
        component.find("opportunityRecordCmp").saveRecord($A.getCallback(function(saveResult) {
            if(saveResult.error){
                component.find('notifLib').showToast({
                    "title": "We Hit A Snag!",
                    "message": saveResult.error[0].message,
                    "variant": "error"
                });
                component.set("v.loadingSpinner", false);
            }
            else{
                component.set("v.loadingSpinner", false);
                helper.fadeOutCloseDialog(component);
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Opportunity closed successfully.",
                    "variant": "success"
                });
                //Scroll to top once opportunity is closed
                var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
            }
        }));
    },
    
    //handle closure of modal and animation
    handleCancel : function(component, event, helper) {
        component.set("v.recordError", null);
        component.set("v.opportunityRecord.Reason_for_Not_Taken_Up__c", null);
        component.set("v.opportunityRecord.CheckMandatoryDocuments__c", true);
        helper.fadeOutCloseDialog(component);
    }
})