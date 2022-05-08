({
    getProductFamilyList : function(component, event, helper) {
        
        var action = component.get("c.getmultiselectpicklistvaluesforproductfamilies"); //Calling Apex class controller 'getmultiselectpicklistvaluesforproductfamilies' method
        var recordId = component.get("v.recordId");
        // set param to method  
        action.setParams({
            'ObjectName' : 'OnboardingSalesProcessType',
            'OpportunityId' : recordId
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    //component.set("v.Message", 'No Records Found...');
                    component.set("v.listOfSearchRecordsMain", storeResponse);
                } else {
                    //component.set("v.Message", '');
                    // set searchResult list with return value from server.
                    var list1=[];
                    for(var i=0;i<storeResponse.length;i++){
                        list1.push({Id:storeResponse[i], Name:storeResponse[i]});
                        
                    }
                    component.set("v.listOfSearchRecordsMain", list1);
                }
                
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);        
    },
    saveSelectedProduct: function (component, event, helper) {
        component.find("saveProductBtn").set("v.disabled", true);
        var product = component.get("v.selectedLookUpRecords");
        var str='';
        if(product!=null && product.length>0){
            for(var p=0;p<product.length;p++){
                if(str==''){
                    str+=product[p].Name;
                }
                else{
                    str+=','+ product[p].Name;
                }
            }} 
        var illdecs = false;
            if(component.get("v.illustrativeDecision")){
                illdecs = true;
            }
        var action = component.get("c.saveOpportunityproductfamily");
        // console.log('product.Id: ' + product.Name);
           action.setParams({
                oppId: component.get("v.recordId"),
                productfamily: str,
                illustrativeDecision : illdecs
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    var userSite = returnValue['userSite'];
                    
                    if (userSite) {
                        component.set("v.userSite", userSite);
                    }
                    
                        component.set("v.SelectedProduct", str);
                        $A.get('e.force:refreshView').fire(); //Refresh the page once reocrd is Created Successfully
                        helper.fireToast("Success!", "Product Family updated successfully.", "success");
                    
                    component.find("saveProductBtn").set("v.disabled", false);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    component.find("saveProductBtn").set("v.disabled", false);
                    helper.fireToast("Error!", "Something went wrong. Error: " + JSON.stringify(errors), "error");
                    
                } else {
                    component.find("saveProductBtn").set("v.disabled", false);
                    helper.fireToast("Error!", "Something went wrong.", "error");
                }
            });
            $A.enqueueAction(action);
        
        
        
    },
    
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type
        });
        toastEvent.fire();
    },
    //Added By Himani Joshi
    getOpp: function (component, event, helper) {
      var action = component.get("c.getOpportunity");
        action.setParams({
            oppId: component.get("v.recordId"),
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var opp = response.getReturnValue();
                component.set('v.illustrativeDecision',opp.Illustrative_Decision__c);
                console.log('illustrativeDecision'+component.get('v.illustrativeDecision'));
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('errors: ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    }
})