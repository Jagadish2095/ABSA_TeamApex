({
	createCaseChecklist : function(component,event,helper) {
        var action = component.get("c.createcasechecklist");
        action.setParams({
            "caseId" : component.get('v.recordId'),
             "Q1" : component.get('v.preissueq1'),"Q2" : component.get("v.preissueq2"),
             "Q3" : component.get("v.preissueq3"),"Q4" : component.get("v.preissueq4"),
             "Q5" : component.get("v.preissueq5"),"Q6" : component.get("v.preissueq6"),
             "Q7" : component.get("v.preissueq7"), "Q8" : component.get("v.preissueq8"),
             "Q9" : component.get("v.preissueq9"),"Q10" : component.get("v.preissueq10"),
             "Q11" : component.get("v.preissueq11")
        });
   
         action.setCallback(this, function(response) {
              var state = response.getState(); 
              
              if (component.isValid() && state === "SUCCESS"){
                  var result = JSON.stringify(response.getReturnValue());
                  console.log('result----'+result);
                  var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Success",
                                message: "Case Pre-Issuing checklist updated successfully.",
                                duration: " 5000",
                                type: "success",
                            });
                            toastEvent.fire();
                  component.set("v.showSpinner", false);
            }
              
         });   
        $A.enqueueAction(action);		
	},
    createCaseQAchecklist : function(component,event,helper) {
        var action = component.get("c.CreateCaseQAChecklist");
        action.setParams({
            "caseId" : component.get('v.recordId'),
             "Q1" : component.get('v.QAcheckq1'),"Q2" : component.get("v.QAcheckq2"),
             "Q3" : component.get("v.QAcheckq3"),"Q4" : component.get("v.QAcheckq4"),
             "Q5" : component.get("v.QAcheckq5"),"Q6" : component.get("v.QAcheckq6"),
             "Q7" : component.get("v.QAcheckq7"), "Q8" : component.get("v.QAcheckq8"),
             "Q9" : component.get("v.QAcheckq9"),"Q10" : component.get("v.QAcheckq10"),
             "Q11" : component.get("v.QAcheckq11")
        });
   
         action.setCallback(this, function(response) {
              var state = response.getState(); 
              
              if (component.isValid() && state === "SUCCESS"){
                  var result = JSON.stringify(response.getReturnValue());
                  console.log('result----'+result);
                  var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "Success",
                                message: "Case QA checklist updated successfully.",
                                duration: " 5000",
                                type: "success",
                            });
                            toastEvent.fire();
                  component.set("v.showSpinner", false);
              }
         });   
        $A.enqueueAction(action);		
	},
     fetchCaseChecklistRec :function(component, event, helper) {
        var action = component.get("c.getcasechecklistRecords");
        action.setParams({
            "caseId": component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var checklistRec = JSON.stringify(response.getReturnValue());
                var rec=response.getReturnValue();
                var item;
                for (var i=0; i< rec.length; i++)
        		{
                     item =rec[i];
                   if(item.Case_checklist_question__c=='Is the Name of the of the Application the same as what is on the CIF'){
                        component.set("v.preissueq1",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the Card type captured correctly'){
                        component.set("v.preissueq2",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the embossed line for the Control Account captured correctly'){
                        component.set("v.preissueq3",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the embossed line for the User Account captured correctly'){
                        component.set("v.preissueq4",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the statement delivery option captured correctly on CAMN'){
                        component.set("v.preissueq5",item.Validate__c);}
                    if(item.Case_checklist_question__c=='The additional user card is linked to the correct control/main account'){
                        component.set("v.preissueq6",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the debit order captured correctly'){
                        component.set("v.preissueq7",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Is the delivery instruction correct'){
                        component.set("v.preissueq8",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Were the limits captured correctly'){
                        component.set("v.preissueq9",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was memolines placed where applicable'){
                        component.set("v.preissueq10",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Is the credit approval correct'){
                        component.set("v.preissueq11",item.Validate__c);}
                    
                    if(item.Case_checklist_question__c=='Is the Name of the of the Application the same as what is on the CIF(QA)'){
                        component.set("v.QAcheckq1",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the Card type captured correctly(QA)'){
                        component.set("v.QAcheckq2",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the embossed line for the Control Account captured correctly(QA)'){
                        component.set("v.QAcheckq3",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the embossed line for the User Account captured correctly(QA)'){
                        component.set("v.QAcheckq4",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the statement delivery option captured correctly on CAMN(QA)'){
                        component.set("v.QAcheckq5",item.Validate__c);}
                    if(item.Case_checklist_question__c=='The additional user card is linked to the correct control/main account(QA)'){
                        component.set("v.QAcheckq6",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was the debit order captured correctly(QA)'){
                        component.set("v.QAcheckq7",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Is the delivery instruction correct(QA)'){
                        component.set("v.QAcheckq8",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Were the limits captured correctly(QA)'){
                        component.set("v.QAcheckq9",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Was memolines placed where applicable(QA)'){
                        component.set("v.QAcheckq10",item.Validate__c);}
                    if(item.Case_checklist_question__c=='Is the credit approval correct(QA)'){
                        component.set("v.QAcheckq11",item.Validate__c);}
        		}
            }
            });
        	$A.enqueueAction(action);
    },
    
})