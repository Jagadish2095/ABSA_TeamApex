({
    doInit: function(component, event, helper) {
        helper.getCaseData(component,helper,event);
        helper.fetchPickListVal(component, 'Occupation_Category__pc');

    },
    handleSaveRecord: function(component) {
        console.log("save");
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                    JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    refreshView: function(cmp) {
        cmp.find('recordEditor').reloadRecord(true);
    }
});