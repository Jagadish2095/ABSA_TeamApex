({
    doInit : function(component, event, helper) {
        helper.getSelProduct(component, event);
        helper.setTobFields(component, event);
        helper.getAcceptedTOB(component, event);
        
        
    },
    
    
    saveAll : function(component, event, helper){ 
        
        /*component.find('productEdit').forEach(form=>{form.submit();
                                                 
                                                });*/
                                                     
              var appEvent = $A.get("e.c:initializeCmpDataEvent"); //fired fulfillment component once again
                                                     
                 appEvent.fire(); 
                                                     
                                                 
         },
                                                     
    handleSuccess : function(component, event, helper){
        component.set("v.showSpinner",true);
         component.find('productEdit').forEach(form=>{form.submit();
                                                 
                                                });
        helper.getAcceptedTOB(component, event);
                                                      
        component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        });
      //$A.get('e.force:refreshView').fire();  
    },
     
   
})