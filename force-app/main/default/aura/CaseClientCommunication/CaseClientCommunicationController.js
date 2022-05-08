({
	doInit : function(component, event, helper){
        
    },
	closeCase : function(component, event, helper) {
		helper.showSpinner(component);
        var action = component.get('c.sendEmail');

        var caseId = component.get('v.caseRecordId');
        var email = component.find("emailAddress").get("v.value");
        var name = component.get('v.name') != undefined ? component.get('v.name') : '';
        var branchSite = component.get('v.branchSite') != undefined ? component.get('v.branchSite') : '';
        var cellphoneNumber = component.get('v.cellphoneNumber') != undefined ? component.get('v.cellphoneNumber') : '';
        var tellNumber = component.get('v.tellNumber') != undefined ? component.get('v.tellNumber') : '';
        var bankerEmailAddress = component.get('v.emailAddress') != undefined ? component.get('v.emailAddress') : '';
        console.log('CaseI ' + caseId);
        console.log('Email ' + email);
        console.log('name ' + name);
        console.log('tellNumber ' + tellNumber);
        console.log('cellphoneNumber ' + cellphoneNumber);
        console.log('bankerEmailAddress ' + bankerEmailAddress);
        console.log('branchSite ' + branchSite);
        action.setParams({
            "emailAddress" : email,
            "caseRecordId" : caseId,
            "name" : name,
            "tellNumber" : tellNumber,
            "cellNumber" : cellphoneNumber,
            "bankerEmail" : bankerEmailAddress,
            "branchSite" : branchSite
		});
		
        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                
                var result = response.getReturnValue();
               
                if(result === 'success'){
                    var toast = helper.getToast("Success", "Email sent successfully", "success");
                }else{
                    var toast = helper.getToast("Error", result, "error");
                }

                helper.hideSpinner(component);

                toast.fire();

                $A.get('e.force:refreshView').fire();

                
            } else if (state === "ERROR") {
                
				helper.hideSpinner(component);
                
				var toast = helper.getToast("Error", "There was an error when sending an email", "error");
				
				
				
                toast.fire();
                
                $A.get('e.force:refreshView').fire();
            }
        }));

       
            $A.enqueueAction(action);
    }
})