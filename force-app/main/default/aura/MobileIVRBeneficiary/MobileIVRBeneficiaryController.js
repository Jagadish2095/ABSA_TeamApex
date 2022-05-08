({
    doInit : function(component, event, helper) {
        var opts = [];
        
        
        opts.push({
            class: "optionClass",
            label: "Cell C",
            value: "C"
        });
        opts.push({
            class: "optionClass",
            label: "MTN",
            value: "M"
        });
        opts.push({
            class: "optionClass",
            label: "Virgin",
            value: "I"
        });
        
        opts.push({
            class: "optionClass",
            label: "Telkom Mobile",
            value: "T"
        });
        
        opts.push({
            class: "optionClass",
            label: "Vodacom",
            value: "V"
        });
        
        component.set("v.mobileProviderOptions" , opts);
        
        var action = component.get("c.getCIF");
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        action.setParams({clientAccountId:clientAccountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = response.getReturnValue();
                console.log('CIF Key fetched : '+respObj);
                component.set('v.CifKey',respObj);
                helper.doInit(component, event,helper);  
            }
            
            else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    newMobile : function(component, event, helper) {
        component.set("v.AddBen",true);
    },
    
    onMobileProviderChange : function(component, event, helper){
        console.log('Mobile change acc number :'+ component.get("v.serviceProvider"));
    },
    
    cancel : function(component, event, helper) {
        component.set("v.AddBen", false);  
        component.set("v.UpdateBen", false);
        
    },
    
    actionAddMobile : function(component, event, helper) {
        var action = component.get("c.addNewMobile");
        var cellNumber = component.get('v.cellphoneNumber');
        console.log("Number Phone length : "+ cellNumber.length);
        if(cellNumber.length===10){
        action.setParams({clientAccountId:component.get('v.clientAccountIdFromFlow'),
                          cellNo : cellNumber,
                          ivrPaymentNo : component.get('v.IVR'),
                          description : component.get('v.name'),
                          cellProvider : component.get('v.serviceProvider')});
        component.set("v.AddBen",false);
        component.set('v.showSpinner',true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                if(response.getReturnValue() != null){
                    var respObj = JSON.parse(response.getReturnValue());
                    if(respObj.addMobileBeneficiariesResp != null){
                        var respMsg = respObj.addMobileBeneficiariesResp.saveMessage;
                        console.log('Response : '+respObj.addMobileBeneficiariesResp.saveMessage);
                        if(respMsg.includes('Saved')){
                            var toast = helper.getToast("Success",respMsg, "success");
                            toast.fire();
                        }
                        else{
                            component.set('v.showSpinner',false);
                            var toast = helper.getToast("Error",respMsg, "Error");
                            toast.fire();  
                        }
                    }
                    else{
                        var errorMsg = respObj.errorList[0].description;
                        var toast = helper.getToast("Error",errorMsg, "Error");
                        toast.fire();
                    }
                    component.set('v.showSpinner',false);
                    component.set('v.showRefresh',true);
                    
                }
            }
            else{
                var toast = helper.getToast("Error","Service Issue... Try again", "Error");
                toast.fire();
            } 
        });
        }
        else{
          var toast = helper.getToast("Error","Cellphone number must be a 10 digit", "Error");
          toast.fire();  
        }
        $A.enqueueAction(action);
    },
    
    selectedItem : function(component,event, helper){
        console.log('retrieving selected');
        //component.set("v.updateBeneFiciaryModal", true); 
        
        var beneficiaryList =  component.get("v.mobileBenList");
        console.log('Beneficiary length '+ beneficiaryList.length);
        var selectedBeneficiary;  
        var ctarget = event.currentTarget.dataset;
        var id_str = ctarget.value;
        
        console.log('Retrieving selected '+ ctarget);
        console.log('Retrieving selected string '+id_str);
        
        for(var i = 0; i < beneficiaryList.length; i++){
            if(beneficiaryList[i].description == id_str){
                component.set("v.IVR",beneficiaryList[i].ivrPaymentNo); 
                component.set("v.name",beneficiaryList[i].description); 
                component.set("v.cellphoneNumber",beneficiaryList[i].cellNo);
                component.set("v.serviceProvider",beneficiaryList[i].cellProvider); 
            }
        }
        component.set("v.UpdateBen", true);  
    },
    
    updateBeneficiary : function(component,event, helper){
        var action = component.get("c.updateMobile");
        var cellNumber = component.get('v.cellphoneNumber');
        if(cellNumber.length===10){
        action.setParams({clientAccountId:component.get('v.clientAccountIdFromFlow'),
                          cellNo : cellNumber,
                          ivrPaymentNo : component.get('v.IVR'),
                          description : component.get('v.name'),
                          cellProvider : component.get('v.serviceProvider')});
        component.set('v.showSpinner',true);
        component.set("v.UpdateBen", false);
        action.setCallback(this, function(response) {
            var state = response.getState(),
                respStr = response.getReturnValue();
            console.log('Response for updating : '+respStr);
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    var respObj = JSON.parse(response.getReturnValue());
                    if(respObj.updateMobileBeneficiariesResp != null){
                        var respMsg = respObj.updateMobileBeneficiariesResp.updateMessage;
                        console.log('Response : '+respObj.updateMobileBeneficiariesResp.updateMessage);
                        if(respMsg.includes('Updated')){
                            var toast = helper.getToast("Success",respMsg, "success");
                            toast.fire();
                        }
                        else{
                            component.set('v.showSpinner',false);
                            var toast = helper.getToast("Error",respMsg, "Error");
                            toast.fire();  
                        }
                    }
                    else{
                        var errorMsg = respObj.errorList[0].description;
                        var toast = helper.getToast("Error",errorMsg, "Error");
                        toast.fire(); 
                    }
                    component.set('v.showRefresh',true);
                    component.set('v.showSpinner',false);
                    
                }else{
                   
                    var toast = helper.getToast("Error",'UNSUCCESSFUL', "Error");
                    toast.fire(); 
                }  
                
            }
            else{
                    var toast = helper.getToast("Error",'Service Issue...Try again later', "Error");
                    toast.fire(); 
                }  
        });
        }
        else{
          var toast = helper.getToast("Error","Cellphone number must be a 10 digit", "Error");
          toast.fire();  
        }
        $A.enqueueAction(action);
    },
    
    actionDelete : function(component,event, helper){
        //Service to delete mobile beneficiary
    },
    first : function(component, event, helper){
        var notificationList = component.get("v.mobileBenList");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        for(var i=0; i< pageSize; i++){
            paginationList.push(notificationList[i]);
        }
        component.set("v.paginationList", paginationList);
    },
    last : function(component, event, helper){
        var notificationList = component.get("v.mobileBenList");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        for(var i=totalSize-pageSize+1; i< totalSize; i++){
            paginationList.push(notificationList[i]);
        }
        component.set("v.paginationList", paginationList);
        component.set("v.start" , 1);
    },
    
    next : function(component, event, helper){
        var notificationList = component.get("v.mobileBenList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(notificationList.length > end){
                paginationList.push(notificationList[i]);
                counter ++ ;
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.paginationList", paginationList);
        
    },
    
    previous : function(component, event, helper){
        var notificationList = component.get("v.mobileBenList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                paginationList.push(notificationList[i]);
                counter ++;
            }
            else {
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.paginationList", paginationList);
    },
    
    
    
    onSelectChange : function(component, event, helper) {
        
        var selected = component.find("records").get("v.value");
        console.log('Selected Value' + selected);
        var paginationList = [];
        var instructionList = component.get("v.mobileBenList");
        console.log('Instruction List' + instructionList);
        for(var i=0; i< selected; i++)
        {
            if(instructionList[i] != null){
                paginationList.push(instructionList[i]);
            }
        }
        component.set("v.paginationList", paginationList);
        
    },

    //DBOOYSEN. W-008831. 2021/03/05
    //function called when clientIDnVObjectParent attribute value changes
    //closes case
    handleObjectChange: function (component, event, helper) {
        var cacheObject = component.get("v.clientIDnVObjectParent");
        if (!cacheObject){
            component.set("v.showSpinner", true);
            //Close case
            component.find("statusFieldIDnV").set("v.value", "Closed");
            component.find("caseEditFormIDnV").submit();
        }
    },

    //DBOOYSEN. W-008831. 2021/03/05
    //function to set attributes once the caseEditFormIDnV has loaded
    handleCaseLoadIDnV: function (component, event, helper) {
        var serviceGroupsPollingAllowed = $A.get("$Label.c.Client_IDnV_Polling_Service_Groups");
        var currentServiceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
        if(serviceGroupsPollingAllowed.includes(currentServiceGroup)){
            component.set("v.clientCifCodeParent", component.find("clientCIFFieldIDnV").get("v.value"));
            component.set("v.allowClientIDnVPolling", true);
        }
    },

	//DBOOYSEN. W-008831. 2021/03/05
	//function to execute when the caseEditFormIDnV save is successful
    handleCaseSuccessIDnV : function(component, event, helper){
        var caseNumber = component.find("caseNumberFieldIDnV").get("v.value");
        var cifNumber = component.find("clientCIFFieldIDnV").get("v.value");
        helper.fireStickyToast("Error!", "Call dropped. Case number: " + caseNumber + " was auto closed for the client with CIF: " + cifNumber, "error");
        component.set("v.showSpinner", false);

        //Close the case subTab to go to the previous consultants' view
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log("MobileIVRBeneficiaryController.handleCaseSuccessIDnV workspaceAPI error: " + error);
        });
    }
})