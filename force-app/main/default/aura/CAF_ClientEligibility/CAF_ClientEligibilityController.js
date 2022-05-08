({
	getOpp : function(cmp, event, helper) {
		helper.getOppRecords(cmp);
        console.log('recordId '+cmp.get('v.recordId'));
	},
    
     // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
   },
    
 	// this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){  
       component.set("v.spinner", false);
    },
    
    calcNCA : function (cmp, event, helper){
         var sanctioningStatus = cmp.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            helper.showToast("Error!", "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes.", "error");
        } else {  
        helper.showSpinner(cmp);
        var clientT = cmp.get('v.cType');
        
        if (clientT){
                  
                    var method1 = cmp.get("c.checkNCAStatus");
                    method1.setParams({
                                        "oppId" : cmp.get('v.recordId'), 
                                        "agreesize" : cmp.get('v.agreeSize'),
                                        "agreetype" : cmp.get('v.agreeType'),
                                        "annualturnover" : cmp.get('v.annualTurnover'),
                                        "netasset" : cmp.get('v.netAssetval'),
                                        "securemortgage" : cmp.get('v.secureMortgage')
                                     });
                    
                    method1.setCallback(this, function(response) {
                        var state = response.getState();
                        //alert ('Response Value ## ' + response.getReturnValue());
                        if (cmp.isValid() && state === "SUCCESS"){
                            helper.hideSpinner(cmp);
                            cmp.set ("v.spinner", false);
                             cmp.set("v.ncaOutcome", true); 
                            
                             var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                title : 'Success',
                                message: 'NCA calculated successfully.',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                                });
                                toastEvent.fire();
                             $A.get('e.force:refreshView').fire();
                          }
                        else if (state === "ERROR") 
                        {
                           var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    //alert ("Error: " + errors[0].message);
                                    console.log("Error: " + errors[0].message);
                                }
                            }                
                        }          
                    });
                    $A.enqueueAction(method1);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            				helper.hideSpinner(cmp);
                            cmp.set ("v.spinner", false);
                                toastEvent.setParams({
                                title : 'Warning',
                                message: 'Please note that Client type cannot be empty when performing the NCA calc.',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'warning',
                                mode: 'sticky'
                                });
                                toastEvent.fire();
        }
        }
    },
    trust : function (cmp, event, helper){ 
        var tNo = cmp.find("trustnumber").get("v.value");
        cmp.set('v.trustNumber',tNo);
    },
    agreementSize : function (cmp, event, helper){ 
        var aSize = cmp.find("agreementsize").get("v.value");
        cmp.set('v.trust',aSize);
    },
    agreementType : function (cmp, event, helper){ 
        var aType = cmp.find("agreementtype").get("v.value");
        cmp.set('v.agreeType', aType);        
    },
    securedbyMortgage : function (cmp, event, helper){ 
         var sbM = cmp.find("securedbymortgage").get("v.value");
         cmp.set('v.secureMortgage', sbM);           
    },
    annualTurnOver : function (cmp, event, helper){ 
        var aTO = cmp.find("annualturnover").get("v.value");
        cmp.set('v.annualTurnover', aTO);
    },
    netAssetValue : function (cmp, event, helper){ 
        var nAV = cmp.find("netassetval").get("v.value");                
        cmp.set('v.netAssetval', nAV);    
    }  
})