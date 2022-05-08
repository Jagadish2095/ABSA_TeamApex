({
    checkIsClaim : function(component, event, helper) {
      
        var Idval=  component.get("v.recordId");
        var action = component.get("c.getCaseDetails");
        action.setParams({
            recordId: Idval
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            // alert(state);
            if (state === "SUCCESS"){
                var res = response.getReturnValue();
                console.log('res',res);
                component.set('v.caseOwnership',res.Case_Ownership__c);
                component.set('v.myNewCase.Category__c',res.Category__c);
                component.set('v.myNewCase.Financial_Advisor__c','AIP ADMIN');
                component.set('v.myNewCase.X3rd_Party_Payment_Processed__c','Yes');
                this.fetchPickListVal(component, 'DD_Case_Outcome__c', 'AIPCaseOutcome', res.DD_Case_Outcome__c);
        		this.fetchPickListVal(component, 'Status', 'AIPCaseStatus',res.Status);
				this.fetchPickListVal(component, 'Related_Business_Area__c', 'businessArea', res.Related_Business_Area__c);
                component.set('v.caseStatus',res.Status);
                component.set('v.aipcaseStatus',res.Status);
                component.set('v.caseOutcome',res.DD_Case_Outcome__c);
                component.set('v.caseArea',res.Related_Business_Area__c);
                component.set('v.caseOwnerId',res.OwnerId);
                component.set('v.accountId',res.AccountId);
                if(res.Case_Ownership__c == 'Route'){
                    component.set('v.myNewCase.Category__c','Proof of insurance');                    
                }
        		
                if(res.Category__c != null && res.Category__c == 'Claims'){
                    component.set('v.isClaim',true);
                    console.log("v.isClaim: " + component.get("v.isClaim"));
                }                           
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    generateClaimDocument : function(component, event, helper) {
      
        var recordId=  component.get("v.recordId");
        var action = component.get("c.generateCaseDocument");
        action.setParams({
            recordId: recordId,
            templateName: 'Claims letter - Brolink'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                 console.log('Document Generated');      
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });        
        $A.enqueueAction(action);
    },
    
    sendClaimDocument : function(component, event, helper) {
      
        var recordId=  component.get("v.recordId");
        var action = component.get("c.SendMailWithDocument");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                 console.log('Document Send Successfully.');      
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });        
        $A.enqueueAction(action);
    },
    
     showSpinner: function (component) {
         debugger;
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getToast : function(title, msg, type, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    fetchPickListVal: function(component, fieldName, elementId,fieldValue) {
		var ownership = component.get('v.caseOwnership');
		var action = component.get('c.getselectOptions');
		var caseBusinessArea = component.get('v.myNewCase.Category__c');
		action.setParams({
			objObject: component.get('v.caseMatrix'),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
				var allValues = response.getReturnValue();
				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
				}
                console.log("SELECT FIELD VALUE: " + component.get("v.myNewCase.DD_Case_Outcome__c"));
				for (var i = 0; i < allValues.length; i++) {
                    var isSelected = false;
                    console.log("isSelected: " + isSelected);
                    if(allValues[i] == fieldValue){
                        	isSelected = true;
                   		}
                    console.log("isSelected: " + isSelected);
                    console.log("fieldValue: " + fieldValue);
					opts.push({
						class: 'optionClass',
						label: allValues[i],
						value: allValues[i],
                        selected: isSelected
                        
					});
				}
                console.log('ownership',ownership);
				if (elementId == 'AIPCaseOutcome') {
                    for (var i = 1; i < opts.length; i++) {
                        if(ownership == 'Route'){
                           	if(opts[i].value != 'Insurance Validated' && opts[i].value != 'Forced Debit Required'
                              && opts[i].value != 'Load Forced Debit' && opts[i].value != 'Account Settled'
                              && opts[i].value != 'Vehicle Written off' && opts[i].value != 'Vehicle not driveable'
                              && opts[i].value != 'Proof of insurance awaited'){
                            	opts.splice(i,1);
                            	i--;
                        	}  
                        }
                        else if(ownership == 'I will Resolve' || ownership == '' || ownership == undefined){
                            if(opts[i].value != 'Insurance Validated' && opts[i].value != 'Proof of insurance awaited'
                              && opts[i].value != 'Load Forced Debit'){
                            	opts.splice(i,1);
                            	i--;
                        	}  
                        }                                                  
                    }
                    
					component.set('v.OutcomeOptions', opts);
				} else if (elementId == 'AIPCaseStatus') {
                    for (var i = 1; i < opts.length; i++) {
                        if(ownership == 'Route'){
                           	if(opts[i].value != 'Closed' && opts[i].value != 'Proof to be sent'){
                            	opts.splice(i,1);
                            	i--;
                        	}  
                        }
                        else if(ownership == 'I will Resolve' || ownership == '' || ownership == undefined){
                            console.log('caseBusinessArea',caseBusinessArea);
                            if(caseBusinessArea == 'Complaint'){
                                if(opts[i].value != 'In Progress' && opts[i].value != 'Closed' 
                                   && opts[i].value != 'Not Started'){
                            		opts.splice(i,1);
                            		i--;
                        		}
                            }
                            else {
                            	if(opts[i].value != 'In Progress' && opts[i].value != 'Closed'){
                            		opts.splice(i,1);
                            		i--;
                        		}  
                        	} 
                        }                            
                    }
					component.set('v.StatusOptions', opts);
				}
                debugger;
				if (elementId == 'businessArea') {
                    for (var i = 1; i < opts.length; i++) {
                        if(caseBusinessArea == 'Complaint'){
                           	  if(opts[i].value != 'Unauthorized Debit Order' && opts[i].value != 'SMS Wording'
                              && opts[i].value != 'Refund to Vehicle Account' && opts[i].value != 'Proof of Insurance Not Received'
                              && opts[i].value != 'No Communication Received' && opts[i].value != 'No SMS Received'
                              && opts[i].value != 'No Call Made' && opts[i].value != 'Manager Call' && opts[i].value != 'Refund'){
                            	opts.splice(i,1);
                            	i--;
                        	} 
                        }
                        else if (caseBusinessArea != 'Complaint'){
                            if(opts[i].value != 'General Query' && opts[i].value != 'Refund'){
                            	opts.splice(i,1);
                            	i--;
                        	}
                        }                                                  
                    }
                    console.log('AREA Options: ' + JSON.stringify(opts));
					component.set('v.areaOptions', opts);
				}
                
			}
		});
		$A.enqueueAction(action);
	},
    
    updateCase: function(component, event, helper){
        var response = event.getSource().getLocalId();
        var ownerId = component.get("v.caseOwnerId");
        var accId = component.get("v.accountId");
        var status = component.get("v.caseStatus");
        var aipstatus = component.get("v.aipcaseStatus");
        var outcome = component.get("v.caseOutcome");
        debugger;
       if(ownerId.startsWith("00G")){
            helper.hideSpinner(component);
            var toastEvent = this.getToast("Error!","Case cannot be modified when assigned to a queue.", "error",helper);
            toastEvent.fire();
            $A.get('e.force:refreshView').fire();
            return null;
        }
        else if(accId == "" || accId == undefined){
            helper.hideSpinner(component);
            var toastEvent = this.getToast("Error!", "Case cannot be modified without linking to a client.", "error",helper);
            toastEvent.fire();
            $A.get('e.force:refreshView').fire();
            return null;
        } 
        else if(aipstatus == 'Closed'){
            helper.hideSpinner(component);
            var toastEvent = this.getToast("Error!", "Case is already Closed.", "error",helper);
            toastEvent.fire();
            $A.get('e.force:refreshView').fire();
            return null;
        } 
        if(response!='BACK' ){
            var currentFlowName = component.get('v.selectedProcessNameFromFlow');
            var caseObj = component.get('v.myNewCase');
            var respOutcome = component.get('v.caseOutcome');
            caseObj.Id = component.get("v.recordId");
            caseObj.Status = component.get("v.caseStatus");
            if(respOutcome == 'Insurance Validated'){
                caseObj.Status = 'Closed';
            }
            caseObj.Related_Business_Area__c = component.get("v.caseArea");
            var temp = component.get("v.caseOutcome");
            caseObj.DD_Case_Outcome__c = component.get("v.caseOutcome");
            if(currentFlowName =='declarationInfo'){
               caseObj.isConsentConfirmed__c = component.find('isConsentConfirmed__c').get('v.value');
                if(caseObj.isConsentConfirmed__c == false){
                     helper.hideSpinner(component);
                    var toastEventErr = this.getToast("Warning!","Please accept declaration", "warning",helper);
                    toastEventErr.fire();
                    $A.get('e.force:refreshView').fire(); 
                    return null;
                }    
            }
            if(component.find('fieldInput')!=undefined){
            var allValid = component.find('fieldInput').reduce(
                function(validSoFar, inputCmp) 
                {
                    return (validSoFar && inputCmp.reportValidity());
                }, true);
            }
            else 
                allValid = true;
            if(allValid){
                if(caseObj.isConsentConfirmed__c){
                    this.generateClaimDocument(component, event, helper);
                    this.sendClaimDocument(component, event, helper);
                    caseObj.Status = 'Closed';
                    caseObj.isClosed = true;
                }
                	
                var action = component.get("c.updateCaseDetails");
                
                console.log("JSON: " + JSON.stringify(caseObj));
                action.setParams({
                    caseRec: JSON.stringify(caseObj)
                });
                action.setCallback(this, function(result) {
                    var state = result.getState();
                    
                    // alert(state);
                    if (state === "SUCCESS"){
                        var response = event.getSource().getLocalId();
                        component.set("v.value", response);
                        if(response=='NEXT' ){
                            var navigate = component.get("v.navigateFlow");
                            navigate(response);
                        }
                        else{
                            helper.hideSpinner(component);
                            var toastEvent = this.getToast("Success!","Case has been updated Successfully", "success",helper);
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                            this.checkIsClaim(component, event, helper);
                        }
                    }else {
                        helper.hideSpinner(component);
                        console.log("Failed with state: " + JSON.stringify(response));
                        var toastEvent = this.getToast("Error!","Case cannot be updated", "error",helper);
                            toastEvent.fire();
                            $A.get('e.force:refreshView').fire();
                    }
                });
                
                $A.enqueueAction(action);
            }
            else{
                helper.hideSpinner(component);
            }
        }
        else {            
            var navigate = component.get("v.navigateFlow");
            navigate(response);          
        }
        
    }
    
})