({
	myAction : function(component, event, helper) {
		
	},
    
    Init: function(component, event, helper) {
        component.set('v.columns', [
            //{ label: 'Material Disclosure', fieldName: 'Text_Content__c', type: 'text' },
            {label: 'Material Disclosure', fieldName: 'Material Disclosure', type: 'button', typeAttributes: {label: { fieldName: 'Text_Content__c'}, title: {fieldName: 'Text_Content__c' }, variant: "base", class:"notLink"}},

        ]);
            
        
        helper.fetchData(component);
            
        helper.checkOnInitValidity(component);
    },
    
    submitDisclosures: function(component, event, helper) {
       
        helper.saveData(component);
   	},
            
     handleNext : function(component, event, helper) {
      		var response = event.getSource().getLocalId();
      		component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate(response);
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
        var selectedRowsCount = event.getParam('selectedRows');
        component.set("v.allClauses", event.getParam('selectedRows'));
            var k;
            for ( k in selectedRowsCount){
            	if(k >= 1){
            		component.find("validateButton").set("v.disabled", false);
        		}
        		else{
            		component.find("validateButton").set("v.disabled", true);
        		}
            }
            
    },
})