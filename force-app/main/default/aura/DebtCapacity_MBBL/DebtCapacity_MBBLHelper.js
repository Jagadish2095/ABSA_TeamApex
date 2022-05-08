({
    getTableData: function (component, helper){
        var recordId = component.get("v.recordId");
        component.set("v.showBodySpinner", true);
        var action = component.get("c.getTableData");
        action.setParams({
            opportunityId : recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                if(response.getReturnValue() != null){
                    var allMbblData = response.getReturnValue().mbblData;
                    var returnedData = response.getReturnValue().data;
                    var loanData = response.getReturnValue().loanData;
                    console.log(loanData);
                    var allRowsData = [];
                    for ( var key in returnedData ) {
                        if(key == 'Include In Calculation'){
                            var boolValues = [];
                            returnedData[key].forEach(function (item, index){
                                if(item == 'true'){
                                    boolValues.push(true);
                                }
                                else{
                                    boolValues.push(false);
                                }
                            });
                            console.log(boolValues);
                            allRowsData.push({
                                header : key, 
                                values : boolValues, 
                                isHeader  : false
                            });
                        }
                        else{
                            allRowsData.push({
                                header : key, 
                                values : returnedData[key], 
                                isHeader  : (key == 'Minimum Annual Payments' || key == 'Present Key Ratios' || key == 'Income Statement' || key == 'Cash Flow Statement' || key == 'Balance Sheet' || key == 'Existing Interest Bearing Debt') ? true : false
                            });
                        }
                    }
                    console.log(allRowsData);
                    component.set("v.mbblTableData", allRowsData);
                    component.set("v.allStoredMbblData", allMbblData);
                    component.set("v.isDataEdit", false);
                    helper.setLoanData(component, loanData);
                }
                else{
                    component.set("v.isDataEdit", false);
                    component.set("v.mbblTableData", []);
                    component.set("v.allStoredMbblData", []);
                }
                component.set("v.isDataEdit", false);
                component.set("v.showBodySpinner", false);
                component.set("v.showModalSpinner", false);
            }
            else{
                component.set("v.isDataEdit", false);
                component.set("v.mbblTableData", []);
                component.set("v.allStoredMbblData", []);
                helper.processMethodError(component, helper, response.getError());
            }
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
    },

    hideModal: function(component){
        component.set("v.showMBBLModal", false);
        component.set("v.showLoanInputModal", false);
        component.set("v.isDataEdit", false);
        component.set("v.dataEditIndex", null);
        component.set("v.mbblInputData", null);
    },

    openFin: function(component, helper){
        component.set("v.showModalSpinner", true);
        console.log(Date.parse('2021/06/14'));
        component.set("v.ttcOptions", [
            { label: '1 to 4', value: '1 to 4' },
            { label: '5 to 9', value: '5 to 9' },
            { label: '10 to 13', value: '10 to 13' },
            { label: '14 to 16', value: '14 to 16' },
            { label: '17 to 21', value: '17 to 21' },]);
        component.set("v.mbblType", [
            { label: 'Non Specialised', value: '2' },
            { label: 'Specialised', value: '1' }]);
        component.set("v.propertyRatingType", [
          { label: "Below Average", value: "1" },
          { label: "Average", value: "2" },
          { label: "Above Average", value: "3" }
        ]);
        component.set("v.showMBBLModal", true);
        var action = component.get("c.getEmptyMBBLData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                returnedData.debtCapacityInitialDTO.mbblType = returnedData.debtCapacityInitialDTO.mbblType.toString();
                returnedData.propertyRatings = returnedData.propertyRatings.toString();
                component.set("v.mbblInputData", returnedData);
                console.log(returnedData);
                component.set("v.showModalSpinner", false);
            }
            else{
                component.set("v.showModalSpinner", false);
                component.set("v.showMBBLModal", false);
                helper.processMethodError(component, helper, response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    openLoan: function(component, helper){
        component.set("v.showModalSpinner", true);
        console.log(Date.parse('2021/06/14'));
        component.set("v.loanTypes", [
            { label: 'Term Loan', value: "1" },
            { label: 'CPF', value: "2" },
            { label: 'MBBL', value: "3 "},
            { label: 'CAF', value: "4" },
            { label: 'Overdraft', value: "5" }])
        component.set("v.showLoanInputModal", true);
        var action = component.get("c.getEmptyLoanData");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var returnedData = response.getReturnValue();
                returnedData.loanType = returnedData.loanType.toString();
                component.set("v.mbblLoanInputData", returnedData);
                console.log(returnedData);
                component.set("v.showModalSpinner", false);
            }
            else{
                component.set("v.showModalSpinner", false);
                component.set("v.showLoanInputModal", false);
                helper.processMethodError(component, helper, response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    editFin: function(component, event){
        var selectedIndex = event.getSource().get('v.name');
        component.set("v.ttcOptions", [
            { label: '1 to 4', value: '1 to 4' },
            { label: '5 to 9', value: '5 to 9' },
            { label: '10 to 13', value: '10 to 13' },
            { label: '14 to 16', value: '14 to 16' },
            { label: '17 to 21', value: '17 to 21' },]);
        component.set("v.mbblType", [
            { label: 'Non Specialised', value: '2' },
            { label: 'Specialised', value: '1' }]);
        component.set("v.propertyRatingType", [
              { label: "Below Average", value: "1" },
              { label: "Average", value: "2" },
              { label: "Above Average", value: "3" }]);
        var editData = component.get("v.allStoredMbblData")[selectedIndex];
        editData.debtCapacityInitialDTO.mbblType = editData.debtCapacityInitialDTO.mbblType.toString();
        //Null Safe
        if (editData.propertyRatings) {
          editData.propertyRatings = editData.propertyRatings.toString();
        }
        var dateStr = editData.debtCapacityInitialDTO.statementDate;
        var dateParts = dateStr.split("-");
        //YYYY/MM/DD
        var mm = dateParts[1];
        var dd = dateParts[0];
        var yyyy = dateParts[2];
        component.set("v.customDate", yyyy + '-' + mm + '-' + dd);
        component.set("v.mbblInputData", editData);
        component.set("v.showMBBLModal", true);
        component.set("v.isDataEdit", true);
        component.set("v.dataEditIndex", selectedIndex);
    },

    deleteFin: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var selectedIndex = event.getSource().get('v.name');
        console.log(component.get("v.allStoredMbblData"));
        if (confirm('Are you sure you want to delete this year\'s records?') == true) {
            component.set("v.showBodySpinner", true);
            var mbblDataList = component.get("v.allStoredMbblData");
            mbblDataList.splice(selectedIndex,1);
            component.set("v.allStoredMbblData", mbblDataList);
            console.log(component.get("v.allStoredMbblData"));
            var action = component.get("c.editExistData");
            action.setParams({
                data : JSON.stringify(mbblDataList),
                opportunityId : recordId
            });
            action.setCallback(this, function (response) {
                component.set("v.showMBBLModal", false);
                var state = response.getState();
                if(state === 'SUCCESS') {
                    component.set("v.isDataEdit", false);
                    component.set("v.dataEditIndex", null);
                    component.set("v.mbblInputData", null);
                    helper.throwVisualSuccess(component, "Financial Data Deleted Successfully.", true);
                    helper.getTableData(component, helper);
                }
                else{
                    component.set("v.isDataEdit", false);
                    component.set("v.dataEditIndex", null);
                    component.set("v.mbblInputData", null);
                    helper.processMethodError(component, helper, response.getError());
                }
            });
            $A.enqueueAction(action);
        }
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

    throwVisualSuccess : function(component, message, state) {
        component.find('notifLib').showToast({
            "title": "Success!",
            "message": message,
            "variant": (state) ? "success" : "error"
        });
    },
})