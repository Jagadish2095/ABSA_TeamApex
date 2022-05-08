/**
* Lightning Component for the custom communication rule UI
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-06-25
*
**/
({
	//Init load of Component
    doInit : function(component, event, helper) {

		var ruleId = component.get("v.recordId");
		var action = component.get("c.getRule"); 
		
		action.setParams({
			"ruleId" : ruleId
		});
				
		// Add callback behavior for when response is received
		action.setCallback(this, function(response) {
			
		var state = response.getState();
		
			if (component.isValid() && state === "SUCCESS") {
				
				component.set("v.ruleRecord", response.getReturnValue());

				var isTimeBase = component.get("v.ruleRecord.sd_When_to_Trigger__c");

				if( isTimeBase === 'Immediate' ){
					component.set("v.isTimeTrigger", false);
				}else{
					component.set("v.isTimeTrigger", true);
				}
				
				component.set("v.emailTemplateId", null);

			}else{
				var toastEvent = helper.getToast("Error!", helper.getErrorMessage(response) , "error");
				toastEvent.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(action);
	},
	reLoad: function(component,event,helper){

	},
	saveRule: function(component, event,helper){

		//Validation

		
		helper.showSpinner(component);

		var theRule = component.get("v.ruleRecord");

		console.log("ID1 " + component.get("v.emailTemplateId"));
		console.log("ID2 " + component.get("v.emailTemplateAfrId"));
		console.log("ID3 " + component.get("v.smsTemplateId"));
		console.log("ID4 " + component.get("v.smsTemplateAfrId"));
		console.log("NAME1 " + component.get("v.sd_Email_Template__c"));
		console.log("NAME2 " + component.get("v.sd_Email_Template_AFR__c"));
		console.log("NAME3 " + component.get("v.sd_SMS_Template__c"));
		console.log("NAME4 " + component.get("v.sd_SMS_Template_AFR__c"));

		component.set("v.ruleRecord.sd_Email_Template_Id__c", component.get("v.emailTemplateId"));
		component.set("v.ruleRecord.sd_Email_Template_Id__AFR__c", component.get("v.emailTemplateAfrId"));
		component.set("v.ruleRecord.sd_SMS_Template_Id__c", component.get("v.smsTemplateId"));
		component.set("v.ruleRecord.sd_SMS_Template_Id_AFR__c", component.get("v.smsTemplateAfrId"));

		var action = component.get("c.upsertRule");
		
        action.setParams({
            "rule" : theRule 
		});

		action.setCallback(this, function(response) {
         
			var state = response.getState();
			 
				if (component.isValid() && state === "SUCCESS") {
					
					var toastEvent = helper.getToast("Success!", "Communication Rule Saved", "success");
					toastEvent.fire();

					helper.hideSpinner(component);

					window.history.back();
	
				}else{
					var toastEvent = helper.getToast("Error!", helper.getErrorMessage(response) , "error");
					toastEvent.fire();
					helper.hideSpinner(component);
				}
		   });
		
		$A.enqueueAction(action);

	},
	setTriggerType: function(component){

		var isTimeBase = component.get("v.ruleRecord.sd_When_to_Trigger__c");

		if( isTimeBase === 'Immediate' ){
			component.set("v.isTimeTrigger", false);
		}else{
			component.set("v.isTimeTrigger", true);
		}
	},
	cancelEdit: function(component, event,helper){
		window.history.back();
	}
})