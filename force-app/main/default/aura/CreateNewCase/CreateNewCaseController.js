({
    doInit : function(component, event, helper) { 
        helper.fetchPicklistValues(component, event, helper);
        console.log('component.get("v.recordId") :'+component.get("v.recordId"));
        let objetName = component.get('v.sObjectName'); 
        if(component.get("v.recordId"))
        {
            var action = component.get('c.getLeadCaseDetails'); 
            action.setParams({
                "recordId" : component.get("v.recordId"),
                "objectName" : component.get('v.sObjectName')
            });
            action.setCallback(this, function(a){
                var state = a.getState(); // get the response state
                
                if(state == 'SUCCESS') {
                    console.log('objetName :'+objetName);
                    if(objetName ==  'Case'){
                        component.set('v.newCase.Birth_Date__c', a.getReturnValue().Birth_Date__c);
                        component.set('v.newCase.ID_Type__c', a.getReturnValue().ID_Type__c);
                        component.set('v.newCase.Customer_ID__c', a.getReturnValue().Customer_ID__c);
                        component.set('v.newCase.Initials__c', a.getReturnValue().Initials__c);
                        component.set('v.newCase.Mobile__c', a.getReturnValue().Mobile__c);
                        component.set('v.newCase.Title__c', a.getReturnValue().Title__c);
                        component.set('v.newCase.First_Name__c', a.getReturnValue().First_Name__c);
                        component.set('v.newCase.Last_Name__c', a.getReturnValue().Last_Name__c);
                        component.set('v.newCase.AccountId', a.getReturnValue().AccountId);
                        component.set('v.newCase.VA_Client_Referral_Type__c', a.getReturnValue().VA_Client_Referral_Type__c);
                        component.set('v.newCase.Customer_Type__c', a.getReturnValue().Customer_Type__c);
                        component.set('v.newCase.Account_Balance__c', a.getReturnValue().Account_Balance__c);
                        component.set('v.newCase.Investment_Amount__c', a.getReturnValue().Investment_Amount__c);
                        component.set('v.newCase.Term__c', a.getReturnValue().Term__c);
                        component.set('v.newCase.ContactId', a.getReturnValue().ContactId);
                        component.set('v.newCase.Origin', a.getReturnValue().Origin);
                        component.set('v.newCase.Gender__c', a.getReturnValue().Gender__c);
                        component.set('v.newCase.Nationality__c', a.getReturnValue().Nationality__c);
                        component.set('v.newCase.CIF_Custom__c', a.getReturnValue().CIF_Custom__c);
                        component.set('v.newCase.Alternate_Phone1__c', a.getReturnValue().Alternate_Phone1__c);
                        component.set('v.newCase.Alternate_Phone2__c', a.getReturnValue().Alternate_Phone2__c);
                        component.set('v.newCase.Alternate_Phone3__c', a.getReturnValue().Alternate_Phone3__c);
                        component.set('v.newCase.Alternate_Phone4__c', a.getReturnValue().Alternate_Phone4__c);
                        component.set('v.newCase.Alternate_Phone5__c', a.getReturnValue().Alternate_Phone5__c);
                        component.set('v.newCase.Alternate_Phone6__c', a.getReturnValue().Alternate_Phone6__c);
                        component.set('v.newCase.Alternate_Phone7__c', a.getReturnValue().Alternate_Phone7__c);
                        component.set('v.newCase.Home_Phone__c', a.getReturnValue().Home_Phone__c);
                        component.set('v.newCase.Work_Phone__c', a.getReturnValue().Work_Phone__c);
                        component.set('v.newCase.Phys_Addr_Line1__c', a.getReturnValue().Phys_Addr_Line1__c);
                        component.set('v.newCase.Phys_Addr_Line2__c', a.getReturnValue().Phys_Addr_Line2__c);
                        component.set('v.newCase.Phys_Addr_Line3__c', a.getReturnValue().Phys_Addr_Line3__c);
                        component.set('v.newCase.Phys_Addr_Line4__c', a.getReturnValue().Phys_Addr_Line4__c);
                        component.set('v.newCase.Postal_Address__c', a.getReturnValue().Postal_Address__c);
                        component.set('v.newCase.Comments__c', a.getReturnValue().Comments__c);
                        component.set('v.newCase.Comments', a.getReturnValue().Comments);
                        component.set('v.newCase.Email__c', a.getReturnValue().Email__c);
                        component.set('v.newCase.Subject', a.getReturnValue().Subject);                        
                        component.set('v.newCase.Description', a.getReturnValue().Description);
                        component.set('v.newCase.ID_Number__c', a.getReturnValue().ID_Number__c);
                        component.set('v.newCase.Priority', a.getReturnValue().Priority);
                        
                        if(a.getReturnValue().Account){                                                       
                            component.set('v.AccountName', a.getReturnValue().Account.Name);
                        }
                    }   
                    else if(objetName ==  'Lead'){
                        component.set('v.newCase.Birth_Date__c', a.getReturnValue().DD_Date_of_Birth__c);
                        component.set('v.newCase.ID_Type__c', a.getReturnValue().ID_Type__c);
                        component.set('v.newCase.Customer_ID__c', a.getReturnValue().ID_Number__c);
                        component.set('v.newCase.Initials__c', a.getReturnValue().DD_Initials__c);
                        component.set('v.newCase.Mobile__c', a.getReturnValue().Lead_Phone__c);
                        component.set('v.newCase.Title__c', a.getReturnValue().Title);
                        component.set('v.newCase.First_Name__c', a.getReturnValue().Lead_Name__c);
                        //component.set('v.newCase.Last_Name__c', a.getReturnValue().Last_Name__c);
                        component.set('v.newCase.AccountId', a.getReturnValue().Parent_Account__c);
                        //component.set('v.newCase.VA_Client_Referral_Type__c', a.getReturnValue().VA_Client_Referral_Type__c);
                        component.set('v.newCase.Customer_Type__c', a.getReturnValue().Lead_Type__c);
                        //component.set('v.newCase.Account_Balance__c', a.getReturnValue().Account_Balance__c);
                        component.set('v.newCase.Investment_Amount__c', a.getReturnValue().Deposit_Amount__c);
                        component.set('v.newCase.Term__c', a.getReturnValue().Outstanding_Term__c);
                        component.set('v.newCase.ContactId', a.getReturnValue().ContactName__c);
                        //component.set('v.newCase.Origin', a.getReturnValue().Origin);
                        component.set('v.newCase.Gender__c', a.getReturnValue().DD_Gender__c);
                        component.set('v.newCase.Nationality__c', a.getReturnValue().Nationality__c);
                        component.set('v.newCase.CIF_Custom__c', a.getReturnValue().CIF__c);
                        component.set('v.newCase.Alternate_Phone1__c', a.getReturnValue().Alternate_Phone1__c);
                        component.set('v.newCase.Alternate_Phone2__c', a.getReturnValue().Alternate_Phone2__c);
                        component.set('v.newCase.Alternate_Phone3__c', a.getReturnValue().Alternate_Phone3__c);
                        //component.set('v.newCase.Alternate_Phone4__c', a.getReturnValue().Alternate_Phone4__c);
                        //component.set('v.newCase.Alternate_Phone5__c', a.getReturnValue().Alternate_Phone5__c);
                        //component.set('v.newCase.Alternate_Phone6__c', a.getReturnValue().Alternate_Phone6__c);
                        //component.set('v.newCase.Alternate_Phone7__c', a.getReturnValue().Alternate_Phone7__c);
                        component.set('v.newCase.Home_Phone__c', a.getReturnValue().DD_Home_Phone__c);
                        component.set('v.newCase.Work_Phone__c', a.getReturnValue().DD_Work_Phone__c);
                        //component.set('v.newCase.Phys_Addr_Line1__c', a.getReturnValue().Phys_Addr_Line1__c);
                        //component.set('v.newCase.Phys_Addr_Line2__c', a.getReturnValue().Phys_Addr_Line2__c);
                        //component.set('v.newCase.Phys_Addr_Line3__c', a.getReturnValue().Phys_Addr_Line3__c);
                        //component.set('v.newCase.Phys_Addr_Line4__c', a.getReturnValue().Phys_Addr_Line4__c);
                        //component.set('v.newCase.Postal_Address__c', a.getReturnValue().Postal_Address__c);
                        component.set('v.newCase.Comments__c', a.getReturnValue().Comments__c);
                        //component.set('v.newCase.Comments', a.getReturnValue().Comments);
                        component.set('v.newCase.Email__c', a.getReturnValue().Lead_Email__c);                        
                        component.set('v.newCase.Description', a.getReturnValue().Description);
                        
                        if(a.getReturnValue().FinServ__RelatedAccount__c){
                            component.set('v.AccountName', a.getReturnValue().FinServ__RelatedAccount__r.Name);
                        }
                    }
                }
                else{
                    console.log('Error while calling apex');
                }
            });
            $A.enqueueAction(action);
        }              
        
    },
    createCase : function(component, event, helper) {
        var isSuccess = true;
        var newCase = component.get("v.newCase");
        let objetName = component.get('v.sObjectName'); 
        if(newCase.OwnerId == undefined || newCase.OwnerId == '')
        {
            isSuccess = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Receiving Case"
            });
            toastEvent.fire();
        } 
        
        if(isSuccess === true)
        {
            newCase.ParentId=component.get("v.recordId");
            newCase.Subject = component.find("caseSub").get("v.value");
            console.log('---sub--' + component.find("caseSub").get("v.value"));
            component.set('v.newCase', newCase);
            console.log('Before Apex Call'+JSON.stringify(component.get('v.newCase')));
            var action = component.get("c.createServiceRequestCase");            
            action.setParams({
                "caseRecord": component.get("v.newCase"),
                "objetName": objetName
            });
            action.setCallback(this, function(response){ 
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Inside success'+response.getReturnValue());
                    var result = response.getReturnValue();
                    
                    if(result == "Success"){
                        $A.get('e.force:refreshView').fire();
                        $A.get("e.force:closeQuickAction").fire();
                        helper.showToast("success", "Success", "Case Creation was Successful!!");
                        component.set("v.showSpinner", false);
                        
                    }
                    else{
                        isSuccess = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR!",
                            "type" : 'error',
                            "message": "Cannot Save Case :" + result
                        });
                        toastEvent.fire(); 
                        component.set("v.showSpinner", false);            
                    }                       
                    
                }
                else if (state === "ERROR") {
                    console.log('Inside error');
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });            
            $A.enqueueAction(action);
        }
    },
    handleOnError : function(component, event, helper) {
        var error = event.getParam("error");
        console.log("Error :"+error.message); // main error message
    },
})