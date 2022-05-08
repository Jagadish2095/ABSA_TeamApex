({
    doInit: function(component, event, helper) {
        //component.get("v.currentStep");
        console.log('Doinit'+component.get("v.currentStep"));
       //  let nameStage = event.getParam("NameStage")
       // let stageVals = {"Review Client Details":1,"Perform Attestation":2,"Confirmation":3};
       //   component.set("v.currentStep", stageVals[nameStage]);

    },
    handleSelect : function (component, event, helper) {
      //alert(event.getParam("NameStage"));
       let stageField = component.get("v.currentStep");
        
       // let nameStage = event.getParam("NameStage")
        let stageVals = {"Review Client Details":1,"Perform Attestation":2,"Confirmation":3};
     //   alert("stageVal----"+stageVals[nameStage]);
        component.set("v.currentStep", stageField);
    }
    
})