({
	handleInit : function(component) {
		component.set('v.columns', [
            {label: 'Client Name', fieldName: 'clientName', type: 'text'},
            {label: 'Required', fieldName: 'required', type: 'text'},
            {label: 'Type Required', fieldName: 'typeRequired', type: 'text'},
            {label: 'Available', fieldName: 'available', type: 'text'}
        ]);

        this.handleSoleTraderSpouse(component);
	},

    showToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire(); 
    },

    handleSoleTraderSpouse : function(component) {
        var action = component.get("c.getAccDetails");
        var opportunityId = component.get("v.opportunityId");
        
        action.setParams({
            "oppId" : opportunityId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                console.log('data.Client_Type__c >>>' + data.Client_Type__c );
                component.set("v.dataNotEmpty", false);
                if(data.Client_Type__c == 'Sole Trader'){
                    component.set("v.data", null);
                    component.set("v.dataNotEmpty", true);
                }
            } else {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("error","Validation 2 Error!",errors[0].message);
                    }
                } else {
                    this.showToast("error","Error!","Validation 2 unknown error");
                }
            }
            
            component.set("v.isRefreshed", false);
        });
        $A.enqueueAction(action);
    },
})