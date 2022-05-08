({
	doInit : function(component, event, helper) {
		console.log("Execute Job cmp reCordId: " + component.get("v.recordId"));
		var flowName;
		var flow = component.find("flowToBeRendered");

		if(component.get("v.flowName")){
			flowName = component.get("v.flowName");
		}

		if($A.util.isEmpty(flowName)){
			component.set("v.errorMessage", "No Flow Name was provided to the page. Loading flow from Process Type, Please contact you System Administrator should the flow not load after a few seconds. ");
		}else{
			var inputVariables = [{ name : "MainAccountID", type : "String", value: component.get("v.recordId")}];
			flow.startFlow(flowName,inputVariables);
		}
	},

	// W-019387 Hloni Matsoso 14/03/2022
	// Loads flow according to Process Type
	recordLoadHandler : function( component, event, helper){
		var processType = event.getParam('recordUi').record.fields['Process_Type__c'].displayValue;

		if($A.util.isEmpty(processType)){
			component.set("v.errorMessage", "Process Type not set on this opportunity, loading flow failed. Please contact you System Administrator.");
		}else{
			helper.executeFlowByProcessTypeName(component, processType);
		}

	}
})