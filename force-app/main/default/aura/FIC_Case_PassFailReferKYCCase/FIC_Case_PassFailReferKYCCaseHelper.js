({
    getCase: function(component, event, helper) {
        let action = component.get("c.getCase");
        action.setParams({
            "caseId":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.Case', responseData);
                    console.log(responseData)
                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getDocumentsOrder: function(component, event, helper) {
        let action = component.get("c.getDocumentsOrder");
        action.setParams({
            "caseId":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.notAllDocsInOrder', responseData);
                    console.log(responseData)
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleReferral: function(component, event, helper) {
        component.set('v.Spinner',true);
        let caseToPass = component.get("v.Case");
        let reason = component.find("referralReason");
        let addInfo = component.find("refAdditionInfo");
        let action = component.get("c.updateCaseToReferred");
        caseToPass.Additional_Information__c = addInfo.get("v.value")
        caseToPass.Referral_Reason__c = reason.get("v.value");
        if(caseToPass.Case_Record_Type_Name__c=='AOL'){
            let category = component.find("category");
            let caseoutcome = component.find("caseoutcome");
            caseToPass.Category__c = category.get("v.value");  
            caseToPass.DD_Case_Outcome__c = caseoutcome.get("v.value");  
        }
        action.setParams({
            "caseToAssign": caseToPass,
            "status": 'Referred',
            "isFailed": false,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                    component.set('v.Case', responseData);
                     //component.find("formReferral").submit();
                       component.set("v.openReferral", false);
                         $A.get('e.force:refreshView').fire();
                         component.set('v.Spinner',false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                         helper.fireToast('Error', errors[0].message , "error");
                         component.set('v.Spinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set('v.Spinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleFail: function(component, event, helper) {
        component.set('v.Spinner',true);
         let caseToPass = component.get("v.Case");
          let reason = component.find("failReason");
                let addInfo = component.find("failAdditional");
                let addInfoText = component.find("failComments");
                 caseToPass.Fail_Additional_Information__c = addInfo.get("v.value")
                 caseToPass.Fail_Reason__c = reason.get("v.value")
              caseToPass.FIC_Case_FailedComments__c = addInfoText.get("v.value")

              let caseStatus = caseToPass.Case_Record_Type_Name__c=='AIC'?'Awaiting Documents':'Return';
        let action = component.get("c.updateCaseToReferred");
        
        action.setParams({
            "caseToAssign": caseToPass,
            "status": caseStatus,
            "isFailed": true,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                
               component.set('v.Case', responseData);
               component.find("formFail").submit();
               component.set("v.openFail", false);
               component.set('v.Spinner',false);
             $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                         helper.fireToast('Error', errors[0].message , "error");
                         component.set('v.Spinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set('v.Spinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handlePass: function(component, event, helper) {
        component.set('v.Spinner',true);
     let action = component.get("c.updateCaseToReferred");
       let caseToPass = component.get("v.Case");
       console.log(caseToPass)

		let caseStatus = caseToPass.Case_Record_Type_Name__c=='AIC'?'Resolved':'Closed';
        action.setParams({
            "caseToAssign": caseToPass,
            "status": caseStatus,
            "isFailed": false,


        });        
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                     //component.find("Pass").submit();
                component.set("v.openPass", false);
                component.set('v.Spinner',false);
                helper.fireToast('Document successfully processed', 'Case no. ' + caseToPass.CaseNumber , 'success');
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                           helper.fireToast('Error', errors[0].message , "error");
                           component.set('v.Spinner',false);
                    }
                } else {
                    console.log("Unknown error");
                    component.set('v.Spinner',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    ifDocumentAreFulfill : function(component, event, helper){
       // component.set('v.Spinner',true);
        let action = component.get("c.checkFailReason");
              action.setParams({
                  "caseId":component.get("v.recordId")
              });

              action.setCallback(this, function(response) {
                  let state = response.getState();
                  let responseData = response.getReturnValue();
                  if (state === "SUCCESS") {
                      if (!$A.util.isEmpty(responseData)) {
                            if(responseData.allReasonAreFulfill == false){
                                 helper.fireToast('Incomplete case', 'The case cannot be processed until the document under '+ responseData.tab.replace('Fic','') +
                                  ' has been verified and validation option selected.', 'error');
                            } else{
                             component.set("v.openPass", true);
                             }
                      }
                      component.set('v.Spinner',false);
                  } else if (state === "ERROR") {
                      let errors = response.getError();
                      if (errors) {
                          if (errors[0] && errors[0].message) {
                              console.log("Error: " + errors[0].message);
                              component.set('v.Spinner',false);
                          }
                      } else {
                          console.log("Unknown error");
                          component.set('v.Spinner',false);
                      }
                  }
              });
              $A.enqueueAction(action);
    },
     fireToast: function(title, msg, type) {
          let toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "title": title,
              "message": msg,
              "type": type
          });
          toastEvent.fire();
      },

})