({
	doInit : function(component, event, helper) {
        
        var accountNumber = component.get('v.accNumberFromFlow');
        var accountBalance = component.get('v.accBalanceFromFlow');
        component.set('v.accNumberToCon',accountNumber);
        component.set('v.accBalToCon',accountBalance);
        var caserecId = component.get('v.caseRecordId');
        var caseRecTypeId = component.get('v.caseRecordTypeId'); 
        console.log('-----accNumberFromFlow------'+accountNumber);
        console.log('-----accBalanceFromFlow------'+accountBalance);
        console.log('-----caseRecordId------'+component.get('v.caseRecordId'));
        console.log('-----caseRecordTypeIdFromFlow-HDC-----'+component.get('v.caseRecordTypeId'));
        component.set('v.caseObjId',component.get('v.caseRecordId'));
        component.set('v.caseRecordTypeId',component.get('v.caseRecordTypeId'));
        
        
	},
    closeCase : function(component, event, helper) {
        console.log('--Send EMAIL--');
        
        var action = component.get("c.sendEmailNotifications"); 
        
        var accountNumber = component.get('v.accNumberToCon');
        var accountBalance = component.get('v.accBalToCon');
        var emailAddress = component.find("emailAddress").get("v.value");
        //var caseRecord = component.get('v.caseRecordId');
        //var caseRecord = '5006E00000DneNQQAZ';
        console.log('-----Email Address from cmp---'+component.find("emailAddress").get("v.value"));
        console.log('-----Mobile from cmp---'+component.find("mobile").get("v.value"));
        console.log('-----Comm Meth from cmp---'+component.find("commMethod").get("v.value"));
        console.log('=====caseRecord======'+component.get("v.caseObjId"));
        console.log('=====emailAddress======'+emailAddress);

        action.setParams({caseRecordId: component.get("v.caseObjId"),
                          emailAddress: component.find("emailAddress").get("v.value"),
                          accNumber: accountNumber, 
                          accBalance: accountBalance,
                          mobileNumber: component.find("mobile").get("v.value"),
                          commMethod: component.find("commMethod").get("v.value")
                         });
        
        action.setCallback(this, function(response) {	//caseRecord
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('----- Callback SUCCESS-----');
                component.set("v.hideCloseCase",true);
                var toastEvent = helper.getToast("Success", "Case is closed successfully.Please click Next to continue. ", "Success");
    			toastEvent.fire();
                 $A.get('e.force:refreshView').fire();
                location.reload();
            } else if(state === "ERROR"){
                
            } else{
                
            }
         });
         $A.enqueueAction(action);
    }
})