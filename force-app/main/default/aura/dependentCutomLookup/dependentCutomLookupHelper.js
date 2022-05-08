({
    searchHelper : function(component,event,getInputkeyWord,searchbyBankName) {
    
        var getSearchKey=getInputkeyWord;
        var getBankName=searchbyBankName;
        //console.log('New In side Helper getSearchKey  ##'+ getSearchKey+'getBankName ##'+getBankName);
        var action = component.get("c.fetchDependentLookUpValues")
        action.setParams({
            'branchSearch': getSearchKey,
            'bankName': getBankName,
            
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                /*var jsonstr= JSON.stringify(storeResponse);
                var jsonpar=JSON.parse(jsonstr);
                var arr = [];
                
                for(var x in jsonpar){
                    
                    arr.push(jsonpar[x]);
                } */
                
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0 ) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                   
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfBranchRecords", storeResponse);
 
            }
            
        });
       
        $A.enqueueAction(action);
        
    },
})