({
	 doInit : function(component, event, helper) {
       
        
        var action = component.get("c.getproductTOB");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results success or error---'+JSON.stringify(results));
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---'+JSON.stringify(results));
                component.set("v.appProdTobList",results);
                component.set("v.showSpinner",false);
                
            }
            //component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
        
        
    },
    
   
    
    handleSuccess : function(component, event, helper){
        
        var insertedRecord = event.getParams().response;
        console.log("insertedRecord---"+insertedRecord.id);
        
        var action = component.get("c.submitDecisionHistory");
        action.setParams({
            "prodId": insertedRecord.id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //console.log('results success or error---'+JSON.stringify(results));
            if (state === "SUCCESS") {
                //var results = response.getReturnValue();
               // console.log('results---'+JSON.stringify(results));
                 component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        		});
			component.set("v.showSpinner",true);
              $A.get("e.force:refreshView").fire();  
            }
        });
        $A.enqueueAction(action);
        
         
           },
    
    saveAll : function(component, event, helper){
        
        component.find('tobEdit').forEach(form=>{form.submit();
                                                 
                                                });
                                                 
                                                 component.find('notifLib').showToast({
                                                 "title": "Adjustment Saved!",
                                                 "message": "Adjustment has been saved successfully.",
                                                 "variant": "success"
                                                });                                  
    },
    setLimitTypeChanged :function(component, event, helper){
        var target = event.getSource();
        console.log("target--"+target);
        var selectCmp = target.get("v.value");
        console.log("changed---"+selectCmp);
        
        component.set("v.selectedValues",selectCmp);
        
       var rowIndex = target.get("v.class");
        console.log("Row No : " + rowIndex);
        
        component.set("v.iterationIndex",rowIndex);
        
        /*var prodId = component.find("productRecordId").get("v.value");
        console.log('product Id--'+prodId);*/
    },
})