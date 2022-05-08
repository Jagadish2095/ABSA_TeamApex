({
    doInit: function(component, event, helper) {
        //localStorage.clear();
        component.set("v.showModal", true);
        component.set("v.emailConfirmed", false);
        helper.handleOnInit(component,  helper, event);
        component.set("v.IsEmailprocess", false);
        //$A.get('e.force:refreshView').fire();
        let action = component.get("c.missingDocsList");
        let missingDocumentsString= component.get("v.missingDocuments");
        
        action.setParams({
            "missingDocList": missingDocumentsString,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.missingDocsList', response.getReturnValue());
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
    showModel: function(component, event, helper) {
        component.set("v.showModal", true);
    },
    onCheck: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        component.set("v.myBool",checkbox);
          
	 },
    showSecondModel: function(component, event, helper) {
        let inputCmps = component.find("aid");
        let isAllFieldsValid = true;
        
        for(let inputCmp of inputCmps){
            if(!inputCmp.reportValidity()){
                isAllFieldsValid = false; 
                //break;
            }
        }
        var postalCode = component.find("aidzip").get("v.value");
        let isValidZipCode = /^([0-9]{4})$/.test(postalCode); 
        if(!isValidZipCode){
            helper.showToast('Error', 'Please enter valid Zip Code', 'Error');
        }
        if(isAllFieldsValid && isValidZipCode){
            component.set("v.isOpen", true);
            component.set("v.attestationType",'TELEPHONIC');
        }
    }, 
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    ConfirmClientDetails: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        var checkCmp = component.find("checkbox");
        var checkbox = checkCmp.get("v.value");
        component.set("v.myBool",checkbox);
		var missingDocList= component.get("v.missingDocsList");
        var missingDocsList=component.get("v.missingDocuments");
        if(checkbox ==true  && !missingDocsList.includes('ProofOfAddress')){
            missingDocList.push('Proof Of Address');
            missingDocsList.push('ProofOfAddress');
			helper.handleOnInit(component,  helper, event);
        }else{
            helper.handleOnInit(component,  helper, event);
        }
        
        helper.updateStage(component, helper, 'Perform Attestation');
        component.set("v.showviewform", false);
        component.set("v.showeditform", false); 
        component.set("v.showClientform", true);
        component.set("v.isOpen", false);
        
    },
    
    hideModel: function(component, event, helper) {
        helper.getMissingDocuments(component, event, helper);
        helper.updateStage(component, helper, 'Review Client Details');
        component.set("v.showModal", false);
        component.set("v.showviewform", false);
        component.set("v.IsEmailprocess",true);
        component.set("v.attestationType",'EMAIL');
    },
    
    saveDetails: function(component, event, helper) {
        helper.getMissingDocuments(component, event, helper);
        helper.updateStage(component, helper, 'Review Client Details');
        component.set("v.showModal", false);
        component.set("v.IsEmailprocess", false);
    },
    hideandshoesections: function(component, event, helper) {
        helper.updateStage(component, helper, 'Perform Attestation');
        component.set("v.currentStep",2);
        var IsEmailORtel=component.get("v.value");
        if(IsEmailORtel=='option1'){
            helper.getMissingFields(component, event, helper);
            component.set("v.showviewform", false);
            component.set("v.showeditform", true);
        }
        else {
            component.set("v.showeditform", false);
            component.set("v.showviewform", false);
            component.set("v.IsEmailprocess", true);
            
        }
    },
    finalNextbtn: function(component, event, helper) {
        helper.updateStage(component, helper, 'Confirmation');
        helper.updateCIF(component, helper,event ,component.get("v.jointsParentCode"));
        component.set("v.currentStep",3);
        component.set("v.showClientform", false);
        component.set("v.emailConfirmed",true);
        
    }, 
    backToclentDetails: function(component, event, helper) {
        component.set("v.showviewform", true);
        component.set("v.showeditform", false);
    },
    IsEmailNext:function(component, event, helper) {
        let inputCmps = component.find("emailidout");
        let isAllFieldsValid = true;
        if(!inputCmps.reportValidity()){
            isAllFieldsValid = false;
            //break;
        }
        if(isAllFieldsValid){
            helper.updateStage(component, helper, 'Confirmation');
            component.set("v.currentStep",3);
            component.set("v.Emailconfirmation", true);
            component.set("v.IsEmailprocess", false);
            var emailedit = component.find("emailidout").get("v.value");
            component.set("v.upteemail",emailedit )
            component.set("v.attestationType",'EMAIL');
            
        }
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },
    returnToaccount:function(component, event, helper) {
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId:component.get("v.recordId"),
            slideDevName: "detail"
        });
        navEvent.fire(); 
    },
    createcaseRecord:function(component, event, helper) {
        let inputCmps;
        if(component.find("emailidout")){
            inputCmps = component.find("emailidout");
        }else if(component.find("emailidoutput")){
            inputCmps = component.find("emailidoutput");
        } else if(component.find("emailid")){
            inputCmps = component.find("emailid");
        }
        let isAllFieldsValid = true;
        if(!inputCmps.reportValidity()){
            isAllFieldsValid = false;
            //break;
        }
        if(isAllFieldsValid){
         helper.handleOnInit(component,  helper, event);
            //var email=component.find("eid");
            var email; 
            if(component.find("emailidout")){
                email= component.find("emailidout").get("v.value");
            }else if(component.find("emailidoutput")){
                email= component.find("emailidoutput").get("v.value");
            } else if(component.find("emailid")){
                email= component.find("emailid").get("v.value");
            }
            //var email = component.find("emailid")? component.find("emailid").get("v.value"):'';
            var action = component.get("c.casecreation");
            var objectId = component.get("v.recordId");
            var attype = component.get("v.attestationType");
            let caInstance = component.get("v.objclientAttestation");
            action.setParams({
                "emailId": email,
                "caInstance" : caInstance,
                "attestationType" : attype,
                "jointCIF": component.get("v.jointsParentCode")
            });
            action.setCallback(this, function(response) {
                //store state of response
                var state = response.getState();
                console.log('state>>>'+state);
                console.log(response.getReturnValue());
                if (state === "SUCCESS") {
                    var navEvent = $A.get("e.force:navigateToSObject");
                    navEvent.setParams({
                        recordId:response.getReturnValue(),
                        slideDevName: "detail"
                    });
                    navEvent.fire();
                    // $A.get("e.force:refreshView").fire();
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                        errors[0].message);
                            helper.showToast('Warning', response.getReturnValue(), 'Warning');
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }// Email Validate   
    },
    isRefreshed: function(component, event, helper) {
        component.set("v.showModal", false);
        location.reload();
        $A.get("e.force:refreshView").fire();
        component.set("v.showModal", false);
    }
})