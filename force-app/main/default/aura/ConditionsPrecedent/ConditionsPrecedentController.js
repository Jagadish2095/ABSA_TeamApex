({
	doInit: function (component, event, helper) {
        
        helper.getApplicationPrecedentt(component,event,helper);
        
    },
    saveCP : function(component, event, helper) {
		var values = component.get("v.values");
        var checkk = false;
        var errors = false;
        console.log('checkkk'+component.get("v.values"));
        for(var i=0;i<values.length;i++){
            if(values[i]=='Yes' && i!=6){
                checkk = true;
             } 
            if(checkk==true && i==6 && values[i]=='Yes'){
                errors = true;
            }
        }
        if(errors){
            var toastEvent = helper.getToast("Error: Conditions Of Precedent", 'Please input correct values', "Error");
        toastEvent.fire();
        }
        else{
            helper.saveCoPP(component, event, helper,values);
        }
	},
    onRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
        console.log('valueg'+value);
    },
})