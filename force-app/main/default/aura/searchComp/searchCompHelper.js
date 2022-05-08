({
    searchHelper : function(component,event,getInputkeyWord) {        
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                //alert(storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
      //Vikaschand Balusu added begin
    searchHelper2 : function(component,event,getInputkeyWord) {        
        var action = component.get("c.fetchLookUpValuesuser");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : 'User'
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log('state--->'+ state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('response--->'+ JSON.stringify(storeResponse));
               
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords2", storeResponse);
            }
            
        });
        $A.enqueueAction(action);
    },
    //Vikaschand Balusu added End
  
    getBranchDetails : function(component,event,helper,selectdValues) {
       // alert('selected values'+selectdValues)
        let  TargetselectdValues=selectdValues;
        // call the apex class method 
        var action = component.get("c.getF2FAdvInfo");
        // set param to method  
        action.setParams({
            'searchKeyWord': selectdValues,
            
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.table(storeResponse);
                if (storeResponse.length == 0) {
                    console.log('Not able fetch branch details')
                    component.set("v.showErrorMsg",true);
                } else {
                    var res = response.getReturnValue();
                    //alert(JSON.stringify(res))
                    component.set("v.showBranchdetailsLst", res);
                    let result=component.get("v.showBranchdetailsLst.mapUserSites");
                    
                    var arrayMapKeys = [];
                    for(var key in result){
                        
                        arrayMapKeys.push({key: key, value: result[key]});
                        
                    }
                   
                    // alert(JSON.stringify(result))
                    // set searchResult list with return value from server.
                    component.set("v.showBranchdetailsLstMAp", arrayMapKeys);
                    component.set("v.showBranchdetails",true);
                   
                   
                }
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    callServerMethod : function(component,event,helper,methodName,attributeName,methodParameters) {
        var methodRef=component.get(methodName);
        if(methodParameters){
            methodRef.setParams(methodParameters);
        }
        
        methodRef.setCallback(this,function(response){
            if(response.getState() ==='SUCCESS'){
                alert('USER DETALS'+JSON.stringify(response.getReturnValue()))
                console.table(response.getReturnValue());
                component.set(attributeName,response.getReturnValue());
                let storeResponse=response.getReturnValue()
                //   alert(storeResponse)
                if (storeResponse.length == 0) {
                    console.log('Not able fetch branch details')
                } else {
                    
                    // set searchResult list with return value from server.
                    component.set("v.attributeName", storeResponse);
                    
                }
                
            }
        });
        
        $A.enqueueAction(methodRef);   
    },
    
})