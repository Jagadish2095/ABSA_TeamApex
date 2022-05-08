({
	initComp : function(component, event, helper) {
	 var accountId = component.get("v.recordId");
     console.log("Account ******" + accountId);
     var processName = component.get("v.ProcessName");
     console.log("Process Name ******" + processName);
	},
    
    handleClick: function(component, event, helper) {
        
        //Saurabh : Overriding the default recordId to Opp/Case AccountId if Context is Credit Onboarding
        var processName = component.get("v.ProcessName");
        var oppRecord = component.get("v.oppRecord");
        console.log("Process Name ******" + processName);
        console.log("Opp/Case Rec COB ******" + JSON.stringify(oppRecord) );

        if( processName == 'Credit_Onboarding'){
        component.set("v.recordId" ,oppRecord.AccountId );
        console.log("Opp Rec Acc ******" + oppRecord.AccountId);
        }
        
        component.set("v.isGenerated" , true);
        component.set("v.isHide" , true);
   }
})