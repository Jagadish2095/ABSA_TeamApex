({
   

        promiseFetchUsers : function(component) {
        return this.createPromise(component, "c.fetchUserData", {groupId: component.get("v.publicGroupSearchId")});
        },
    
        createPromise : function(component, name, params) {
            return new Promise(function(resolve, reject) {
                    let action = component.get(name);
                    if (params) {
                            action.setParams(params);
                    }
                    action.setCallback(this, function(response) {
                            let state = response.getState();
                            if (component.isValid() && state === "SUCCESS") {
                                    let result = response.getReturnValue();
                                    resolve(result);
                            }
                            else {
                                    reject(response.getError());
                            }
                    });
                    $A.enqueueAction(action);
            });
    },
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
     
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
                return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
    
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['FirstName','LastName','UserRole','Profile','BRID__c','Id' ];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
    
        for(var i=0; i < objectRecords.length; i++){   
                counter = 0;
             
                 for(var sTempkey in keys) {
                        var skey = keys[sTempkey] ;  
    
                    // add , [comma] after every String value,. [except first]
                            if(counter > 0){ 
                                    csvStringResult += columnDivider; 
                             }   
                     
                     csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                     
                     counter++;
    
                } // inner for loop close 
                 csvStringResult += lineDivider;
            }// outer main for loop close 
     
     // return the CSV formate String 
        return csvStringResult;        
    },
    
        openOrCloseModal : function(component, event, isOpen) {
            
            var orpenOrClose = component.set("v.openModal", isOpen);
        }

})