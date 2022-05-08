({
    
    onLoad:function(component,event,helper){
          var changeType = event.getParams().changeType;
       if (changeType === "LOADED") { 
        	
     
        var evt = $A.get("e.c:EnableNextButtonEvent1");
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
        console.log('checkedFieldsCount'+checkedFieldsCount);
        console.log('checkedFields'+checkedFieldsCount);
        if((component.get("v.opportunityRecord").STI_Id_Number__c)===true && checkedFieldsCount>=3){
            component.set("v.isCheckboxEnabled",true);
            component.set("v.isVerificationSuccess",true);
            evt.setParam("EnableNext", false);
                evt.fire();
        }  }
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    
    handleCheckbox:function(component, event, helper) {
        console.log('Inside handlecheckbox');
        helper.enableSubmit(component,event);
    },
    handleSaveRecord:function(component,event,helper){
         var evt = $A.get("e.c:EnableNextButtonEvent1");
        component.set("v.isSubmitEnabled",true);
        component.find("recordLoader").saveRecord($A.getCallback(function(response) {
            if (component.isValid() && response.state == "SUCCESS") {
                component.set("v.isCheckboxEnabled",true);
                $A.get('e.force:refreshView').fire(); 
                component.set("v.isVerificationSuccess",true);
                evt.setParam("EnableNext", false);
                evt.fire();
            } else if (response.state == "ERROR") {
                //It is always entering here.
            }
        }));
    }
})