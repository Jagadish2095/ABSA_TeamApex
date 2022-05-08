({
	getRecord : function(component, event, helper) {
		let getRecord = component.get("c.getClickToDialInfo");
        getRecord.setParams({
            "recordId": component.get("v.recordId"),
            "commaSeperatedFields": component.get("v.commaSeperatedFields")
        });
        getRecord.setCallback(this, function(response){
            console.log('STATUS : '+response.getState());
            if(response.getState()=="SUCCESS"){
                console.log("record ::: "+JSON.stringify(response.getReturnValue()));
                component.set("v.ClickToDialInfo", response.getReturnValue());
            }
            else{
                console.log("ERROR : "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getRecord);
	}
})