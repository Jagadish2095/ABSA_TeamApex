({
	 enableSubmit : function(component,event) {
        console.log("Inside handle checkbox helper");
        var evt = $A.get("e.c:EnableNextButtonEvent1");
        var IDVStatus = component.get("v.isVerificationSuccess");
        if(IDVStatus === true){
            component.set("v.isSubmitEnabled",true);
            evt.setParam("EnableNext", false);
                evt.fire();
        }else{
            var checkedArray = [];
            //checkedArray.push(component.get("v.opportunityRecord").STI_DOB__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Postal_Address__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Physical_Address__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Email_Address__c);
            //checkedArray.push(component.get("v.opportunityRecord").STI_Middle_name__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Full_Name__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Company_Registration_Number__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Id_Number__c);
            var checkedFieldsCount = checkedArray.filter(function(obj){ return obj===true; }).length;
            if((component.get("v.opportunityRecord").STI_Id_Number__c)===true && checkedFieldsCount>=3){
                component.set("v.isSubmitEnabled",false);
               // evt.setParam("EnableNext", false);
                //evt.fire();
                
            }
            else{
                component.set("v.isSubmitEnabled",true);
            }
        }
        
        
    }
    
    
})