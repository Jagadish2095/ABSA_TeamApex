({
    /****************@ Author: Chandra**********************************
     ****************@ Date: 03/12/2020*********************************
     ****************@ Work Id: W-********************************
     ***@ Description: Method Added by chandra to handle init function*/
    doInit: function (component, event, helper) {
        var noOfMonthOptions = [];
        for (var i = 1; i <= 30; i++) {
            noOfMonthOptions.push({
                label: i,
                value: i,
                selected: i == 1 ? true : false
            });
        }
        component.set("v.noOfMonthOptions", noOfMonthOptions);
    },

    /****************@ Author: Chandra****************************************************
     ****************@ Date: 03/12/2020***************************************************
     ****************@ Work Id: W-**************************************************
     ***@ Description: Method Added by chandra to handle sendOnDemandStatement function**/
    sendOnDemandStatement: function (component, event, helper) {
        if (helper.allFieldsValid(component)) {
            helper.getStatementOnDemandHelper(component, event, helper);
        } else {
            component.set("v.errorMessage", "Please populate all required fields");
        }
    },

    /****************@ Author: Chandra**********************************
     ****************@ Date: 03/12/2020*********************************
     ****************@ Work Id: W-********************************
     ***@ Description: Method Added by chandra to close the case*******/
    caseClose: function (component, event, helper) {
        helper.caseCloseHelper(component, event, helper);
    }
});