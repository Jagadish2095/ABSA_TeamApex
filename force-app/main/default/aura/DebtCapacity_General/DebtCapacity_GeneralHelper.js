({
    helperMethod : function() {

    },

    getTableData: function (component,helper){
        component.set("v.showBodySpinner", true);
        var action = component.get("c.getTableData");
        action.setParams({
             opportunityId : component.get("v.opportunityId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                if(response.getReturnValue() != null){
                    var allGeneralData = response.getReturnValue().GeneralData;
                    var returnedData = response.getReturnValue().data;
                    var loanData = response.getReturnValue().loanData;
                    var allRowsData = [];
                    for ( var key in returnedData ) {
                        allRowsData.push({
                            header : key, 
                            values : returnedData[key], 
                            isHeader  : (key == 'Income Statement' || key == 'Cash Flow Statement' || key == 'Balance Sheet' || key == 'Existing Interest Bearing Debt') ? true : false
                        });
                    }
                    component.set("v.GeneralTableData", allRowsData);
                    component.set("v.allStoredGeneralData", allGeneralData);
                    helper.setLoanData(component, loanData);
                    component.set("v.displayAddNew", allGeneralData.length < 3);
                    var isCalculateEnabled = false;
                    for(var i = 0; i < allGeneralData.length; i++) {
                        if(allGeneralData[i].debtCapacityInitialDTO.useInCalculation === true) {
                            isCalculateEnabled = true;
                            break;
                        }
                    }
                    component.set("v.isCalculateEnabled",isCalculateEnabled);
                }
                else{
                    component.set("v.GeneralTableData", []);
                    component.set("v.allStoredGeneralData", []);
                    component.set("v.displayAddNew", true);
                }
                component.set("v.showBodySpinner", false);
                component.set("v.showModalSpinner", false);
            }
            else{
                component.set("v.GeneralTableData", []);
                component.set("v.allStoredGeneralData", []);
                component.set("v.displayAddNew", true);
                helper.processMethodError(component, helper, response.getError());
            }
            component.set("v.showBodySpinner", false);
        });
        $A.enqueueAction(action);
    },
    
	setLoanData: function(component, lData){
        var loanData = [];
        if(lData){
            for(var i = 0; i < lData.length; i++){
                var data = lData[i];
                data.type = (data.loanType == '5') ? 'Overdraft' : 'Normal';
                data.masterIndex = i;
                data.uiPercentage = parseFloat(lData[i].intrestRate / 100);
                loanData.push(data);
            }
        }
        component.set('v.loanScenarioData', loanData);
        console.log(loanData);
    },
    
    getResultsTable: function(component){
        var action = component.get("c.getRespData");
        action.setParams({
           // opportunityId : '0065r000002xWY0AAM'
            opportunityId : component.get("v.opportunityId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                var allRowsData = [];
                for ( var key in returnedData ) {
                    allRowsData.push({
                        header : key, 
                        values : returnedData[key], 
                        isHeader  : (key == 'Income Statement' || key == 'Present Key Ratios' || key == 'Minimum Annual Payments' || key == 'Cash Flow Statement' || key == 'Balance Sheet' || key == 'Existing Interest Bearing Debt') ? true : false
                    });
                }
                component.set("v.GeneralResultsTableData", allRowsData);
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },
    
    validateCountOfRecordsToCalculate : function (component) {
        component.set("v.showBodySpinner", true);
    	var allStoredGeneralData = component.get("v.allStoredGeneralData");
        console.log('allStoredGeneralData -> '+JSON.stringify(allStoredGeneralData))
        var count = 0;
        let year1 = 0;
        
        /* for(var i = 0; i < allStoredGeneralData.length; i++) {
            console.log(i+' debtCapacityInitialDTO.useInCalculation='+allStoredGeneralData[i].debtCapacityInitialDTO.useInCalculation);
            if(allStoredGeneralData[i].debtCapacityInitialDTO.useInCalculation === true && count < 2) {
                let currentYear = parseInt(allStoredGeneralData[i].debtCapacityInitialDTO.year);
                if(count === 0) {
                    year1 = currentYear;
                } else if(count === 1 && Math.abs(year1-currentYear) !== 1) {
                    this.throwVisualError(component, "Debt Capacity Calculation requires atleast 2 consecutive financial years.", false);
                    //alert('Date validation: The selected financial reporting dates and periods do not follow consecutively.');
                    component.set("v.showBodySpinner", false);
    				return false;
                }
                count++;
            }
        }
        
        if(count !== 2) {
            //console.log('Count of records with use in calculation is less than 2');
            this.throwVisualError(component, "Count of records with use in calculation is less than 2.", false);
            component.set("v.showBodySpinner", false);
            return false;
        }  */
        component.set("v.showBodySpinner", false);
        return true;
    },
    
    validateInputEntries: function (component, event, helper) {
        var allValid = component.find('GeneralInputs').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var returnVal = false;
        if (allValid) {
            var dateEntered = new Date(component.get("v.GeneralInputData.debtCapacityInitialDTO.statementDate"));
			if(!this.isValidDate(this.getFormattedDate(dateEntered))) {
                this.throwVisualError(component, 'Please populate a valid date in the Period of financial statements.', false);
                return false;
            }
            var years = dateEntered.getFullYear();
            component.set("v.GeneralInputData.debtCapacityInitialDTO.year", years);
            returnVal = true;
        } else {
            this.throwVisualError(component, 'Please update the invalid form entries and try again.', false);
            returnVal = false;
        }
        console.log('validateInputEntries->returnVal = '+returnVal);
        return returnVal;
    },
	
	validateLoanInputEntries: function (component, event, helper) {
        var allValid = component.find('debtLoanInput').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        var returnVal = false;
        if (allValid) {
            returnVal = true;
            if(!component.get("v.isDataEdit")) {
                returnVal = [].concat(component.find('debtLoanInputDate')).reduce(function (validSoFar, inputCmp) {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
                }, true);
                if(!returnVal) {
                	this.throwVisualError(component, 'Please update the invalid form entries and try again.', false);
            	}
            }
        } else {
            this.throwVisualError(component, 'Please update the invalid form entries and try again.', false);
            returnVal = false;
        }
        console.log('validateInputEntries->returnVal = '+returnVal);
        return returnVal;
    },
	
    throwVisualError : function(component, message, state) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": message,
            "variant": (state) ? "success" : "error"
        });
    },
    throwVisualSuccess : function(component, message, state) {
        component.find('notifLib').showToast({
            "title": "Success!",
            "message": message,
            "variant": (state) ? "success" : "error"
        });
    },
    getFormattedDate : function(dateVar) {
        // returning date in "dd-MM-yyyy" format
        console.log('dateVar'+dateVar);
        return [dateVar.getDate(), dateVar.getMonth()+1, dateVar.getFullYear()]
      	.map(n => n < 10 ? `0${n}` : `${n}`).join('-');
    },
    // Validates that the input string is a valid date formatted as "dd-MM-yyyy"
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
	},

    processMethodError: function(component, helper, errors){
        var message = 'Unknown error';
        if (errors && Array.isArray(errors) && errors.length > 0) {
            message = errors[0].message;
        }
        helper.throwVisualToast(component, message, false);
    },

    throwVisualToast : function(component, message, state) {
        component.find('notifLib').showToast({
            "title": "We Hit A Snag!",
            "message": message,
            "variant": (state) ? "success" : "error"
        });
    },

    openLoan: function(component, helper){
        component.set("v.showModalSpinner", true);
        component.set("v.isDataEdit", false);
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3"},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }]);
        component.set("v.showLoanInputModal", true);
        var action = component.get("c.getEmptyLoanData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                returnedData.loanType = returnedData.loanType.toString();
                component.set("v.debtLoanInputData", returnedData);
                console.log('openLoanData->'+returnedData);
                component.set("v.showModalSpinner", false);
            }
            else{
                helper.processMethodError(component, helper, response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})