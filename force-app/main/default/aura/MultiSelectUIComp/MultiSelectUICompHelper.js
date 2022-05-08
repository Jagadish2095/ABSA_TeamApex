({
    
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var objectAPIName =  component.get("v.objectAPIName");
        if(objectAPIName=='OnboardingSalesProcessType'){
            var lstSelectedRecords = component.get("v.lstSelectedRecords");
            var listOfSearchRecordsMain = component.get("v.listOfSearchRecordsMain");
            var listOfSearchRecords = component.get("v.listOfSearchRecords");
            //if(lstSelectedRecords.length>0){
                var newlistOfSearchRecords =[];
                var found = false;
                //var len = lstSelectedRecords.length;
                for(var i=0;i<listOfSearchRecordsMain.length;i++){
                    found = false;
                    if(lstSelectedRecords.length>0){
                    for(var j=0;j<lstSelectedRecords.length;j++){
                        if(lstSelectedRecords[j].Name==listOfSearchRecordsMain[i].Name){
                            found = true;  
                        }
                    }}
                    if(found==false){
                        if(getInputkeyWord=='' || getInputkeyWord==null || getInputkeyWord.length==0){
                           newlistOfSearchRecords.push(listOfSearchRecordsMain[i]); 
                        }
                        else if(getInputkeyWord.length>0){
                           var str = listOfSearchRecordsMain[i].Name;
                           var n = str.toLowerCase().includes(getInputkeyWord.toLowerCase());
                            if(n==true){
                             newlistOfSearchRecords.push(listOfSearchRecordsMain[i]);   
                            }
                        }
                      
                      
                    }
                }
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                component.set("v.listOfSearchRecords",newlistOfSearchRecords);
                if(newlistOfSearchRecords.length==0){
                component.set("v.Message", 'No Records Found...');
                }
                else{
                 component.set("v.Message", '');   
                }
            
        }
        else{
            var action = component.get("c.fetchLookUpValues");
            // set param to method  
            action.setParams({
                'searchKeyWord': getInputkeyWord,
                'ObjectName' : component.get("v.objectAPIName"),
                'ExcludeitemsList' : component.get("v.lstSelectedRecords")
            });
            // set a callBack    
            action.setCallback(this, function(response) {
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                    if (storeResponse.length == 0) {
                        component.set("v.Message", 'No Records Found...');
                    } else {
                        component.set("v.Message", '');
                        // set searchResult list with return value from server.
                    }
                    component.set("v.listOfSearchRecords", storeResponse); 
                }
            });
            // enqueue the Action  
            $A.enqueueAction(action);
        }},
    
})