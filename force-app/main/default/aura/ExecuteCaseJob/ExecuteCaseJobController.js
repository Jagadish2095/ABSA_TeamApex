({
        getCasedetails : function(component, event, helper) { 

                //helper.getcasewithservicetype(component);
                var flow = component.find("flowtoberendered");
                var action = component.get("c.CaseDetails");

                action.setParams({ 
                    caseId : component.get("v.recordId") 
                });
                
                action.setCallback(this, function(response) {

                    var state = response.getState();
                    
                    if (state === "SUCCESS") {
                    
                        var responsewrapobj = response.getReturnValue();
                        
                        component.set('v.caseStatus', responsewrapobj.caseobj.Status);
                        var accountId = responsewrapobj.caseobj.AccountId;
                       
                        if(accountId){
                            component.set('v.hasAccountLinked', true);
                        }else{
                            component.set('v.hasAccountLinked', false);
                        }
                        
                        var flowname =  responsewrapobj.sgtobj.Flow__c;

                        if(flowname && flow){

                            component.set("v.hasFlow", true);

                            var inputVariables = [{ name : "recordId", type : "String", value: component.get("v.recordId")}];
                            flow.startFlow(flowname,inputVariables); 
                        
                        }else if(!flowname){
                            
                            component.set("v.hasFlow", false);
                            
                        }
                    }else{
                        component.set("v.hasFlow", false);   
                    }
                });

                $A.enqueueAction(action);
        },
        handleCaseEvent : function(component, event, helper) { 

                helper.showSpinner(component);

                var selectedJob = event.getParam("selectedJob");
                var caseId = component.get("v.recordId");

                var action = component.get("c.classifyCase");
        
                action.setParams({
                    "caseRecordId" : caseId,
                    "serviceGroupType" : selectedJob
                });
                        
                action.setCallback(this, $A.getCallback(function (response) {
        
                    var state = response.getState();
                            
                    if (state === "SUCCESS") {

                        var toast = helper.getToast("Success", "Case Classified based on the job selection", "success");
                
                        helper.hideSpinner(component);
        
                        toast.fire();
        
                        $A.get('e.force:refreshView').fire();
            
                            
                    } else if (state === "ERROR") {
            
                        var toast = helper.getToast("Error", "There was an error classifying the case, based on the job you have selected", "error");
                        
                        helper.hideSpinner(component);
                        
                        toast.fire();
                    }
                }));
        
                if(component.get("v.hasAccountLinked")){

                    $A.enqueueAction(action);

                }else{

                    var toast = helper.getToast("Error", "Please link this Case to the relavant Account first", "error");

                            
                    helper.hideSpinner(component);
                    
                    toast.fire(); 

                    $A.get('e.force:refreshView').fire();
                }
                
        }
})