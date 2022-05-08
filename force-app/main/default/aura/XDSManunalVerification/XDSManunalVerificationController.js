({
	save : function (component, event, helper){
        //get all the inputs from form
        var verifyby = component.get("v.verifyby");
        var XDSDate = component.get("v.XDSDate");
        var recordId = component.get("v.recordId");
        //Error handling: if any field is undefined
        if(verifyby == undefined || XDSDate == undefined)
        {
         helper.showToast('Something Wrong !', 'Please fill up all the information', 'error');
        }
        else
        {
    //if everything is Okay then make server call   
      var action = component.get("c.saveAccount"); 
         action.setParams({
           'verifyby' : verifyby, 
           'XDSDate' : XDSDate,
             'recordId': recordId 
            }); 
     action.setCallback(this,function(response){
     var state = response.getState();
 //if callback is Success then show toast message and close the modal popup
         if(state === "SUCCESS")
         {
//pass parameters to helper showToast method  
  helper.showToast('Success !', 'Record Inserted Successfully', 'success');
           $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();

         }
       });
          $A.enqueueAction(action);
      }  
    },
    
    cancel : function(component, helper, event)
    {
        //Below line of code will close the modal popup
        $A.get("e.force:closeQuickAction").fire();   
    }
})