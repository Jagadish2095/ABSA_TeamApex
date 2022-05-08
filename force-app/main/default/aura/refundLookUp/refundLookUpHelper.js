({
    searchHelper : function(component,event,getInputkeyWord,searchbyBankName) {
    
        var getSearchKey=getInputkeyWord;
        var getBankName=searchbyBankName;
        //console.log('New In side Helper getSearchKey  ##'+ getSearchKey+'getBankName ##'+getBankName);
        var action = component.get("c.fetchLookUpValues")
        action.setParams({
            'reasonGroup': getBankName,
            'reason':getSearchKey,
            
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('res'+ JSON.stringify(storeResponse));
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