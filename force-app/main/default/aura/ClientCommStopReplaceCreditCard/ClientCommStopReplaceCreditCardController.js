({
	doInit : function(component, event, helper) {
        console.log('-----caseRecordId------'+component.get('v.flowCaseRecId'));
        console.log('-----caseRecordTypeIdFromFlow-HDC-----'+component.get('v.flowCaseRecTypeId'));
        console.log('-----PLASTIC CARDS-----'+component.get('v.flowplstCardNumbers'));
		
		//component.set('v.caseRecordId','5006E00000DneNQQAZ');
        //component.set('v.caseRecordTypeId','0121r0000007dedAAA');
        //component.set('v.plasticCardNumbers','adasfsa');
        component.set('v.caseRecordId',component.get('v.flowCaseRecId'));
        component.set('v.caseRecordTypeId',component.get('v.flowCaseRecTypeId'));
        component.set('v.plasticCardNumbers',component.get('v.flowplstCardNumbers'));
	},
    closeCase : function(component, event, helper) {
        console.log('--Send EMAIL--');
        console.log('-----------'+component.get('v.caseRecordId'));
        var plstNumber ='';
        if(component.get('v.plasticCardNumbers') !=undefined){
            plstNumber = component.get('v.plasticCardNumbers');
        }
        var action = component.get("c.sendEmailNotifications"); 
        
        if(plstNumber!=''){
            var emailAddress = component.find("emailAddress").get("v.value");
            var mobile = component.find("mobile").get("v.value");
            var communiMeth = component.find("commMethod").get("v.value");
            action.setParams({caseRecordId: component.get('v.caseRecordId'),
                         emailAddress: emailAddress,
                          mobileNumber: mobile,
                          commMethod: communiMeth,
                          plasticCardNums: plstNumber});
        } else{
            action.setParams({caseRecordId: component.get('v.caseRecordId'),
                         emailAddress:'',
                          mobileNumber:'',
                          commMethod: '',
                          plasticCardNums:''});
        }

        action.setCallback(this, function(response) {	//caseRecord
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('----- Callback SUCCESS-----');
                //component.set("v.hideCloseCase",true);
                var toastEvent = helper.getToast("Success", "Case is closed successfully.Please click Next to continue. ", "Success");
    			toastEvent.fire();
                window.location.reload();
            }
         });
         $A.enqueueAction(action);
    }
})