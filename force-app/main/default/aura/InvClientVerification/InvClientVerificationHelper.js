({
    checkUserAccess: function (component){
        var action = component.get("c.getUserAccess");
        action.setParams({
            oppId: component.get("v.opportunityId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('retrunValue' + JSON.stringify(returnValue));
                if (returnValue != null){
                    component.set("v.hasRecordAccess",true);
                    if(returnValue){
                        component.set("v.mode","EDIT");
                    }
                    else{
                        component.set("v.mode","VIEW");
                    }
                    component.find("recordLoader").reloadRecord();
                }
            }
        });
        $A.enqueueAction(action);
    },
    enableSubmit : function(component,event) {
        var checkedArray = [];
        var oppRecord = component.get("v.opportunityRecord");
        if(oppRecord != null && oppRecord != undefined){
            checkedArray.push(oppRecord.STI_Postal_Address__c);
            checkedArray.push(oppRecord.STI_Physical_Address__c);
            checkedArray.push(oppRecord.STI_Email_Address__c);
            checkedArray.push(oppRecord.STI_Full_Name__c);
            checkedArray.push(oppRecord.STI_Id_Number__c);
            checkedArray.push(oppRecord.Inv_Phone_Number__c);
            var checkedFieldsCount = checkedArray.filter(function(obj){ return obj===true; }).length;
            if(oppRecord.STI_Id_Number__c === true 
               && checkedFieldsCount>=3 
               && oppRecord.StageName != 'Closed'
               && oppRecord.StageName != 'Closed Lost (Customer Not Interested)')
            {
                component.set("v.isSubmitEnabled",false); 
            }
            else
            {
                component.set("v.isSubmitEnabled",true);
            }  
        } 
        
    },
    renderIdType : function(component,event) {
        if(component.get('v.opportunityRecord')!= null &&  component.get('v.opportunityRecord').Person_Id_Type__c === 'SA Identity Document' ){
            console.log("Inside SA ID");
            component.set("v.isIdTypeSAId",true);  
            
        } else if(component.get('v.opportunityRecord')!= null && component.get('v.opportunityRecord').Person_Id_Type__c === "Passport"){
            component.set("v.isIdTypeSAId",false);
        }
            else
            {
                component.set("v.isIdTypeblank",true);
            }
        //Set Id & V Completed IF Client Verfication is Success
        if(component.get('v.opportunityRecord') != null || component.get('v.opportunityRecord') != undefined)
        {
            if(component.get('v.opportunityRecord').StageName == 'New'){
                component.get('v.opportunityRecord').StageName='In Progress';
                component.get('v.opportunityRecord').Sub_Status__c='ID & V Completed';                
                console.log('In side '+component.get('v.opportunityRecord'));
                component.get('v.opportunityRecord').Sys_BypassValidation__c=true;
            }            
        }        
    }
})