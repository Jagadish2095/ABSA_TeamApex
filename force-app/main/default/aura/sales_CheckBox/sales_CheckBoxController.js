({
	setValueController : function(component, event, helper) {
		var checked = component.get("v.checked");

        checked = (checked) ? false : true;

        component.set("v.checked", checked);
        
       /* if(component.get("v.label") == 'ABSA group electronic'){
            if(checked){
                let client = component.get("v.client");
                client.ch1 = true;
                cleint.ch2 = true;
                component.set("v.cleint", client);
            } 
        }*/
        return;
	}
})