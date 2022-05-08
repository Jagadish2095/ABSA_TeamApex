({
    doInit : function(component, event, helper) {
        helper.getTableData(component, helper);
    },

    openFinData: function(component, event, helper){
        helper.openFin(component, helper);
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

    saveFinData: function(component, event, helper){
        var recordId = component.get("v.recordId");
        component.set("v.showModalSpinner", true);
        if(component.get("v.isDataEdit") == false){
            //Validating all input fields together by providing the same auraId 'field'	
            var isAllValid = component.find('mbblInputs').reduce(function(isValidSoFar, inputCmp){
                //display the error messages
                inputCmp.reportValidity();
                //check if the validity condition are met or not.
                return isValidSoFar && inputCmp.checkValidity();
            },true);
            if(isAllValid == true){
                var date = new Date(component.get("v.customDate"));
                var dateString = date.toLocaleDateString('en-GB').replace('/','-').replace('/','-');
                var years = date.getFullYear();
                component.set("v.mbblInputData.debtCapacityInitialDTO.year", years);
                component.set("v.mbblInputData.debtCapacityInitialDTO.statementDate", dateString);
                //Ensure that only one financial year's data is submitted
                var mbblDataList = component.get("v.allStoredMbblData");
                var validYearsSubmitted = true;
                mbblDataList.forEach(function (item, index){
                    if(item.debtCapacityInitialDTO.year == years){
                        validYearsSubmitted = false;
                    }
                });

                if(validYearsSubmitted){
                    var editData = component.get("v.mbblInputData");
                    editData.debtCapacityInitialDTO.mbblType = parseInt(editData.debtCapacityInitialDTO.mbblType);
                    editData.propertyRatings = parseInt(editData.propertyRatings);
                    var action = component.get("c.saveNewData");
                    action.setParams({
                        data : JSON.stringify(editData),
                        opportunityId : recordId
                    });
                    action.setCallback(this, function (response) {
                        component.set("v.showModalSpinner", false);
                        component.set("v.showMBBLModal", false);
                        var state = response.getState();
                        if(state === 'SUCCESS') {
                            var returnedData = response.getReturnValue();
                            console.log(returnedData);
                            helper.throwVisualSuccess(component, "Financial Data Saved Successfully.", true);
                            component.set("v.customDate", null)
                            helper.getTableData(component, helper);
                        }
                        else{
                            console.log(response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action);
                }
                else{
                    component.set("v.showModalSpinner", false);
                    helper.throwVisualToast(component, "You cannot add financial data for an existing financial year.", false);
                }
            }
            else{
                component.set("v.showModalSpinner", false);
                helper.throwVisualToast(component, "Please correct errors on input form.", false);
            }
        }
        else{
            //Validating all input fields together by providing the same auraId 'field'	
            var isAllValid = component.find('mbblInputs').reduce(function(isValidSoFar, inputCmp){
                //display the error messages
                inputCmp.reportValidity();
                //check if the validity condition are met or not.
                return isValidSoFar && inputCmp.checkValidity();
            },true);
            if(isAllValid == false){
                component.set("v.showModalSpinner", false);
                helper.throwVisualToast(component, "Please correct errors on input form.", false);
            }
            else{
                var action = component.get("c.editExistData");
                var mbblDataList = component.get("v.allStoredMbblData");
                var editData = component.get("v.mbblInputData");
                //check if year is correct on edit
                var date = new Date(component.get("v.customDate"));
                var dateString = date.toLocaleDateString('en-GB').replace('/','-').replace('/','-');
                var years = date.getFullYear();
                if(mbblDataList[component.get("v.dataEditIndex")].debtCapacityInitialDTO.year != years){
                    helper.throwVisualToast(component, "Changes to the date should fall within the same year.", false);
                    component.set("v.showModalSpinner", false);
                }
                else{
                    editData.debtCapacityInitialDTO.mbblType = parseInt(editData.debtCapacityInitialDTO.mbblType);
                    editData.propertyRatings = parseInt(editData.propertyRatings);
                    editData.debtCapacityInitialDTO.statementDate = dateString;
                    mbblDataList[component.get("v.dataEditIndex")] = editData;
                    action.setParams({
                        data : JSON.stringify(mbblDataList),
                        opportunityId : recordId
                    });
                    action.setCallback(this, function (response) {
                        component.set("v.showModalSpinner", false);
                        component.set("v.showMBBLModal", false);
                        var state = response.getState();
                        if(state === 'SUCCESS') {
                            helper.throwVisualSuccess(component, "Action Successful.", true);
                            component.set("v.isDataEdit", false);
                            component.set("v.dataEditIndex", null);
                            component.set("v.mbblInputData", null);
                            component.set("v.customDate", null)
                            helper.getTableData(component, helper);
                        }
                        else{
                            console.log(response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        }
    },

    saveLoanData: function(component, event, helper){
        var recordId = component.get("v.recordId");
        try{
            if(component.get("v.isDataEdit") == false){
                //Validating all input fields together by providing the same auraId 'field' 
                var isAllValid = component.find('mbblLoanInput').reduce(function(isValidSoFar, inputCmp){
                    //display the error messages
                    inputCmp.reportValidity();
                    //check if the validity condition are met or not.
                    return isValidSoFar && inputCmp.checkValidity();
                },true);
                if(isAllValid == true){
                    var loansList = component.get('v.loanScenarioData');
                    console.log(loansList);
                    var inputData = component.get('v.mbblLoanInputData');
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
                        opportunityId : recordId
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
            else{
                //Validating all input fields together by providing the same auraId 'field' 
                var isAllValid = component.find('mbblLoanInput').reduce(function(isValidSoFar, inputCmp){
                    //display the error messages
                    inputCmp.reportValidity();
                    //check if the validity condition are met or not.
                    return isValidSoFar && inputCmp.checkValidity();
                },true);
                if(isAllValid == true){
                    var loansList = component.get("v.loanScenarioData");
                    var loanIndex = component.get("v.loanEditIndex");
                    var editedPos = loansList[loanIndex];

                    var inputData = component.get('v.mbblLoanInputData');
                    inputData.loanType = parseInt(inputData.loanType);
                    inputData.loanAmount = parseFloat(inputData.loanAmount);
                    inputData.intrestRate = parseFloat(inputData.intrestRate);

                    loansList.forEach(function(item, index){
                        if((inputData.loanType == item.loanType) && (loanIndex != index)){
                            //helper.throwVisualToast(component, 'Loan scenario with this loan type already exists.', false);
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
                        opportunityId : recordId
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
        }
        catch(e){
            console.log(e.toString());
            component.set("v.showModalSpinner", false);
            helper.throwVisualToast(component,JSON.stringify(e.toString()),false);
        }
    },

    clickDeleteNormalLoan: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var selectedIndex = event.getSource().get('v.name');
        if (confirm('Are you sure you want to delete this loan scenario information?') == true) {
            component.set("v.showBodySpinner", true);
            var mbblDataList = component.get("v.allStoredMbblData");
            //delete data
            mbblDataList[selectedIndex].loanDetailsDTO = null;
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(mbblDataList),
                opportunityId : recordId
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
            });
            $A.enqueueAction(action);
        }
    },

    clickDeleteOvrLoan: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var selectedIndex = event.getSource().get('v.name');
        if (confirm('Are you sure you want to delete this loan scenario information?') == true) {
            component.set("v.showBodySpinner", true);
            var mbblDataList = component.get("v.allStoredMbblData");
            //delete data
            mbblDataList[selectedIndex].overdraftFacilityDTO = null;
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(mbblDataList),
                opportunityId : recordId
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
            });
            $A.enqueueAction(action);
        }
    },

    clickEditOvrLoan: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        console.log("index: "+selectedIndex);
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3 "},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }])
        var loanList = component.get("v.loanScenarioData");
        var data = loanList[selectedIndex];
        data.loanType = "5";
        component.set("v.mbblLoanInputData", data);
        component.set("v.showLoanInputModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.loanEditIndex", selectedIndex);
    },

    clickEditNormalLoan: function(component, event, helper){
        var selectedIndex = event.getSource().get('v.name');
        console.log("index: "+selectedIndex);
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3 "},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }])
        var loanList = component.get("v.loanScenarioData");
        var data = loanList[selectedIndex];
        component.set("v.mbblLoanInputData", data);
        component.set("v.showLoanInputModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.loanEditIndex", selectedIndex);
    },

    clickIncludeCheck: function(component, event, helper){
        var selectedIndex = event.getSource().get('v.name');
        console.log(selectedIndex);
        console.log(event);
        var mbblDataList = component.get("v.allStoredMbblData");
        var dataItem = mbblDataList[selectedIndex];
        dataItem.debtCapacityInitialDTO.useInCalculation = !dataItem.debtCapacityInitialDTO.useInCalculation;
        console.log(dataItem.debtCapacityInitialDTO.useInCalculation);
        mbblDataList[selectedIndex] = dataItem;
        component.set("v.allStoredMbblData",mbblDataList);

        //For visual accuracy, change boolean value in table list too
        var dataTable = component.get("v.mbblTableData");
        dataTable.forEach(function(item, index){
            if(item.header == 'Include In Calculation'){
                item.values[selectedIndex] = (item.values[selectedIndex] == true) ? false : true;
            }
        })
        console.log(mbblDataList);
        console.log(dataTable);
        component.set("v.mbblTableData", dataTable);
    },

    calculateMBBL: function(component, event, helper){
        try{
            component.set("v.showBodySpinner", true);
            var allData = component.get("v.allStoredMbblData");
            var selectedData = [];
            //Loop and get data that is selected to be in calculation
            allData.forEach(function(item, index){
                if(item.debtCapacityInitialDTO.useInCalculation){
                    selectedData.push(item);
                }
            });
            /* if(selectedData.length != 2){
                component.set("v.showBodySpinner", false);
                helper.throwVisualToast(component, "MBBL Calculation requires atleast 2 financial years to be included in the calculation. Please check your financial input data.", false);
            }
            else if((selectedData[0].debtCapacityInitialDTO.year - selectedData[1].debtCapacityInitialDTO.year != 1) && (selectedData[1].debtCapacityInitialDTO.year - selectedData[0].debtCapacityInitialDTO.year != 1)){
                component.set("v.showBodySpinner", false);
                helper.throwVisualToast(component, "MBBL Calculation requires atleast 2 consecutive financial years.", false);
            }
            else{ */
                console.log(JSON.stringify(selectedData));
                var loanList = component.get("v.loanScenarioData");
                console.log(loanList);
                var recordId = component.get("v.recordId");
                var action = component.get("c.mbblCalculate");
                    action.setParams({
                        opportunityId : recordId,
                        currentData: JSON.stringify(selectedData),
                        loanData: JSON.stringify(loanList)
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        console.log(state);
                        if(state === 'SUCCESS') {
                            console.log(response.getReturnValue());
                            var returnedData = response.getReturnValue();
                            var errors = '';
                            if(returnedData.success == false){
                                errors = returnedData.message.join();
                                console.log(errors);
                                helper.throwVisualToast(component, errors, false);
                            }
                            else{
                                console.log(returnedData.data);
                                var allRowsData = [];
                                var allLoansRowsData = [];
                                var allKRData = [];
                                for ( var key in returnedData.data.normalResultTable ) {
                                    allRowsData.push({
                                        header : key, 
                                        values : returnedData.data.normalResultTable[key], 
                                        isDarkHeader : (key == 'New Interest Bearing Debt') ? true : false,
                                        isHeader  : (key == 'Income Statement' || key == 'Present Key Ratios' || key == 'Cash Flow Statement' || key == 'Balance Sheet') ? true : false
                                    });
                                }
                                for ( var key in returnedData.data.loanResultTable ) {
                                    allLoansRowsData.push({
                                        header : key, 
                                        values : returnedData.data.loanResultTable[key], 
                                        isDarkHeader : (key == 'New Interest Bearing Debt (Current Year)') ? true : false,
                                        isHeader  : (key == 'Loan' || key == 'Overdraft Facility' || key == 'Total New') ? true : false
                                    });
                                }
                                for ( var key in returnedData.data.expectedKRTable ) {
                                    //check number or string
                                    var customValues = [];
                                    returnedData.data.expectedKRTable[key].forEach(function(item){
                                        if(!isNaN(item)){
                                            customValues.push({
                                                value : item,
                                                isNumber : true
                                            })
                                        }
                                        else{
                                            customValues.push({
                                                value : item,
                                                isNumber : false
                                            })
                                        }
                                    });

                                    allKRData.push({
                                        header : key, 
                                        values : customValues, 
                                        isHeader  : (key == 'Expected Key Ratios (after adding new IBD)') ? true : false
                                    });
                                }
                                helper.throwVisualSuccess(component, "Action Successful.", true);
                                console.log(allRowsData);
                                component.set("v.mbblResultsTableData", allRowsData);
                                component.set("v.mbblLoansResultsTableData", allLoansRowsData);
                                component.set("v.mbblEKRResultsTableData", allKRData);
                                component.set("v.resultsAvailable", true);
                            }
                            component.set("v.showBodySpinner", false);
                        }
                        else{
                            component.set("v.showBodySpinner", false);
                            helper.processMethodError(component, helper, errors);
                            //helper.throwVisualToast(component, "An error occured during calculation. Ensure thats loan and overdraft data is available for each year regardless of value (Values can be set to 0).", false);
                        };
                });
                $A.enqueueAction(action);
        }
        catch(e){
            component.set("v.showBodySpinner", false);
            console.log(e);
        }
        
    },

    resetCalc: function (component,event,helper){
        component.set("v.mbblResultsTableData", []);
        component.set("v.mbblLoansResultsTableData", []);
        component.set("v.mbblEKRResultsTableData", []);
        component.set("v.resultsAvailable", false);
        helper.throwVisualSuccess(component, "Calculator Reset.", true);
    },

    clickDelete: function(component, event, helper){
        helper.deleteFin(component, event, helper);
    },

    clickEdit: function(component, event, helper){
        helper.editFin(component, event);
    },

    hideModal: function(component, event, helper){
        helper.hideModal(component);
    },
    
    exportToPdf: function(component, event, helper){
        window.print();
    }

})