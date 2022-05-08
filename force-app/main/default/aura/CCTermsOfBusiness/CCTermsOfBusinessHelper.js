({
    
    getCCTOB : function(component,event){
        var action = component.get("c.getCCProductTOB");
        var OppId = component.get("v.recordId");
        console.log('@@ OppId ---'+JSON.stringify(OppId));
        action.setParams({
            "oppId": OppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('CC getCCTOB ---'+JSON.stringify(results));
                if(results){ 
                    var viewA = component.get("v.acceptView");
                    if(viewA){
                        var acceptedResults =[];
                        for(var i=0;i<results.length;i++){
                            console.log('result status---'+results[i].appProduct.Product_Status__c);
                            if(results[i].appProduct.Product_Status__c == 'Accepted' ){//&& results[i].isacceptedApplicationLevel
                                console.log('putting accepted product only');
                                acceptedResults.push(results[i]);
                            } 
                        }
                      component.set("v.appProdTobList",acceptedResults);   
                    }else{
                       component.set("v.appProdTobList",results); 
                    }
                   // component.set("v.appProdTobList",results);
                    component.set("v.showSpinner",false);  
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    saveAll : function(component, event, helper){
        event.preventDefault();
         var approver = component.get("v.simpleRecord");
           var approverId= approver.Approval_Owner__c;
           var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(approverId==null || approverId!=userId){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{
        component.set("v.showSpinner",true);
        
        component.find('CCtobEdit').forEach(form=>{
            form.submit();
                                                 
                                                });
            
        
        }                                      
        
    },
})