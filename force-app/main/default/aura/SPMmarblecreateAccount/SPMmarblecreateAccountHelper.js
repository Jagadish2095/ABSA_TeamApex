({
	marbleaccountcreate : function(component, event, helper) {
	   var action = component.get("c.marblecreateAccount");
	   action.setParams({
		   "oppId": component.get("v.recordId"),
		   
	   });
	   action.setCallback(this, function(response) {
		   var state = response.getState();
		   if (state === "SUCCESS") {
			   var serviceresp = response.getReturnValue();
			   this.showToast("success", "Success", "Marble on-boarding processed successful");
			   console.log("serviceresp " + JSON.stringify(serviceresp.Account_Number__c));
			   component.set("v.accNumber",serviceresp.Account_Number__c);
			   //this.updatingOppDetails(component, event, helper);
		   }else if(state === "ERROR"){
			   var errors = action.getError();
			   if (errors) {
				   if (errors[0] && errors[0].message) {
					   this.showToast("error", "Error", errors[0].message);
				   }
			   }
		   }
		   component.set("v.showSpinner", false);
	   });
	   $A.enqueueAction(action);
   },
   showToast : function (type, title, message)
   {
	   var toastEvent = $A.get("e.force:showToast");
	   if(toastEvent) {
		   toastEvent.setParams({
			   "title": title,
			   "message": message,
				"mode": 'sticky',
			   "type": type
		   });
		   toastEvent.fire();
	   } else {
		   alert(message);
	   }
   },
   getAppDetails : function(component, event, helper) {
	   
	   var action = component.get("c.getAppRec");
	   console.log("Opp Id " + component.get("v.recordId"));
	   action.setParams({
		   "oppId": component.get("v.recordId"),
	   });
	   action.setCallback(this, function(response) {
		   var state = response.getState();
		   if (state === "SUCCESS") {
			   var app = response.getReturnValue();
			   console.log("appacount " + JSON.stringify(app));
			   component.set("v.accNumber",app.Account_Number__c);
			   
		   }
		   else {
			   console.log("Failed with state: " + JSON.stringify(response));
		   }
	   });
	   $A.enqueueAction(action);
   },
	/*
   updatingOppDetails : function(component, event, helper) {
	   var action = component.get("c.updateOppStage");
	   console.log("Opp Id " + component.get("v.recordId"));
	   action.setParams({
		   "oppId": component.get("v.recordId"),
	   });
	   action.setCallback(this, function(response) {
		   var state = response.getState();
		   if (state === "SUCCESS") {
			   
			   console.log("Success with state: " + JSON.stringify(response));
			   
		   }
		   else {
			   console.log("Failed with state: " + JSON.stringify(response));
		   }
	   });
	   $A.enqueueAction(action);
   } */
})