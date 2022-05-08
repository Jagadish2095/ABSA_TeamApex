({
	onRemoveAccountCheck : function (component, event, helper) {
        helper.handleOnRemoveAccountCheck(component, event);
    },
    removeAccount : function (component, event, helper) {
        helper.handleRemoveAccount(component, event);
    },
    dateController : function (component, event, helper) {
    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    var target = event.getSource();
    var fieldName = target.get("v.fieldName");
    var fieldVal = target.get("v.value");
    var startDate = new Date(fieldVal);
    var endDate = new Date(today);
    console.log('today'+today);
    console.log('fieldVal'+fieldVal);
    var days = (startDate-endDate)/8.64e7;
    console.log('days'+days);
    if(days>365){
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Facility Review Date cannot be greater than 1 year from current date"
            });
             toastEvent.fire();
        
            
    }
        if(days<0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Facility Review Date cannot be a past date"
            });
             toastEvent.fire();
        }
       
    
}
})