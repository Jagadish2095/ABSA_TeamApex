({
	doInit : function(component, event, helper) {	
        helper.createCaseChecklist(component);
	},   

    saveupdatecasechecklist : function(cmp, event, helper) {
       helper.showSpinner(cmp);    	
        var action = cmp.get("c.updatecasechecklist");
        	action.setParams({"caseId" : cmp.get('v.recordId'),
                              "guaranteeNoVal" : cmp.get('v.guaranteeCheck'),
                              "guaranteeDocsVal" : cmp.get('v.guaranteeDocsCheck'),
                              "collateralCapturedVal" : cmp.get('v.collateralCapCheck'),
                              "cmsLimitLoadedVal" : cmp.get('v.cmsLoadedCheck'),
                              "smsCinaJournalVal" : cmp.get('v.smsCinaJournalCheck'),
                              "journalprepVal" : cmp.get('v.journalPrepCheck'),
                              "cmslimitappVal" : cmp.get('v.cmsLimitCheck'),
                              "statuschangeVal" : cmp.get('v.statusChangeCheck'),
                              "ystatremoveVal" : cmp.get('v.statusRemovedCheck'),
                              "smsCinaMessVal" : cmp.get('v.smsCinaMessCapCheck'),
                              "secureCollatVal" : cmp.get('v.secCollatCheck'),
                              "smsCinaJournalQcVal" : cmp.get('v.smsJournalQcCheck')
                             });

         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.hideSpinner(cmp);
                var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Success",
                                message: "Case QA checklist updated successfully.",
                                duration: " 5000",
                                key: "info_alt",
                                type: "success",
                                mode: "pester"
                            });
                            toastEvent.fire();
				$A.get('e.force:refreshView').fire();                
            }
            else if (state === "ERROR") 
            {
			   var errors = response.getError();
                
				if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert ('Errors :: ' + errors[0].message);
                        console.log("Error: " + errors[0].message);
                    }
                }                
            }           
        });
        $A.enqueueAction(action);       
	},
    
    handleGuaranteeNo : function(cmp, event, helper) {
        var guaranteeNumber = cmp.find("guaranteeNo").get("v.value");
        cmp.set('v.guaranteeCheck',guaranteeNumber);        	       	   
    },
    
    handleGuaranteeDocs : function(cmp, event, helper) {
        var guaranteeDocuments = cmp.find("guaranteeDocs").get("v.value"); 
        console.log ('Guarantee DOCS :: ' + guaranteeDocuments);
        cmp.set('v.guaranteeDocsCheck',guaranteeDocuments);              
    },
    
    handleCollateralCaptured : function(cmp, event, helper) {
        var collateralCap = cmp.find("collateralCap").get("v.value");
        cmp.set('v.collateralCapCheck',collateralCap);       
    },
    
    handleCmsLimitLoaded : function(cmp, event, helper) {
         var cmslimit = cmp.find("cmsLoaded").get("v.value");
         cmp.set('v.cmsLoadedCheck',cmslimit);                
    },
    
    handlesmsCinaJournal : function(cmp, event, helper) {
        var smsCinaJnl = cmp.find("smsCinaJournal").get("v.value");
        cmp.set('v.smsCinaJournalCheck',smsCinaJnl);        
    },
    
    handlesmsCinaJournalQc : function(cmp, event, helper) {
        var smsCinaJnlQc = cmp.find("smsCjQc").get("v.value");
        cmp.set('v.smsJournalQcCheck',smsCinaJnlQc);        
    },
    
    handlejournalprep : function(cmp, event, helper) {
    	var jnlprep = cmp.find("journalPrep").get("v.value");
        cmp.set('v.journalPrepCheck',jnlprep);    	        
    },
    
    handlecmslimitapp : function(cmp, event, helper) {
        var cmslim = cmp.find("cmsLimit").get("v.value");
        cmp.set('v.cmsLimitCheck',cmslim);
    },
    
    handlestatuschange : function(cmp, event, helper) {
        var statchange = cmp.find("statusChange").get("v.value");
        cmp.set('v.statusChangeCheck',statchange);
    },
    
    handleystatremove : function(cmp, event, helper) {
        var ystatrem = cmp.find("statusRemoved").get("v.value");
        cmp.set('v.statusRemovedCheck',ystatrem);   
    },
    
    handlesmsCinaMess : function(cmp, event, helper) {
        var smscina = cmp.find("smsCinaMessCap").get("v.value");
        cmp.set('v.smsCinaMessCapCheck',smscina);
    },
    
    handlesecureCollat : function(cmp, event, helper) {
    	var secC = cmp.find("secCollat").get("v.value");
        cmp.set('v.secCollatCheck',secC);      
    }
})