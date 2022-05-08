({
	init : function(component){

        var flow = component.find("flowData");

        var flowNameVal = component.get("v.flowName");
        var flowNameRecordId = component.get("v.recordId");
       
     
        var inputVariables = [{
            name : 'recordId',
            type : 'String',
            value : flowNameRecordId
           }];

        flow.startFlow(flowNameVal,inputVariables);
       
       
    },
    
      statusChange : function (cmp, event,helper) {

          var Att = cmp.get("v.stages");
          Att = event.getParam('activeStages');
          
          //getting currentStage and activeStages parameters from the "StatusChanged" event and   
        //updating the currentStage and activeStages attributes in the markup.  
        cmp.set("v.currentStage", event.getParam("currentStage"));  
        cmp.set("v.activeStages", event.getParam("activeStages"));            
        //Call helper to create/Update the Porgression indicator bar  
	        helper.initPath(cmp, event, helper);  
          
        if (event.getParam('status') === "FINISHED")
        {
        }
    }, 

    waiting: function(component, event, helper) {
      component.set("v.HideSpinner", true);
    },
  
   doneWaiting: function(component, event, helper) {
      component.set("v.HideSpinner", false);
   },
    
    ToggleStages : function (component,event,helper) {
    var Stagescmp = component.find("Stages");
    $A.util.toggleClass(Stagescmp, "slds-hide");      
     }
       
       
    })