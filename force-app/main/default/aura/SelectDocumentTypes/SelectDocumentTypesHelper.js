({
    getDocumentTypes : function(component,DocTypes) {
        var action = component.get("c.getDocumentTypes");
        action.setParams({            
            "oppId":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('selectedTypes',result);
                let opts = []; 
                var count = 0;
                for(var key in DocTypes){
                    if(DocTypes[key] != '--None--'){
                        let isSelected = false;
                        for(var docKey in result){
                            if(DocTypes[key] === result[docKey]){
                                isSelected = true;
                                count += 1;
                            }
                        }                    
                        opts.push({label:DocTypes[key],
                                   value:DocTypes[key],
                                   checked:isSelected}); 
                    }                    
                }
                if(count === DocTypes.length-1){
                    component.set("v.allchecked",true);
                }
                component.set("v.options",opts);
            }            
        });
        $A.enqueueAction(action);
    },
    
    saveDocs : function(component) {
        var action = component.get("c.saveDocTypes");
        var selectedDocs = [];
        var checkTypes = component.find("selectDocType");
        for(var i=0; i<checkTypes.length; i++){
            if(checkTypes[i].get("v.checked")){
                selectedDocs.push(checkTypes[i].get("v.value"));
            }
        }
        console.log('selectedDocs',selectedDocs);
        action.setParams({            
            "recordId":component.get("v.recordId"),
            "docTypes":selectedDocs
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }            
        });
        $A.enqueueAction(action);
    },
})