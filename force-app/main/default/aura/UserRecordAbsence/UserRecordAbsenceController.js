({
    doInit : function(component, event, helper) {
        
        //Get all logged user absent days 
        var action = component.get("c.getLoggedInUserAbsentDates");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var datesAbsent = response.getReturnValue();
                console.log('****datesAbsent****'+datesAbsent);
                
                component.set("v.datesAbsentList", datesAbsent);
                
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    submitRecord : function(component, event, helper) {
        
        var absenceRecord = component.get("v.absenceRecord");
        
        helper.showSpinner(component);
        
        var action = component.get("c.createRecordAbsence");
        
        action.setParams({
            "recordAbsence" : absenceRecord
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                console.log('******ReturnVal***', response.getReturnValue());
                
                if(response.getReturnValue() == 'No Service Group Found'){
                    var toast = helper.getToast("Branch Not Found", "You are currently not assigned to a branch, please ask administrator for assistance", "Error");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }else if(response.getReturnValue() == 'No Manager Assigned'){
                    var toast = helper.getToast("Manager Not Found", "Your branch does not have a manager assigned, please ask administrator for assistance", "Error");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }else{
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Record absence successfully created!",
                        "type":"success"
                    });
                    
                    toastEvent.fire();
                    helper.hideSpinner(component);
                    component.set("v.isOpen", false);
                    
                    component.find("iStartDate").set("v.value", null);
                    component.find("iEndDate").set("v.value", null);
                    component.find("iReason").set("v.value", null);
                    component.find("iComment").set("v.value", null);
                    
                    component.set("v.datesAbsentList", null);
                    
                    $A.enqueueAction(component.get('c.minimizeUtility'));
                    $A.enqueueAction(component.get('c.doInit'));
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
                
                if(message.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION,')){
                    var exceptionMessage = message.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                    message = exceptionMessage[1];
                }
                // show Error message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": message,
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
            
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    openModel: function(component, event, helper) {
        
        var startDate = component.find("iStartDate").get("v.value");
        var endDate = component.find("iEndDate").get("v.value");
        var todayDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        var reason = component.find("iReason").get("v.value");
        var comment = component.find("iComment").get("v.value");
        
        var datesAbsentArray =  component.get("v.datesAbsentList");
        var absentStartDate; 
        var absentEndDate;
                
        if(datesAbsentArray.length > 0){
            absentStartDate = $A.localizationService.formatDate(datesAbsentArray[0], "YYYY-MM-DD");
            absentEndDate = $A.localizationService.formatDate(datesAbsentArray[datesAbsentArray.length - 1], "YYYY-MM-DD");
        }
        
        //Validation on start date selected
        if($A.util.isEmpty(startDate)){
            var toast = helper.getToast("Validation Warning", "Start date is required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        if(startDate < todayDate){
            var toast = helper.getToast("Validation Warning", "Start date cannot be in the past", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        //Validation on end date selected
        if($A.util.isEmpty(endDate)){
            var toast = helper.getToast("Validation Warning", "End date is required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        if(endDate < todayDate){
            var toast = helper.getToast("Validation Warning", "End date cannot be in the past", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        if(endDate < startDate){
            var toast = helper.getToast("Validation Warning", "End date cannot be less than start date", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        console.log('****absentStartDate****',absentStartDate);
        console.log('****absentEndDate****',absentEndDate);
        console.log('****STARTDATE****',startDate);
        console.log('****ENDDATE****',endDate);
        
        if(datesAbsentArray.includes(startDate) || 
           datesAbsentArray.includes(endDate) || 
           (startDate < absentStartDate && endDate >= absentStartDate) ||
           (startDate < absentEndDate && startDate > absentStartDate && endDate >= absentEndDate)){
            var toast = helper.getToast("Validation Warning", "Date not allowed, there is already pending request(s) on selected days, please try again", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        if(reason == null || reason == ''){
            var toast = helper.getToast("Validation Warning", "Absence reason cannot be blank", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
                
        var dateDiff = (new Date(endDate) - new Date(startDate)) / (1000 * 3600 * 24);
        dateDiff = dateDiff + 1;
		
        var startDateStr = new Date(startDate).toDateString();
        var endDateStr = new Date(endDate).toDateString();
        
        var message = 'Please confirm that you will be out of office for ' + dateDiff + ' day(s), from ' + startDateStr + ' to ' + endDateStr;
        
        component.set("v.confirmMessage", message);
        
        component.set("v.absenceRecord.Start_Date__c", startDate);
        component.set("v.absenceRecord.End_Date__c", endDate);
        component.set("v.absenceRecord.Absence_Reason__c", reason);
        component.set("v.absenceRecord.Additional_Comments__c", comment);
                
        //Show/Open Model,set the isOpen attribute to true
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        //Hide/Close Model,set the isOpen attribute to false  
        component.set("v.isOpen", false);
    },
    
    cancelSubmission : function(component, event, helper){
        component.set("v.isOpen", false);
        
        component.find("iStartDate").set("v.value", null);
        component.find("iEndDate").set("v.value", null);
        component.find("iReason").set("v.value", null);
        component.find("iComment").set("v.value", null);
        
        $A.enqueueAction(component.get('c.minimizeUtility'));
    },
    
    minimizeUtility : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        utilityAPI.minimizeUtility();
    }
})