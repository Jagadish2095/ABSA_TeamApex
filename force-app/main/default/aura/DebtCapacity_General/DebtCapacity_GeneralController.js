({
    doInit : function(component, event, helper) {
		helper.getTableData(component, helper);
        //helper.getResultsTable(component);
    },
    
	Adddata: function(component, event, helper){
        component.set("v.showModalSpinner", true);
        component.set("v.ttcOptions", [
            { label: '1 to 4', value: '1 to 4' },
            { label: '5 to 9', value: '5 to 9' },
            { label: '10 to 13', value: '10 to 13' },
            { label: '14 to 16', value: '14 to 16' },
            { label: '17 to 21', value: '17 to 21' },])
        component.set("v.showGeneralModal", true);
        var action = component.get("c.getNewData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                component.set("v.GeneralInputData", returnedData);
                console.log(returnedData);
                component.set("v.showModalSpinner", false);
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },
    
    AddLoandata: function(component, event, helper){
        component.set("v.showModalSpinner", true);
        component.set("v.Loan type", [
            { label: 'Overdraft', value: 'Overdraft'},
            { label: 'Long Term', value: 'Long Term' },
            { label: 'Short term', value: 'Short Term'},])
        component.set("v.showGeneralModal", true);
        var action = component.get("c.getNewData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                component.set("v.GeneralInputData", returnedData);
                console.log(returnedData);
                component.set("v.showModalSpinner", false);
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },

    hideModal: function(component, event, helper){
        component.set("v.showGeneralModal", false);
        component.set("v.showLoanInputModal", false);
        component.set("v.isDataEdit", false);
        component.set("v.dataEditIndex", null);
        component.set("v.GeneralInputData", null);
    },

    saveFinData: function(component, event, helper){
        if(!helper.validateInputEntries(component, event, helper)) {
        	console.log('validateInputEntries returned false');
            return;
        }
        component.set("v.showModalSpinner", true);
        if(component.get("v.isDataEdit") == false){
            var action = component.get("c.saveNewData");
            action.setParams({
                data : JSON.stringify(component.get("v.GeneralInputData")),
                opportunityId : component.get("v.opportunityId")
            });
            action.setCallback(this, function (response) {
                component.set("v.showModalSpinner", false);
                component.set("v.showGeneralModal", false);
                var state = response.getState();
                if(state === 'SUCCESS') {
                    helper.throwVisualSuccess(component, "Financial Data Saved Successfully.", true);
                    var returnedData = response.getReturnValue();
                    console.log(returnedData);
                    helper.getTableData(component,helper);
                }
                else{
                    console.log(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var action = component.get("c.editExistData");
            var GeneralDataList = component.get("v.allStoredGeneralData");
            GeneralDataList[component.get("v.dataEditIndex")] = component.get("v.GeneralInputData");
            action.setParams({
                data : JSON.stringify(GeneralDataList),
                opportunityId : component.get("v.opportunityId")
            });
            action.setCallback(this, function (response) {
                component.set("v.showModalSpinner", false);
                component.set("v.showGeneralModal", false);
                var state = response.getState();
                if(state === 'SUCCESS') {
                    helper.throwVisualSuccess(component, "Financial Data Saved Successfully.", true);
                    var returnedData = response.getReturnValue();
                    component.set("v.isDataEdit", false);
                    component.set("v.dataEditIndex", null);
                    component.set("v.GeneralInputData", null);
                    helper.getTableData(component,helper);
                }
                else{
                    console.log(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
        
    },

   clickDelete: function(component, event, helper){        
        var selectedIndex = event.getSource().get('v.name');
        console.log(component.get("v.allStoredGeneralData"));
        if (confirm('Are you sure you want to delete this year\'s records?') == true) {
            component.set("v.showBodySpinner", true);
            var GeneralDataList = component.get("v.allStoredGeneralData");
            GeneralDataList.splice(selectedIndex,1);            
            console.log(GeneralDataList.splice(0));
            console.log('selectedIndex===>'+selectedIndex);
            component.set("v.allStoredGeneralData", GeneralDataList);
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(GeneralDataList),
                  //opportunityId : '0065r000002xWY0AAM'
                opportunityId : component.get("v.opportunityId")
            });
            action.setCallback(this, function (response) {
                component.set("v.showGeneralModal", false);
                var state = response.getState();
                if(state === 'SUCCESS') {
                    helper.throwVisualSuccess(component, "Financial Data Deleted Successfully.", true);
                    var returnedData = response.getReturnValue();
                    component.set("v.isDataEdit", false);
                    component.set("v.dataEditIndex", null);
                    component.set("v.GeneralInputData", null);
                    helper.getTableData(component,helper);
                }
                else{
                    console.log(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    clickEdit: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        component.set("v.ttcOptions", [
            { label: '1 to 4', value: '1 to 4' },
            { label: '5 to 9', value: '5 to 9' },
            { label: '10 to 13', value: '10 to 13' },
            { label: '14 to 16', value: '14 to 16' },
            { label: '17 to 21', value: '17 to 21' },]);
        component.set("v.GeneralInputData", component.get("v.allStoredGeneralData")[selectedIndex]);
        component.set("v.showGeneralModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.dataEditIndex", selectedIndex);
    },
    
    clickDeleteNormalLoan: function(component, event, helper){
        var selectedIndex = event.getSource().get('v.name');
        if (confirm('Are you sure you want to delete this loan scenario information?') == true) {
            component.set("v.showBodySpinner", true);
			var selectedIndex = event.getSource().get('v.name');
			var loanRecords = component.get("v.loanScenarioData");
			var currentLoan = loanRecords[selectedIndex];
			var inputData = component.get('v.debtLoanInputData');
			//find appropriate year
			var loanDataYear = currentLoan.year;
			console.log('@@ loanDataYear='+loanDataYear+'; currentLoan->'+JSON.stringify(currentLoan));
			
			var debtDataList = component.get("v.allStoredGeneralData");
			var matchedYearIndex = -1;
			for(var i = 0; i < debtDataList.length; i++){
				if(debtDataList[i].debtCapacityInitialDTO.year == loanDataYear){
					matchedYearIndex = i;
					debtDataList[i].loanDetailsDTO = null;
				}
			}
			console.log('@@ matchedYearIndex='+matchedYearIndex);
			if(matchedYearIndex === -1){
				console.log('@@ matching year not found while deletion');
				return;
			}
			
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(debtDataList),
                opportunityId : component.get("v.opportunityId")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                    helper.throwVisualSuccess(component, "Loan Data Deleted.", true);
                    var returnedData = response.getReturnValue();
                    component.set("v.isDataEdit", false);
                    helper.getTableData(component, helper);
                }
                else{
                    console.log(response.getReturnValue());
                }
				component.set("v.showBodySpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    clickDeleteOvrLoan: function(component, event, helper){
        if (confirm('Are you sure you want to delete this loan scenario information?') == true) {
            component.set("v.showBodySpinner", true);
			var selectedIndex = event.getSource().get('v.name');
			var loanRecords = component.get("v.loanScenarioData");
			var currentLoan = loanRecords[selectedIndex];
			var inputData = component.get('v.debtLoanInputData');
			//find appropriate year
			var loanDataYear = currentLoan.year;
			console.log('@@ loanDataYear='+loanDataYear+'; currentLoan->'+JSON.stringify(currentLoan));
			
			var debtDataList = component.get("v.allStoredGeneralData");
			var matchedYearIndex = -1;
			for(var i = 0; i < debtDataList.length; i++){
				if(debtDataList[i].debtCapacityInitialDTO.year == loanDataYear){
					matchedYearIndex = i;
					debtDataList[i].overdraftFacilityDTO = null;
				}
			}
			console.log('@@ matchedYearIndex='+matchedYearIndex);
			if(matchedYearIndex === -1){
				console.log('@@ matching year not found while deletion');
				return;
			}
			
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(debtDataList),
                opportunityId : component.get("v.opportunityId")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                    helper.throwVisualSuccess(component, "Loan Data Deleted.", true);
                    var returnedData = response.getReturnValue();
                    component.set("v.isDataEdit", false);
                    helper.getTableData(component, helper);
                }
                else{
                    console.log(response.getReturnValue());
                }
				component.set("v.showBodySpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    clickEditOvrLoan: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3"},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }])
        var loanRecords = component.get("v.loanScenarioData");
        var currentLoan = loanRecords[selectedIndex];
		currentLoan.loanType = "5";
		currentLoan.loanAmount= currentLoan.loanAmount;
        currentLoan.term= currentLoan.term;
        currentLoan.intrestRate= currentLoan.intrestRate;
        				
        component.set("v.debtLoanInputData", currentLoan);
        component.set("v.showLoanInputModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.loanEditIndex", selectedIndex);
    },

    clickEditNormalLoan: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3"},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }])
        var loanRecords = component.get("v.loanScenarioData");
        var currentLoan = loanRecords[selectedIndex];
		console.log('currentLoan->'+JSON.stringify(currentLoan));
        component.set("v.debtLoanInputData", currentLoan);
        component.set("v.showLoanInputModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.loanEditIndex", selectedIndex);
    },

    clickIncludeCheck: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        console.log(selectedIndex);
        console.log(event);
        var GeneralDataList = component.get("v.allStoredGeneralData");
        var dataItem = GeneralDataList[selectedIndex];
        dataItem.debtCapacityInitialDTO.useInCalculation = !dataItem.debtCapacityInitialDTO.useInCalculation;
        console.log(dataItem.debtCapacityInitialDTO.useInCalculation);
        GeneralDataList[selectedIndex] = dataItem;
        component.set("v.allStoredGeneralData",GeneralDataList);

        //For visual accuracy, change boolean value in table list too
        var dataTable = component.get("v.GeneralTableData");
        dataTable.forEach(function(item, index){
            if(item.header == 'Include In Calculation'){
                item.values[selectedIndex] = (item.values[selectedIndex] == 'true') ? 'false' : 'true';
            }
        })
        component.set("v.GeneralTableData", dataTable);

        //enable calculate button dynamically
        var isCalculateEnabled = false;
        for(var i = 0; i < GeneralDataList.length; i++) {
            if(GeneralDataList[i].debtCapacityInitialDTO.useInCalculation === true) {
         		isCalculateEnabled = true;
                break;
            }
        }
        component.set("v.isCalculateEnabled",isCalculateEnabled);
    },
    
	resetCalculator: function (component,event,helper){
        component.set("v.isCalculateSuccess", false);
        component.set("v.showDebtCalResults", false);
        component.set("v.filteredResultTableData",[]);
        helper.throwVisualSuccess(component, "Calculator Reset.", true);
    },
    
	clickCalculate: function (component,event,helper){
        // alert('Inside of Button click');
        //alert('input='+component.get("v.allStoredGeneralData"));
        var loanList = component.get("v.loanScenarioData");
        console.log(loanList);
        if(!helper.validateCountOfRecordsToCalculate(component)) {
            console.log('validateCountOfRecordsToCalculate unsuccessful');
            return;
        }

        //Reset filtered list
        component.set("v.filteredResultTableData", []);
        //filter master data and place into filtered link
        var allList = component.get("v.allStoredGeneralData");
        var filteredList = component.get("v.filteredResultTableData");
        allList.forEach(function(item,index){
            if(item.debtCapacityInitialDTO.useInCalculation == true){
                filteredList.push(item);
            }
        })
        component.set("v.filteredResultTableData",filteredList);
        component.set("v.isCalculateSuccess", true);
        component.set("v.showDebtCalResults", true);
    },
    
	reloadData: function(component, event, helper){
        component.set("v.showGeneralModal", false);
        component.set("v.showLoanInputModal", false);
        component.set("v.isDataEdit", false);
        component.set("v.dataEditIndex", null);
        component.set("v.GeneralInputData", null);
        component.set("v.debtLoanInputData", null);
    },
    
	saveLoanData: function(component, event, helper){
        try{
            if(component.get("v.isDataEdit") == false){
                    var loansList = component.get('v.loanScenarioData');
                    console.log(loansList);
                    var inputData = component.get('v.debtLoanInputData');
                    inputData.loanType = parseInt(inputData.loanType);
                    inputData.loanAmount = parseFloat(inputData.loanAmount);
                    inputData.intrestRate = parseFloat(inputData.intrestRate);
                    console.log(inputData);

                    loansList.forEach(function(item, index){
                        if((inputData.loanType == item.loanType)){
                            throw new Error("Loan scenario with this loan type already exists.");
                        }
                    })

                    if((inputData.term > 12) && inputData.loanType == 5){
                        throw new Error("Overdraft loans should have a maximum term of 12.");
                    }
                    
                    var loanObject = {};
                    loanObject.loanType = inputData.loanType;
                    loanObject.loanAmount = inputData.loanAmount;
                    loanObject.term = inputData.term;
                    loanObject.intrestRate = inputData.intrestRate;
                    loansList.push(loanObject);

                    if(loansList.length == 3){
                        var overdraftCount = 0;
                        var normalCount = 0
                        loansList.forEach(function(item, index){
                            if((item.loanType == 5)){
                                overdraftCount++;
                            }
                            else{
                                normalCount++;
                            }
                        })

                        if(normalCount != 2){
                            loansList.splice(loansList.length - 1, 1);
                            throw new Error("Loan scenarios must have a total of 1 Overdraft Scenario and 2 Non-Overdraft Scenarios.");
                        }
                    }

                    component.set("v.showModalSpinner", true);
                    var action = component.get("c.saveLoan");
                    action.setParams({
                        data : JSON.stringify(loansList),
                        opportunityId : component.get("v.opportunityId")
                    });
                    action.setCallback(this, function (response) {
                        component.set("v.showLoanInputModal", false);
                        var state = response.getState();
                        if(state === 'SUCCESS') {
                            helper.throwVisualSuccess(component, "Action Successful.", true);
                            helper.getTableData(component, helper);
                            component.set("v.isDataEdit", false);
                        }
                        else{
                            component.set("v.showModalSpinner", false);
                            component.set("v.isDataEdit", false);
                            console.log(response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action);
            }
            else{
                    var loansList = component.get("v.loanScenarioData");
                    var loanIndex = component.get("v.loanEditIndex");
                    var editedPos = loansList[loanIndex];

                    var inputData = component.get('v.debtLoanInputData');
                    inputData.loanType = parseInt(inputData.loanType);
                    inputData.loanAmount = parseFloat(inputData.loanAmount);
                    inputData.intrestRate = parseFloat(inputData.intrestRate);

                    loansList.forEach(function(item, index){
                        if((inputData.loanType == item.loanType) && (loanIndex != index)){
                            throw new Error("Loan scenario with this loan type already exists.");
                        }
                    })

                    if((inputData.term > 12) && inputData.loanType == 5){
                        throw new Error("Overdraft loans should have a maximum term of 12.");
                    }
                    
                    editedPos.loanType = inputData.loanType;
                    editedPos.loanAmount = inputData.loanAmount;
                    editedPos.term = inputData.term;
                    editedPos.intrestRate = inputData.intrestRate;
                    loansList[loanIndex] = editedPos;

                    if(loansList.length == 3){
                        var overdraftCount = 0;
                        var normalCount = 0
                        loansList.forEach(function(item, index){
                            if((item.loanType == 5)){
                                overdraftCount++;
                            }
                            else{
                                normalCount++;
                            }
                        })

                        if(normalCount != 2){
                            throw new Error("Loan scenarios must have a total of 1 Overdraft Scenario and 2 Non-Overdraft Scenarios.");
                        }
                    }

                    component.set("v.showModalSpinner", true);
                    var action = component.get("c.saveLoan");
                    action.setParams({
                        data : JSON.stringify(loansList),
                        opportunityId : component.get("v.opportunityId")
                    });
                    action.setCallback(this, function (response) {
                        component.set("v.showLoanInputModal", false);
                        var state = response.getState();
                        if(state === 'SUCCESS') {
                            helper.throwVisualSuccess(component, "Action Successful.", true);
                            helper.getTableData(component, helper);
                            component.set("v.isDataEdit", false);
                        }
                        else{
                            component.set("v.showModalSpinner", false);
                            component.set("v.isDataEdit", false);
                            console.log(response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action);
            }
        }
        catch(e){
            console.log(e.toString());
            component.set("v.showModalSpinner", false);
            helper.throwVisualError(component, JSON.stringify(e.toString()), false);
        }
    },
    
	openLoanData: function(component, event, helper){
        var loanList = component.get("v.loanScenarioData");
        if(loanList.length >= 3){
            helper.throwVisualToast(component, 'There cannot be more than three loan scenarios on this table.', false);
        }
        else{
            helper.openLoan(component, helper);
        }
    },

    getCalcMessage: function(component, event, helper){
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var success = params.successParam;
            if(!success){
                component.set("v.isCalculateSuccess", false);
                component.set("v.showDebtCalResults", false);
            }
            else{
                component.set("v.isCalculateSuccess", true);
                component.set("v.showDebtCalResults", true);
            }
        }
    },
})