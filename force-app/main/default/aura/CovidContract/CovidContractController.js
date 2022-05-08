({
	doInit : function(component, event, helper) {
		
	}, 
    showButton:function(component, event, helper) {
        //hide button after submission
        var buttonValue= component.get("v.hideSubmitButton");
		component.set("v.hideSubmitButton",!buttonValue);
         
    },  
	submitforQuality : function(component, event, helper) {
        //hide button after submission
		component.set("v.hideSubmitButton",true);
        component.find('EditOpp').submit();
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Submitted for Quality Validation successfully!",
                    "type": "success",
                    "duration": 1500
                });
                toastEvent.fire();
        $A.get('e.force:refreshView').fire(); //referesh to reflect 
    }   
})