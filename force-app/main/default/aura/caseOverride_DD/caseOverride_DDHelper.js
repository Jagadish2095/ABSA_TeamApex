({
    helperMethod : function() {

    },
    getServiceGroup :function (component) {
        this.showSpinner(component);
        var action =component.get("c.getServiceGroup");
        action.setParams({
            "recordTypeName" : component.get("v.recordType")//'DD STI Case'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serviceGrouprec = response.getReturnValue();
                if(serviceGrouprec!=null){
                    component.set("v.serviceGroupRecord",serviceGrouprec[0]);
                }
                console.log('*****'+JSON.stringify(serviceGrouprec[0]));

                this.hideSpinner(component);
            }else{
                this.hideSpinner(component);
            }

        });
        $A.enqueueAction(action);

    },
    
    getRecordType:function (component) {
        this.showSpinner(component);
        var action =component.get("c.getRecordTypeId");
        var developername = component.get("v.recordType");
        var recordtype;
        if(developername == 'AIP Case')
            recordtype = 'AIP_Case';
        else
            recordtype = 'DD_STI_Case';
        action.setParams({
            "recordTypeName" : recordtype//'DD STI Case'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordtypeId = response.getReturnValue();
                console.log('recordtypeId',recordtypeId);
                if(recordtypeId!=null){
                    component.set("v.recordTypeId",recordtypeId);
                }                
                this.hideSpinner(component);
            }else{
                this.hideSpinner(component);
            }

        });
        $A.enqueueAction(action);

    },
    
    getPolicyDetailsForCase :function (component) {
        
        this.showSpinner(component);
        var idNumber;
        var accRecord =component.get("v.accountRecord");
        var action =component.get("c.getPolicyDetailsById");
        if(accRecord.ID_Type__pc == '' || accRecord.ID_Type__pc == undefined)
            idNumber = 'SA Identity Document';
        else
            idNumber = accRecord.ID_Type__pc;
        action.setParams({
            "IdType" : idNumber,
            "IdNumber" : accRecord.ID_Number__pc
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var policyRecords = response.getReturnValue();
                if(policyRecords!= undefined && policyRecords!= null){
                    console.log('policyRecords',response.getReturnValue());
                    component.set("v.showPolicies" , true);
                    component.set("v.isPolicySelected" , true);
                    component.set("v.policyTable" , policyRecords);
                    var toast = this.getToast("Success!", "Policies found", "success");
                    toast.fire();
                }

            //component.set("v.maxPage", Math.floor((serviceGrouprec.length+9)/10));
            //this.renderPage(component);

                this.hideSpinner(component);
            }else if(state === "ERROR"){
                var errors = response.getError();
                var toast = this.getToast("Error", errors[0].message, "error");
                toast.fire();
                console.log('Error in getting policies --> ',errors[0].message);
                this.hideSpinner(component);
            }

        });
        $A.enqueueAction(action);

    },

    /*renderPage: function(component) {
    		var records = component.get("v.policyTable"),
                pageNumber = component.get("v.pageNumber"),
                pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
            component.set("v.currentList", pageRecords);
    	},*/
    
    //Show lightning spinner
    showSpinner: function (component) {
        //var spinner =
        component.set("v.spinner", true);
        //$A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        //var spinner =
        component.set("v.spinner", false);
        //$A.util.addClass(spinner, "slds-hide");
    },
    //Lightning toastie
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
      //Function to navigate home 
      navHome : function (component) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Case"
        });
        homeEvent.fire();
    },
    
    
    //Function to close tab
    closeFocusedTab : function(component) {
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }).catch(function(error) {
            console.log(error);
        });
    },
    //Function to close all Tabs
    closeAllTabs : function(component) {
        
        var workspaceAPI = component.find("workspace");
        var focusedTabId = '';
        
        //Get focus tab
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            focusedTabId = response.tabId;
            
        });
        
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log('Close all Tabs : ' + response);
            response.forEach(function(tabRecord) {
                var tabRecordId =  tabRecord.tabId;
                if(focusedTabId != tabRecordId) {
                    workspaceAPI.closeTab({tabId: tabRecordId});
                } 
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },  
    
    //Function to close focus tab and open a new tab
    closeFocusedTabAndOpenNewTab : function( component, caseId) {
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
            
            //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/' + caseId + '/view'
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : response});
            })
            .catch(function(error) {
                console.log(error);
            });
            
            //Closing old tab
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },

      //Set Record type buttons based on Profile and default
      getCaseRecordTypes : function( component ) {
        //Set CaseType default selection
        var action = component.get("c.getLoggedInUserCaseRecordType");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var caseRecordTypes = response.getReturnValue();
                console.log('****helper caseRecordTypes****'+caseRecordTypes);
                if(caseRecordTypes != null) {
                    caseRecordTypes.forEach(function(record) {
                        //Set default record type
                        if(record.isDefault == true) {
                            component.set("v.caseTypeSelected", record.value);
                            component.set("v.serviceGroupFilter", record.label);
                            if(record.value == 'Non_Confidential_Fraud') {
                                
                                component.set("v.isNonConfidentialFraud", true); 
                                
                            } else if (record.value == 'Complaint') {
                                
                                component.set("v.isComplaint", true);
                                
                            }else if (record.value == 'Service_Request') {
                                
                                component.set("v.isServiceRequest", true);
                                
                            }else if (record.value == 'ATM') {
                                
                                component.set("v.isATM", true);
                            }else if (record.value == 'Compliment') {	
                                
                                component.set("v.isCompliment", true);	
                            }
                        }
                    }); 
                    
                }
                
                component.set("v.caseTypeOption", caseRecordTypes);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                            console.log('****helper  errors****'+errors);
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                    console.log('****helper unknown errors****'+errors);
                }
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    createNewCase : function(component, event, helper) {
        //Show spinner
        this.showSpinner(component);
        var servGrp =component.get("v.serviceGroupRecord");
        var serviceGroupEmailAddress = servGrp.Response_Email_Address__c;
        var serviceGroupRecord;
        console.log('*****'+JSON.stringify(servGrp));
        if(servGrp.Id !=null){
            serviceGroupRecord=servGrp;
        }else{
            serviceGroupRecord=null;
        }
        console.log(' serviceGroupRecord '+JSON.stringify(serviceGroupRecord));
        component.set("v.butonDisable",true);
        var casedata= component.get("v.newCase");
        var subject = casedata.Subject;
        var source = casedata.Origin;//component.find("DD_STI_Source").get("v.value");
        var category =casedata.Category__c;
        var subCategory =casedata.DD_Sub_Category__c;
        var stiQuickText = 'DDSTICASE';
        var stiemailTemplateName = 'DD STI Case Creation';
        console.log('casedata.STI_Retain_Client__c '+casedata.STI_Retain_Client__c);
        console.log('casedata.Outcome__c '+casedata.DD_Case_Outcome__c);
        var comments = casedata.Description;//component.find("Comments__c").get("v.value");
        var accRecord =component.get("v.accountRecord");
        var preferredCommunicationChannel = casedata.DD_Preferred_Communication_Method__c;//component.find("DD_Preferred_Communication_Method__c").get("v.value");
        var mobilePhone = casedata.Phone__c;//leadRecord.MobilePhone;//iPhone;iMobilePhone;iEmail
       // var phone=casedata.DD_STI_Source__c;//component.find("iPhone").get("v.value");
        var email=casedata.Email__c;//component.find("iEmail").get("v.value");
        var mobilePhone=casedata.Mobile__c;//component.find("iMobilePhone").get("v.value");
        var policyNumber=casedata.Policy_Number__c;
        var productProvider=casedata.Product_Provider__c;//policyNumber productProvider
		//Ashok added to check the API Case
        var recTypeAPI = "DD_STI_Case";
        var recType = component.get("v.recordType");
		
        //No Client selected
        if(!accRecord.Name && !accRecord.LastName){
            var toast = this.getToast("Validation Warning", "Please search for an existing Client or create a new Client record", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }

        if(!subject){
            var toast = this.getToast("Validation Warning", "Please provide  the subject", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        } 
        
        if(!source){
            console.log('RecordType :: '+recType);
            if( recType == 'AIP Case' ){
            var toast = this.getToast("Validation Warning", "Please select the Source", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
            }else{
            var toast = this.getToast("Validation Warning", "Please select the Origin", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
            }    
        }

        if(category == null || category == '' || !category){
            var toast = this.getToast("Validation Warning", "Please select the Category", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }
        if((subCategory == null || subCategory == '' || !subCategory)){
            var toast = this.getToast("Validation Warning", "Please select the Sub Category", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        } //subCategory
        if(category != null || category != '' || category){
            if(category == 'Claims'){
                stiQuickText = 'DDSTICASE_Processed_Submitted';
                stiemailTemplateName = 'DD STI Claim Case Creation';
                
            }            
        }
        console.log('comments '+comments);
        console.log('comments 1 '+!comments);
        if( recType == 'AIP Case' ){
        	var comments = casedata.Comments__c;//component.find("Comments__c").get("v.value");
            var avaf = casedata.Client_Absa_Account_Number__c;
        	var area = casedata.Related_Business_Area__c;
            if(!comments && category == 'Cancellation'){ 
                var toast = this.getToast("Validation Warning", "Please provide the comments", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            }
            
            if(!avaf && category == 'Cancellation'){ 
                var toast = this.getToast("Validation Warning", "Please provide the AVAF Number", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            }
            
            if(!area && category != 'Claims' && category != 'Cancellation' && category == 'Proof of insurance'){
                var toast = this.getToast("Validation Warning", "Please provide the area", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            }
		
        }     
        if(preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel){
            var toast = this.getToast("Validation Warning", "Please provide Preferred Communication Channel", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        } else if(preferredCommunicationChannel != null || preferredCommunicationChannel != ''){
            if (!email && preferredCommunicationChannel.includes('Email') ){
                var toast = this.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
                
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Mobile')){
                var toast = this.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            }else if (!mobilePhone && preferredCommunicationChannel.includes('SMS')){
                var toast = this.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Whatsapp')){
                var toast = this.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            
            }else if (!email && preferredCommunicationChannel.includes('In-App')){
                var toast = this.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                this.hideSpinner(component);
                component.set("v.butonDisable",false);
                toast.fire();
                return null;
            }
            
        }

        if(!policyNumber && recType != 'AIP Case'){
            var toast = this.getToast("Validation Warning", "Please provide  the policy number", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }

        if(!productProvider && recType != 'AIP Case'){
            var toast = this.getToast("Validation Warning", "Please provide  the product provider", "warning");
            this.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }
       
        var action = component.get("c.createCase"); 
        var newCaseRecord = component.get("v.newCase");
        newCaseRecord.Case_Ownership__c='I will Resolve	'; //added to identify the ownership
        newCaseRecord.Is_Inbound__c=true;
        newCaseRecord.Bypass_Validation_Rules__c =true; 
        if(recType == "AIP Case"){
            recTypeAPI = "AIP_Case";
            newCaseRecord.sd_Response_Email_Address__c = 'aipservices@absa.co.za';
            newCaseRecord.Bypass_Validation_Rules__c =false;// no by pass of validation rules for AIP Case
            if(category == 'Cancellation')
                newCaseRecord.Status = 'In Progress';
        }

        action.setParams({
            "caseRecord" : newCaseRecord,
            "clientRecord" : accRecord,
            "caseRecordType" : recTypeAPI, //'DD_STI_Case',//'Service_Request',
            "isRoutingRequired" : false,
            "serviceGroupRecord" : serviceGroupRecord
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
                var state = response.getState();
                var message = '';
                if(state === "SUCCESS"){
                    var caseRecId = response.getReturnValue();
                    //Ashok added the if condition to bypass the code for AIP Case
                    if(recType != "AIP Case"){
                        var action = component.get("c.sendSmsEmail");
                            action.setParams({
                                "caseId" : caseRecId ,
                                "phoneNumberOverride":mobilePhone,
                                "quickText": stiQuickText,
                                "emailTemplateName": stiemailTemplateName,
                                "responseEmailAddress":serviceGroupEmailAddress,
                                "preferredCommunicationChannel":preferredCommunicationChannel,
                                "ownerEmail":'',
                                "managerEmail":''
                                
                            });
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                            var message = '';
                            if(state === "SUCCESS"){
                                this.hideSpinner(component);
                                component.set("v.butonDisable",false);
                                this.closeFocusedTabAndOpenNewTab(component,caseRecId);
                            } else if(state === "ERROR"){
                                var errors = response.getError();
                                 component.set("v.butonDisable",false);
                                this.closeFocusedTabAndOpenNewTab(component,caseRecId);
                                console.log('errors'+errors);
                                }
                        });
                            $A.enqueueAction(action);
                    }
                    else{
                		this.hideSpinner(component);
                		component.set("v.butonDisable",false);
                		this.closeFocusedTabAndOpenNewTab(component,caseRecId);
                    }
            }else if(state === "ERROR"){
                var errors = response.getError();
                component.set("v.butonDisable",false);
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
           
    },
    
})