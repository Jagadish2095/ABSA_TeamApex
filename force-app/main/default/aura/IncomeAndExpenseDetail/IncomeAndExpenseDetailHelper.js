({
    loadData: function (component, event) {

        //component.set("v.showSpinner", false);
        var action = component.get("c.getApplicationExpense");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('response income' + results);

                //set attribute values from results

                component.set("v.monthlyRecordListIds", results.monthlyRecordList);
                component.set("v.fixedRecordListIds", results.fixedRecordList);
                component.set("v.externalRecordListIds", results.externalRecordList);
                component.set("v.liveExpRecordListIds", results.liveExpRecordList);
                component.set("v.recordAppId", results.applicationId);
                component.set("v.creditTurnOver", results.creditTurnOver);
                component.set("v.IDNumber", results.IDNumber);
                component.set("v.clientCode", results.clientCode);
                var isreloadVal = component.get("v.isreload");
                if (results.grossIncome) {
                    component.set("v.grossIncome", results.grossIncome);
                    component.set("v.netIncome", results.netIncome);

                    component.set("v.grossMonthlyIncome", results.grossIncome.Applicant_Value__c);
                    component.set("v.SgrossMonthlyIncome", results.grossIncome.Spouse_Value__c);
                    component.set("v.nethouseIncome", results.netIncome.Total_Monthly_Household_Income__c);
                    component.set("v.netMonthlyIncome", results.netIncome.Applicant_Value__c);
                    component.set("v.SnetMonthlyIncome", results.netIncome.Spouse_Value__c);

                    component.set("v.extSpousetotal", results.extspouseTotal);
                    component.set("v.householdtotal", results.liveExhouseholdTotal);
                    component.set("v.businessholdtotal", results.liveExbusinessholdTotal);

                    component.set("v.disposalIncome", results.disposalIncome);
                    console.log('disposal---' + JSON.stringify(results.disposalIncome));
                    //   component.set("v.isreload",true);

                }

                console.log('externalRecordList length--' + results.externalRecordList.length);
                //   $A.get('e.force:refreshView').fire();
            } else {

                var errors = response.getError();
                var errMessage = ((errors && errors[0] && errors[0].message) ? ": " + errors[0].message : "!")
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Unable to load, please check Expsoure and Triad Section" + errMessage,
                    "type": "Error",
                    "duration": 1500
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);

        });
        $A.enqueueAction(action);
    },
    saveAllIncomeExpenses: function (component, event) {

        component.find('monthEdit').forEach(form => {
            form.submit();

        }); //submit monthly income
        //component.find("grossmonthEdit").submit(); //submit total gross record
        //component.find("netmonthEdit").submit();    //submit monthly total income
        component.find("externalEdit").forEach(form => {
            form.submit();
        }); //submit external instalments

        component.find("liveEdit").forEach(form => {
            form.submit();
        }); //submit live instalments

        //load saved
        // this.loadData();

        component.set("v.showDisposal", true);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Income and Expense saved successfully! Please check disposal Income section",
            "type": "success",
            "duration": 1500
        });
        toastEvent.fire();

        component.set("v.isreload", true);
        component.set("v.showSpinner", true);
        $A.get('e.force:refreshView').fire();
    },
})