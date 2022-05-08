({
	updatePowerCurveSummary: function (component, event, helper) {
		var oppRecord = component.get("v.oppRecord");
        component.set("v.accountId", oppRecord.AccountId );
        component.set("v.isGenerated" , true);
        
        var action = component.get("c.calculatePowerCurveSummary");
     	var accountId = component.get("v.recordId");
     	let oppId = oppRecord.Id;
             action.setParams({
                 'OppId': oppId,
                 'IsUpdate':true
             });
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log("State" + state);
            console.log("Getbonds Response **********************************************************" + response);
            if (state === "SUCCESS" && response != null) {
                var storeResponse = response.getReturnValue();
                console.log("Inside Method 1" + JSON.stringify(storeResponse));
                component.set("v.ASV",storeResponse.ASV_Securities);
                component.set("v.MASV",storeResponse.MASV_Bonds)
                console.log("ASV" + storeResponse.ASV_Securities);
                console.log("MASV" + storeResponse.MASV_Bonds);
               }else if(state == "ERROR"){
                var errors = response.getError();
                console.log('errors'+errors);
              }
            
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	}
})