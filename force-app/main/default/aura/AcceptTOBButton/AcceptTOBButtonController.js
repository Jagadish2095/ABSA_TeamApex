({
    
    
    doInit : function(component, event, helper){
       // component.set("v.changedValue","v.prodrec.isaccepted");
    },
	 handleSuccess : function(component, event, helper){
        //component.set("v.showSpinner",true);
          component.set("v.changedValue",true);
          component.find('productEdit').submit(); 
        /* component.find('productEdit').forEach(form=>{form.submit();
                                                 
                                                });
       
          */                                            
        component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        });
      //$A.get('e.force:refreshView').fire();  
    },
})