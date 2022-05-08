({
	init : function(component){
        console.log('===ACC===>'+component.get("v.accRec"));
        var flow = component.find("flowData");
        var accRecordToFlow = component.get("v.accRec");
        //var 
        /*
        var inputVariables1 = [
               {
                  name : "AccountIdFromComponent",
                  type : "String",
                  value: "0019E0000151oJeQAI"
               }
            ];
            */
        var inputVariables = [
               {
                  name : "recordId",
                  type : "String",
                  value: component.get("v.accRec")
               }
            ];
        flow.startFlow("OnboardingNewToBankClient",inputVariables);
        //flow.startFlow("Onboarding_NTB_Client",inputVariables);
        
    },
})