({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        component.set('v.columns', [
            //{ label: 'Declaration', fieldName: 'Text_Content__c', type: 'text' },
            {label: 'Declaration', fieldName: 'Declaration', type: 'button', typeAttributes: {label: { fieldName: 'Text_Content__c'}, title: {fieldName: 'Text_Content__c' }, variant: "base", class:"notLink"}},
        ]);
        
        helper.fetchData(component);
        helper.checkOnInitValidity(component);
    },
    
    submitDisclosures: function(component, event, helper) {
        helper.checkEmailValidity(component);
   	},
            
    onCompletedCheck: function(component, event) {
        var checkCmp = component.find("completedCheckbox");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("validateButton").set("v.disabled", false);
        }
        else{
            component.find("validateButton").set("v.disabled", true);
        }
    },
            
    updateSelectedData: function (component, event) {
        component.set("v.allClauses", event.getParam('selectedRows'));        
    },
})