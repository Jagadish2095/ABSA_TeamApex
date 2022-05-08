({
    fetchTableData: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.fetchTableData");
        console.log('component.get("v.opportunityId") = '+component.get("v.opportunityId"));
        action.setParams({
            opportunityId : component.get("v.opportunityId")
        });
        action.setCallback(this, function (data) {
            var state =  data.getState();
            if(state == "SUCCESS") {
                var allRowsMap = data.getReturnValue().rowData;
                var allRowsData = [];
                for ( var key in allRowsMap ) {
                    var header = key.indexOf("Header:") !== -1;
                    allRowsData.push({
                        rowHeader : key.replace("Header:",""), 
                        values    : allRowsMap[key], 
                        isHeader  : header
                    });
                }
                component.set("v.opportunityRecord",data.getReturnValue().opportunityRecord);
                component.set("v.tableTitle", data.getReturnValue().tableTitle);
                component.set("v.rowsData", allRowsData);
                var workingCapitalList = data.getReturnValue().channelCalculatorDTO.workingCapital;
                component.set("v.workingCapitals", workingCapitalList);
                component.set("v.isTableDataPresent", workingCapitalList.length > 0);
                component.set("v.displayAddNew", workingCapitalList.length < 3);
            } else if (state=="ERROR") {
                var errorMsg = action.getError()[0].message;
                console.log(errorMsg);
                component.set("v.opportunityRecord",data.getReturnValue().opportunityRecord);
                component.set("v.isTableDataPresent", false);
                component.set("v.isCalculateEnabled", false);
                component.set("v.displayAddNew", true);
            }
            this.rerenderCalculateButton(component);
            component.set("v.showSpinner", false);
            console.log(JSON.stringify(component.get("v.workingCapitals")));
        });
        $A.enqueueAction(action);
    },
    
    rerenderCalculateButton : function(component) {
        var workingCapitalList = component.get("v.workingCapitals");
        var displayCalculate = false;
        for(var i = 0; i < workingCapitalList.length; i++) {
            if(workingCapitalList[i].useInCalc === true) {
                displayCalculate = true;
                break;
            }
        }
        component.set("v.isCalculateEnabled", displayCalculate);
    },
    
    newFinancialDataHelper : function(component, event) {
        var newWorkingCapital = {
            "year" : "",
            "dated" : "",
            "turnOver" : 0,
            "costOfSales" : 0,
            "cash" : 0,
            "inventories" : 0,
            "receivables" : 0,
            "payables" : 0,
            "useInCalc" : false
        };
        component.set("v.tempWorkingCapital", newWorkingCapital);
        component.set("v.operationType", 'Add');
    },
    
    editFinancialDataHelper : function(component, event) {
        var workingCapitalList = component.get("v.workingCapitals");
        var index = event.getSource().get('v.name');
        console.log('Edit- index->'+index);
        
        var workingCapital = workingCapitalList[index];
        component.set("v.tempWorkingCapital", workingCapital);        
        component.set("v.operationType", 'Edit');
        component.set("v.tempIndex", index);
    },
    /*
    deleteFinancialDataHelper : function(component, event) {
        if (confirm('Are you sure you want to delete this year\'s records?') == true) {
            var workingCapitalList = component.get("v.workingCapitals");
            var index = event.getSource().get('v.name');
            console.log('Delete- index->'+index);
            workingCapitalList.splice(index, 1);
            component.set("v.workingCapitals", workingCapitalList);
            console.log(JSON.stringify(component.get("v.workingCapitals")));
            component.set("v.tempWorkingCapital", null);        
            component.set("v.operationType", 'Delete');
            component.set("v.tempIndex", index);
            this.saveDataInOpportunity(component);
        }
    },
    */
    saveFinancialDataHelper: function(component, event) {
        var operation = component.get("v.operationType");
        var workingCapitalListNew = component.get("v.workingCapitals");
        var workingCapital =component.get("v.tempWorkingCapital");
        var dateValue = new Date(workingCapital.dated);
        
        console.log('workingCapital.dated='+workingCapital.dated+', year='+workingCapital.year);
        workingCapital.year = dateValue.getFullYear();
        workingCapital.dated = this.getFormattedDate(dateValue);
        console.log('workingCapital.dated='+workingCapital.dated+', year='+workingCapital.year);
        if(operation === 'Add') {
            console.log('adding new');
            workingCapitalListNew.push(workingCapital);
        } else if(operation === 'Edit') {
            var index = component.get("v.tempIndex");
            console.log('Edit- index->'+index);
            workingCapitalListNew[index] = workingCapital;
        }
        component.set("v.workingCapitals", workingCapitalListNew);
        console.log(JSON.stringify(component.get("v.workingCapitals")));
        component.set("v.tempWorkingCapital", null);        
        component.set("v.operationType", '');
        component.set("v.tempIndex", -1);
        this.saveDataInOpportunity(component);
    },
    getFormattedDate : function(dateVar) {
        // returning date in "dd-MM-yyyy" format
        return [dateVar.getDate(), dateVar.getMonth()+1, dateVar.getFullYear()]
        .map(n => n < 10 ? `0${n}` : `${n}`).join('-');
    },
    saveDataInOpportunity : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.saveTableData");
        action.setParams({
            opportunityId : component.get("v.opportunityId"),
            newJsonData : JSON.stringify(component.get("v.workingCapitals"))
        });
        action.setCallback(this, function (data) {
            var state =  data.getState();
            if(state == "SUCCESS") {
                var allRowsMap = data.getReturnValue().rowData;
                var allRowsData = [];
                for ( var key in allRowsMap ) {
                    var header = key.indexOf("Header:") !== -1;
                    allRowsData.push({
                        rowHeader : key.replace("Header:",""), 
                        values    : allRowsMap[key], 
                        isHeader  : header
                    });
                }
                component.set("v.tableTitle", data.getReturnValue().tableTitle);
                component.set("v.rowsData", allRowsData);
                var workingCapitalList = data.getReturnValue().channelCalculatorDTO.workingCapital;
                component.set("v.workingCapitals", workingCapitalList);
                component.set("v.isTableDataPresent", workingCapitalList.length > 0);
                component.set("v.displayAddNew", workingCapitalList.length < 3);
                this.showToast(component, event);
            } else if (state=="ERROR") {
                var errorMsg = action.getError()[0].message;
                console.log(errorMsg);
                component.set("v.isTableDataPresent", false);
            }
            this.rerenderCalculateButton(component);
            component.set("v.showSpinner", false);
            console.log(JSON.stringify(component.get("v.workingCapitals")));
        });
        $A.enqueueAction(action);
    },
    editNoOfDays: function(component, event){
        //var isNoOfDaysOpen =  component.get("v.isNoOfDaysEnabled");
        component.set("v.isNoOfDaysEnabled",true);
        var isNoOfDaysOpen =  component.get("v.isNoOfDaysEnabled");
    },
    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },
    
    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
    },
    
    showToast : function(component, event) {
        var operation = component.get("v.operationType");
        console.log('inside of toast, operation = '+operation);
        var toastMsg ='';
        if(operation === 'Delete') {           
            toastMsg ="Financial Data has been deleted.";
        } else {
            toastMsg ="Financial Data has been saved.";
        }
        this.showToastMessage(component, toastMsg, "Success!", "success");
    },
    
    showToastMessage : function(component, toastMsg, toastTitle, msgType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": toastTitle,
            "message": toastMsg,
            "type": msgType
        });
        toastEvent.fire();
    },
    passCalculateListToChildComponent : function (component) {
        component.set("v.showSpinner", true);
        var workingCapitalList = component.get("v.workingCapitals");
        var workingCapitalsToCalculate = [];
        var count = 0;
        let year1 = 0;
        
        for(var i = 0; i < workingCapitalList.length; i++) {
            if(workingCapitalList[i].useInCalc === true && count < 2) {
                workingCapitalsToCalculate.push(workingCapitalList[i]);
                let currentYear = parseInt(workingCapitalList[i].year);
                if(count === 0) {
                    year1 = currentYear;
                } else if(count === 1 && Math.abs(year1-currentYear) !== 1) {
                    alert('Date validation: The selected financial reporting dates and periods do not follow consecutively.');
                    component.set("v.showSpinner", false);
                    return;
                }
                count++;
            }
        }
        
        if(workingCapitalsToCalculate.length !== 2) {
            console.log('workingCapitalsToCalculate is less than 2');
        } else {
            component.set("v.workingCapitalsToCalculate", workingCapitalsToCalculate);
            component.set("v.isCalculateSuccess", true);
        }
        component.set("v.showSpinner", false);
    },
    
    validateInputEntries: function (component, event, helper) {
        var allValid = component.find('workingCapital').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        if (allValid) {
            var workingCapital =component.get("v.tempWorkingCapital");
            var dateEntered = new Date(workingCapital.dated);
            if(!this.isValidDate(this.getFormattedDate(dateEntered))) {
                alert('Please populate a valid date in the Period of financial statements in "DD-MM-YYYY" format.');
                return false;
            }
            return true;
        } else {
            alert('Please update the invalid form entries and try again.');
            return false;
        }
    }, 
    // Validates that the input string is a valid date formatted as "DD-MM-YYYY"
    isValidDate : function (dateString) { // - "mm/dd/yyyy"
        // First check for the pattern
        if(!/^\d{1,2}-\d{1,2}-\d{4}$/.test(dateString)) {
            console.log('Invalid Date format; dateString - '+dateString);
            return false;
        }
        // Parse the date parts to integers
        var parts = dateString.split("-");
        var day = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10);
        var year = parseInt(parts[2], 10);
        
        // Check the ranges of month and year
        if(year < 1000 || year > 3000 || month == 0 || month > 12)
            return false;
        
        var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
        
        // Adjust for leap years
        if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
            monthLength[1] = 29;
        
        // Check the range of the day
        return day > 0 && day <= monthLength[month - 1];
    }
})