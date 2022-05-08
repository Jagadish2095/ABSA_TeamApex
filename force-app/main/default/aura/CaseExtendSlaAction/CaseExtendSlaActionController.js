/**
* Lightning Component Controller for Extend SLA Quick Action
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-20
*
**/

({
    
    //Get case record for the quick action
    doInit : function(component, event, helper) {
        //Method to get Case record with SLA to determine if approval is required to extend SLA
        var action = component.get("c.getCaseRecord");
        
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state == "SUCCESS") {
                var caseRec = response.getReturnValue();
                component.set("v.caseRecord", caseRec);
                 // Added to fetch the NBFS Case Record Type 
                var recTypeName= component.get("v.caseRecord").RecordType.Name;
                if(recTypeName =="NBFS Dispute Resolution"){
                    component.set("v.isNBFSServiceGroup", 'true');
                    //Added to check if the service group is absa linked investments -divya
                    if(component.get("v.caseRecord").sd_Service_Group__c != undefined && component.get("v.caseRecord").sd_Service_Group__c  != 'undefined' && component.get("v.caseRecord").sd_Service_Group__c != null){
                        if(component.get("v.caseRecord").sd_Service_Group__c == 'Absa Linked Investments Complaints'){
                            component.set("v.isAbsaLinkInvest", 'true');
                        }
                    }
                }
                else if(recTypeName =="Short Term Complaint"){
                    component.set("v.isShortTermInsurance", 'true');
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
        //Method to see if there is any approval processes in progress
        var action = component.get("c.approvalProccessChecks");
        
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state == "SUCCESS") {
                var caseRec = response.getReturnValue();
                component.set("v.isValid", caseRec);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    //Method to validate that Quantity and Time Measure have been selected
    addToSLA : function(component, event, helper) {
        component.set("v.isAddToSLA", 'true');
        component.set("v.isSetNewSLA", 'false');
        
        var extensionUnit = Number(component.find("iQuantity").get("v.value"));
        console.log('extensionUnit: '+ extensionUnit);
        var extensionTimeMeasure = component.find("iTimeMeasure").get("v.value");
        console.log('extensionTimeMeasure: '+ extensionTimeMeasure);
        var uploadattachments = component.get("v.contentDocumentId");// Added for NBFS Case Record Type
        console.log('uploadattachments: '+ uploadattachments);
        //Validation on Quantity
        if($A.util.isEmpty(component.find("iQuantity").get("v.value"))){
            var toast = helper.getToast("Validation Warning", "SLA Extension Quantity is Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }  
        
        //Validation on Time Measure
        if($A.util.isEmpty(extensionTimeMeasure) ){
            var toast = helper.getToast("Validation Warning", "SLA Extension Time Measure is Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }  
        
         //Validation on upload button when new SLA button selected in NBFS by Kalyani
        if((component.get("v.isNBFSServiceGroup") || component.get("v.isShortTermInsurance")) && ($A.util.isUndefined(uploadattachments) || $A.util.isEmpty(uploadattachments))){
            var toast = helper.getToast("Validation Warning", "Please upload the attachments before setting New SLA", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
         //Validation on SlA for different levels for NBFS by Divya
        if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1'  && component.get("v.caseRecord").is_level_1_SLA_done__c == true){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date Extension cannot be allowed more than once", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
         if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 2' && extensionTimeMeasure == 'Day(s)' && extensionUnit > 10){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 10 days", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
         if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 2' && extensionTimeMeasure == 'Week(s)' && extensionUnit > 2){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 2 Weeks", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        if(component.get("v.isAbsaLinkInvest")){
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Day(s)' && extensionUnit > 31){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 31 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Week(s)' && extensionUnit > 6){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 6 Weeks", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Hour(s)' && extensionUnit > 248){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 248 Hours", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
        }
        else {
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Day(s)' && extensionUnit > 5){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 5 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Week(s)' && extensionUnit > 1){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 1 Week", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1' && extensionTimeMeasure == 'Hour(s)' && extensionUnit > 40){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 40 Hours", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
        }
         if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 2' && extensionTimeMeasure == 'Hour(s)' && extensionUnit > 80){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 80 Hours", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        //Short term insurance validation
        if(component.get("v.isShortTermInsurance")){
            var extendSla = component.find("iExtendSLAConfirmation").get("v.value");
            if(extendSla == false){
                var toast = helper.getToast("Validation Warning", "Extend SLA is Required", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if((component.get("v.caseRecord").NBFS_Category__c == 'Level 1' || component.get("v.caseRecord").NBFS_Category__c == 'Level 2') && extensionTimeMeasure == 'Day(s)' && extensionUnit > 2){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 2 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if((component.get("v.caseRecord").NBFS_Category__c == 'Level 1' || component.get("v.caseRecord").NBFS_Category__c == 'Level 2') && extensionTimeMeasure == 'Hour(s)' && extensionUnit > 16){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 2 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if((component.get("v.caseRecord").NBFS_Category__c == 'Level 1' || component.get("v.caseRecord").NBFS_Category__c == 'Level 2') && extensionTimeMeasure == 'Week(s)'){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 2 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if(component.get("v.caseRecord").NBFS_Category__c == 'Level 3' && extensionTimeMeasure == 'Day(s)' && extensionUnit > 7){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 7 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if(component.get("v.caseRecord").NBFS_Category__c == 'Level 3' && extensionTimeMeasure == 'Hour(s)' && extensionUnit > 56){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 7 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
            
            if(component.get("v.caseRecord").NBFS_Category__c == 'Level 3' && extensionTimeMeasure == 'Week(s)' && extensionUnit > 1){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be more than 7 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
        }
        var a = component.get('c.approvalRequiredCheck');
        $A.enqueueAction(a);
    },
    
    checkHolidays : function(component, event, helper) {
        var action = component.get("c.getHolidays");
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state == "SUCCESS") {
                var holidays = response.getReturnValue();
                component.set("v.holidaysArray", holidays);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    //Method to validate that new SLA date have been selected
    setNewSLA : function(component, event, helper) {
        component.set("v.isSetNewSLA", 'true');
        component.set("v.isAddToSLA", 'false');
       
         var extensionDate = component.find("iDateTime").get("v.value");
         var uploadattachments=component.get("v.contentDocumentId");    // Added for NBFS Case Record Type  
         var extensionDateFormat = $A.localizationService.formatDate(extensionDate, "YYYY-MM-DD");
         var slaDate = $A.localizationService.formatDate(component.get("v.caseRecord").External_SLA_End_Date__c, "YYYY-MM-DD");// Added for NBFS Case Record Type
         var holidaysArray =  component.get("v.holidaysArray");
        
        console.log("***extensionDateFormat***",extensionDateFormat+'==slaDate=='+slaDate);
        console.log("***Holidays2***",holidaysArray);
        
        if(holidaysArray.includes(extensionDateFormat)){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be a Holiday", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
               
        //Validation on new SLA date selected
        if($A.util.isEmpty(extensionDate) ){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date is Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        //Validation on upload button when new SLA button selected in NBFS by Kalyani
        if(component.get("v.isNBFSServiceGroup") && ($A.util.isUndefined(uploadattachments) || $A.util.isEmpty(uploadattachments))){
            var toast = helper.getToast("Validation Warning", "Please upload the attachments before setting New SLA", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        //Validation on SlA for different levels by Divya
        if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1'  && component.get("v.caseRecord").is_level_1_SLA_done__c == true){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date cannot be allowed more than once", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        var dateTimeNow = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                
        if(extensionDate < dateTimeNow){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be In The Past", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        var Dd = new Date(extensionDate);
        
        if(Dd.getDay() == 6 || Dd.getDay() == 0){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be On A Weekend", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
         //Validation on SlA for different levels by Divya
         console.log('isNBFSServiceGroup=='+component.get("v.isNBFSServiceGroup")+'==caegry=='+JSON.stringify(component.get("v.caseRecord")));
        if(component.get("v.isNBFSServiceGroup") && (component.get("v.caseRecord").NBFS_Category__c == 'Level 2' || component.get("v.caseRecord").NBFS_Category__c == 'Level 1') && extensionDateFormat <= slaDate){
            var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be Prior to External SLA End Date", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 2'){
            var startDate = slaDate;
            startDate = new Date(startDate.replace(/-/g, "/"));
            var endDate = "", noOfDaysToAdd = 10, count = 0;
            while(count < noOfDaysToAdd){
                endDate = new Date(startDate.setDate(startDate.getDate() + 1));
                if(endDate.getDay() != 0 && endDate.getDay() != 6){
                    count++;
                }
                var date = new Date(endDate),
                    mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                    day = ("0" + date.getDate()).slice(-2);
                var enddate =  [date.getFullYear(), mnth, day].join("-");
            }
            console.log("***enddate***",enddate);
            if(extensionDateFormat > enddate){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be more than 10 days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return; 
            }
         }
        if(component.get("v.isNBFSServiceGroup") && component.get("v.caseRecord").NBFS_Category__c == 'Level 1'){
            var startDate = slaDate;
            startDate = new Date(startDate.replace(/-/g, "/"));
            var endDate = "", noOfDaysToAdd=0,count = 0;
            if(component.get("v.isAbsaLinkInvest")){
                noOfDaysToAdd = 31; 
            }else{
                noOfDaysToAdd = 5;
            }
            
            while(count < noOfDaysToAdd){
                endDate = new Date(startDate.setDate(startDate.getDate() + 1));
                if(endDate.getDay() != 0 && endDate.getDay() != 6){
                    count++;
                }
                var date = new Date(endDate),
                    mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                    day = ("0" + date.getDate()).slice(-2);
                var enddate =  [date.getFullYear(), mnth, day].join("-");
            }
            console.log("***enddate***",enddate);
            if(extensionDateFormat > enddate){
                var toast = helper.getToast("Validation Warning", "SLA Extension Date Cannot Be more than "+noOfDaysToAdd+ " days", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return; 
            }
         }
        var a = component.get('c.approvalRequiredCheck');
        $A.enqueueAction(a);
    },
    
    //Check if approval is required based on Max SLA set on Service Level
    approvalRequiredCheck : function(component, event, helper) {
        helper.showSpinner(component);
        
        var action = component.get("c.calculateNewSlaDate");
        
        var isSetNewSlaIdentifier = component.get("v.isSetNewSLA");
        var isAddToSLAIdentifier = component.get("v.isAddToSLA");
        var maxExtensionNum = component.get("v.caseRecord").Max_SLA_Adjustment_Day_s__c;
        var totalExtensionNum = component.get("v.caseRecord").Total_SLA_Adjustment_Day_s__c;
        var extensionUnit = Number(component.find("iQuantity").get("v.value"));
        var extensionTimeMeasure = component.find("iTimeMeasure").get("v.value");
        var extensionDate = component.find("iDateTime").get("v.value");
        var caseRec;
        
        //Validate that reason is populated
        var extensionReason = component.find("iReason").get("v.value");
        
        //Validation
        if($A.util.isEmpty(extensionReason) || $A.util.isUndefined(extensionReason)){
            var toast = helper.getToast("Validation Warning", "SLA Extension Reason is Required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }   
        
        if(isSetNewSlaIdentifier == 'true') { 
            action.setParams({
                "recId" : component.get("v.recordId"),
                "reason" : extensionReason,
                "extensionDate" : extensionDate
            });
        } else {
             action.setParams({
                "recId" : component.get("v.recordId"),
                "reason" : extensionReason,
                "extensionQuantity" : extensionUnit,
                "extensionMeasure" : extensionTimeMeasure
            });
        }
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state == "SUCCESS") {
                caseRec = response.getReturnValue();
                component.set("v.isApprovalRequired", caseRec);
                
                component.set("v.isOpen", true);   
                if (caseRec == true) {
                    component.set("v.isOpen", true);   
                }else {
                    component.set("v.isOpen", false);
                    var a = component.get("c.extendSLA");
                    $A.enqueueAction(a);
                }
            }else if(state === "ERROR"){
                
                var message = '';
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
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Method to extend the SLA and/or submit for approval
    extendSLA : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.extendExternalSLA");
        var approvalRequiredCheck = component.get("v.isApprovalRequired");
        
        action.setParams({
            "recId" : component.get("v.recordId"),
            "reason" : component.find("iReason").get("v.value"),
            "newSLADate" : component.get("v.newSlaDate"),
            "isApprovalReq" : approvalRequiredCheck
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                
                if(approvalRequiredCheck == true){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "External SLA submitted for Approval",
                        "type":"success"
                    });
                }else {
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "External SLA Extended",
                        "type":"success"
                    });
                }
                
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                $A.get("e.force:refreshView").fire();
                
            } else if(state === "ERROR"){
                
                var message = '';
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
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
        component.set("v.isOpen", false);
        
    },
    
    openNewTab : function(component, event, helper){
        var caseId = event.getSource().get("v.title");
        helper.openTab(component, event, caseId);
    },
    
    //Log Case Id 
    logId : function(component, event, helper){
        var selectedCaseId = event.getSource().get("v.text");
        component.set("v.relatedCaseId", selectedCaseId);
    },
    
    //Open Approval Process Modal
    openModel: function(component, event, helper) {
        var maxExtensionNum = component.get("v.caseRecord").Max_SLA_Adjustment_Day_s__c;
        var totalExtensionNum = component.get("v.caseRecord").Total_SLA_Adjustment_Day_s__c;
        var extensionUnit = Number(component.find("iUnits").get("v.value"));
        var extensionTimeMeasure = component.find("iTimeMeasure").get("v.value");
        var extensionDate = component.find("iDateTime").get("v.value");
        //var tempTotal = totalExtensionNum + extensionDaysNum
        
        //if (tempTotal > maxExtensionNum){
        if(extensionDate == '' || extensionDate == null){
            component.set("v.isOpen", true);
        }else{
            if (tempTotal > maxExtensionNum){
                
            } else {
                component.set("v.isOpen", false);
                var a = component.get('c.extendSLA');
                $A.enqueueAction(a);
            }    
        }
    },
    
    //Close Approval Process Modal
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.isOpen", false);
        
         helper.hideSpinner(component);
    },
    
     // To upload the document for extension of sla for NBFS Case Record Type
    handleUploadFinished: function(component, event, helper) {        
        component.set("v.contentDocumentId",event.getParam("files")[0].documentId);
        /********Added by Kalyani to display uploaded file name *************/
        var uploadedFilename = event.getParam("files")[0].name;
        component.set("v.fileStr",uploadedFilename);
        var forensicFileText = component.find('forensicFileText');
        if(!$A.util.isUndefinedOrNull(uploadedFilename)) {
            $A.util.removeClass(forensicFileText, 'slds-text-color_error');
            $A.util.addClass(forensicFileText, 'slds-text-color_success');
        }else {
            $A.util.removeClass(forensicFileText, 'slds-text-color_success');
            $A.util.addClass(forensicFileText, 'slds-text-color_error');
        }
        /********End of Code Added by Kalyani to display uploaded file name *************/
    },
    
    handleSuccess: function(component, event, helper) {
        var payload = event.getParams().response;
        var action = component.get("c.updateContentDocument");
        action.setParams({caseId : payload.id, contentDocumentId : component.get("v.contentDocumentId")});        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": payload.id,
                    "slideDevName": "details"
                });
                navEvt.fire();
            }            
        });
        $A.enqueueAction(action);
    },
    
})