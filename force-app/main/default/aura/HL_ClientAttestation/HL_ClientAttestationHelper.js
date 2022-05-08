({
    handleOnInit: function(component, helper, event) {
        let action = component.get("c.initClientAttestation");
        let objectId = component.get("v.recordId");
        let daysDue =  component.get("v.daysDue");
        let missingDocumentsString= component.get("v.missingDocuments");
        action.setParams({
            "accountID": objectId,
            "days": daysDue,
            "missingDocList": missingDocumentsString,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue())
                console.log('aaaas')
                component.set('v.objclientAttestation', response.getReturnValue());
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);         
    },
    updateStage: function(component, helper, stage) {
        let action = component.get("c.updateStage");        
        var clsRef = component.get("v.objclientAttestation");
        var cmpSts = component.get("v.healthStatus");
        action.setParams({           
            "stage": stage,
            "caInstance": clsRef,
            "complianceStatus": cmpSts
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let stages = component.get("v.stages");
                let stageVals = {"Review Client Details":1,"Perform Attestation":2,"Confirmation":3};
                let stageNo = stageVals[stage];
                stages.forEach(item =>{
                    if(item.sno<=stageNo){
                    item.completed=true;
                }
                               });
                component.set("v.stages",stages);
                //component.set("v.currentStep", stageVals[stage]);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration:' 10000',
            type: type
        });
        toastEvent.fire();
    },
    getMissingFields: function(component, helper, event) {
        let now = this;
        if (component.get("v.healthStatus") == 'PartialCompliant' || component.get("v.healthStatus") == 'NonCompliant') {
            if (component.get("v.missingData") != null) {
                
                now.showToast('Warning', 'FIC Engine has  highlighted the customer info/ fields that need to be updated', 'Warning')
            }
        }
    },        
    getMissingDocuments: function(component, helper, event) {
        let now = this;
        if (component.get("v.healthStatus") == 'PartialCompliant' || component.get("v.healthStatus") == 'NonCompliant') {
            var missingDoclegnth=component.get("v.missingDocsList");
            if (missingDoclegnth != '' ) {
                let misDoc = component.get("v.missingDocsList")
                if(misDoc.length>0){
                    misDoc.forEach(function(doc) {
                        now.showToast('Warning', 'FIC Engine has identified that there is a missing document (' + doc + ')', 'Warning')
                    });
                }
            }
        }
        
    },
    updateCIF: function(component, helper,event,jointsCIF) {
        var jointClientCode = jointsCIF != null ? component.get("v.jointsParentCode") : '';
        let action = component.get("c.updateClientAttenstation");
        let accId = component.get("v.recordId");
        action.setParams({
            "accId": accId,
            "jointsParentCode": jointClientCode
        });
        $A.enqueueAction(action);
    },
})