({
    doInit: function (component, event, helper) {
        helper.getGQIQuestionsAndAnswers(component);
    },

    onCheckedChange: function (component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.value");
        var chName = target.get("v.name");

        helper.eventHandlerChkBox(component, chName, chValue);
    },

    onLimitChange: function (component, event, helper) {
        var target = event.getSource();
        var selValue = target.get("v.value");

        helper.eventHandlerSelOpt(component, selValue, true);
    },

    saveAndValidate: function (component, event, helper) {
        helper.saveGQInformation(component);
    },

    calTotals: function (component, event, helper) {
        var limitOther = component.get("v.limitOther");
        var total = 0, totals = 0;

        for (var i = 0; i < limitOther.length; i++) {
            var borPer = parseFloat(limitOther[i].BorrowingPercentage);
            var rands = parseFloat(limitOther[i].Rands);

            total = ((borPer / 100) * rands);

            limitOther[i].Total = total.toFixed(2);
            totals += total;
            if (i == 4) {
                limitOther[i].Total = totals.toFixed(2);
            }
        }

        component.set("v.limitOther", limitOther);
    }
})