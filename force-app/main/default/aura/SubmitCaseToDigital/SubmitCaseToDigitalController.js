({
    doInit : function(component, event, helper) {
        
       /* var caserecId = component.get('v.caseRecordId');
        console.log('case rec id--'+component.get('v.caseRecordId'));
       
        var jsonString = component.get('v.selectedStatmentAccountFromFlow');
        component.set('v.caseObjId',component.get('v.caseRecordId'));
        component.set('v.caseRecordTypeId',component.get('v.caseRecordTypeId'));
        */
    },
    submitClosedCase: function (component, event, helper) {
          console.log('case recordId---'+component.get("v.caseRecordId"));
        var caseId = component.get("v.recordId");	
        console.log('case id>>>' + caseId);  
        helper.updateCase(component, event, helper);
    }
})