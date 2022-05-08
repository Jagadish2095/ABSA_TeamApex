({
    myAction : function(component, event, helper) 
    {	
        
        helper.getRelatedInformation(component,helper);   
        var xdsstatus = component.get("v.xdsverificationstatus");
        console.log("XDSStatus>>>>>" + xdsstatus);
    },
    getParty : function(component, event, helper) {
        var currentRec = component.get("v.recordId");
        
        var selectedBillingAccount = component.find("relatedParties").get("v.value");
        component.set("v.selectedValue", selectedBillingAccount);
        component.set("v.isOpen", true);
        //var idNbr = component.get("v.IDNumber");
        //var surname = component.get("v.LastName");
        
    },
    onSelectChange1 : function(component, event, helper) {
        var currentRec = component.get("v.recordId");
        var selectedBillingAccount = component.find("AccountContactRelation1").get("v.value");
        component.set("v.selectedValue", selectedBillingAccount);
        component.set("v.isOpen", true);
        
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        var objChild = component.find('QnSComp');
        //  alert("Method Called from Child " + objChild.get('v.AuthMessage'));
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
       $A.get('e.force:refreshView').fire();
        component.set("v.isOpen", false);
    },
    
    handleEvent : function(component, event, helper) 
    {
        //get response value fired from parent
        var response = event.getParam("eventResponse"); 
        //Set the value recieved from the event
        component.set("v.eventValue", response);  
        helper.saveAttribute();
    },
    showInfo : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info',
            message: 'This Client Needs to be Verified Manually!!',
            duration:' 5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
     navigateToForm : function(component, event, helper ) {
     var evt = $A.get("e.force:navigateToComponent");
     var accId = component.get("v.opportunityRecord.AccountId");  
     var processName = 'EditClientCIF';     
     var clientType = component.get("v.opportunityRecord.Entity_Type__c");   
        console.log('clientType@@@@'+clientType);
        console.log('accId@@@@'+accId);
        
  if (accId != null && accId != '' && accId != undefined) {
                                        //Navigate to OnboardingClientDetails - Business Entities
                                        if(clientType != 'INDIVIDUAL' && clientType != 'Sole Trader' && clientType != 'SOLE PROPRIETOR') {
                                            console.log("In Business accId : " + accId);
                                            evt.setParams({
                                                componentDef: "c:OnboardingClientDetails",
                                                componentAttributes: {
                                                    accRecordId: accId,
                                                    ProcessName: processName,
                                                    opportunityRecordId : component.get("v.recordId") 
                                                    
                                                }
                                            });
                                        }
                                    
                                        
                                        //Navigate to OnboardingIndividualClientDetails - Individual and Sole Trader
                                        else{
                                            console.log("In Individual accId : " + accId);
                                            evt.setParams({
                                                componentDef: "c:OnboardingIndividualClientDetails",
                                                componentAttributes: {
                                                    accRecordId: accId,
                                                    ProcessName: processName,
                                                    opportunityRecordId : component.get("v.recordId"),
                                                    isSoleTrader: true
                                                }
                                            });
                                        }
                                        
  }
       
       
        /*  
         evt.setParams({
            componentDef : "c:ABSA_EditAccountDetails",
            componentAttributes: {
               // recordId : component.get("v.recordId")
                recordId : component.get("v.accId"),
                accRecordId : component.get("v.accId")
            }
             });
        */ 
        evt.fire();
        
        
    },
    
    setManualVerification : function(component, event, helper) {
        component.set("v.verificationType", 'Manual');
        
    },
    
    setXDSVerification : function(component, event, helper) {
        component.set("v.verificationType", 'XDS');
        
    },
})