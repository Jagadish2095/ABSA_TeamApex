({
  //Calculate on init for general
  newProcessDR: function (component, event, helper) {
    try {
      var oppId = component.get("v.oppId");
      console.log('opp: '+oppId);
      component.set("v.showSpinner", true);
      var allData = component.get("v.allStoredGeneralData");
      var loanData = component.get("v.loanData");
      var action = component.get("c.generalCalculate");
      action.setParams({
        opportunityId: oppId,
        currentData: JSON.stringify(allData),
        loanData: JSON.stringify(loanData)
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        console.log(state);
        if (state === "SUCCESS") {
          console.log(response.getReturnValue());
          var returnedData = response.getReturnValue();
          var errors = "";
          if (returnedData.success == false) {
            errors = returnedData.message.join();
            console.log(errors);
            var parentComponent = component.get("v.parent");
            parentComponent.parentMethod(false);
            helper.throwVisualToast(component, errors, false);
          } else {
            console.log(returnedData.data);
            var allRowsData = [];
            var allLoansRowsData = [];
            var allKRData = [];
            for (var key in returnedData.data.normalResultTable) {
              allRowsData.push({
                header: key,
                values: returnedData.data.normalResultTable[key],
                isDarkHeader: key == "New Interest Bearing Debt" ? true : false,
                isHeader:
                  key == "Income Statement" ||
                  key == "Present Key Ratios" ||
                  key == "Cash Flow Statement" ||
                  key == "Balance Sheet"
                    ? true
                    : false
              });
            }
            for (var key in returnedData.data.loanResultTable) {
              allLoansRowsData.push({
                header: key,
                values: returnedData.data.loanResultTable[key],
                isDarkHeader:
                  key == "New Interest Bearing Debt (Current Year)"
                    ? true
                    : false,
                isHeader:
                  key == "Loan" ||
                  key == "Overdraft Facility" ||
                  key == "Total New"
                    ? true
                    : false
              });
            }
            for (var key in returnedData.data.expectedKRTable) {
              //check number or string
              var customValues = [];
              returnedData.data.expectedKRTable[key].forEach(function (item) {
                if (!isNaN(item)) {
                  customValues.push({
                    value: item,
                    isNumber: true
                  });
                } else {
                  customValues.push({
                    value: item,
                    isNumber: false
                  });
                }
              });

              allKRData.push({
                header: key,
                values: customValues,
                isHeader:
                  key == "Expected Key Ratios (after adding new IBD)"
                    ? true
                    : false
              });
            }
            helper.throwVisualSuccess(component, "Action Successful.", true);
            component.set("v.mbblResultsTableData", allRowsData);
            component.set("v.mbblLoansResultsTableData", allLoansRowsData);
            component.set("v.mbblEKRResultsTableData", allKRData);
            component.set("v.resultsAvailable", true);
            component.set("v.calcSuccess", true);
            console.log(allRowsData);
            console.log(allLoansRowsData);
          }
          component.set("v.showSpinner", false);
        } else {
          component.set("v.showSpinner", false);
          helper.processMethodError(component, helper, response.getError());
          var parentComponent = component.get("v.parent");
          parentComponent.parentMethod(false);
        }
      });
      $A.enqueueAction(action);
    } catch (e) {
      component.set("v.showSpinner", false);
      console.log(e);
    }
  },

  //Toast Helper
  throwVisualToast: function (component, message, state) {
    component.find("notifLib").showToast({
      title: "We Hit A Snag!",
      message: message,
      variant: state ? "success" : "error"
    });
  },

  //Toast Helper
  throwVisualSuccess: function (component, message, state) {
    component.find("notifLib").showToast({
      title: "Success!",
      message: message,
      variant: state ? "success" : "error"
    });
  },

  processMethodError: function (component, helper, errors) {
    var message = "Unknown error";
    if (errors && Array.isArray(errors) && errors.length > 0) {
      message = errors[0].message;
    }
    helper.throwVisualToast(component, message, false);
  }
});