({
    doInit: function (component, event, helper) {
        helper.getBusinessTraceData(component);
    },

    onRadioChangeKimNumber: function (component, event, helper) {
        var target = event.getSource();
        var rdPText = target.get("v.text");
        var kimDetail = component.get("v.KIMNumberDetail");
        var kimData = component.get("v.locateCallData");
        var comName = null;

        for (var x = 0; x < kimData.length; x++) {
            var child = kimData[x].ResultSet;
            for (var j = 0; j < child.length; j++) {
                if (rdPText == child[j].KIInternalNumber) {
                    comName = child[j].CompanyName;
                    break;
                }
                else {
                    comName = rdPText;
                }
            }
        }

        if (comName != null) {
            if (kimDetail.length > 0) {
                var exist = false;
                kimDetail.forEach((child) => (exist = (child.Name == comName ? ture : false)));
                if (exist) {
                    kimDetail.forEach((child) => (child.KIMNumberOrNoMatch = (child.Name == comName ? rdPText : child.KIMNumberOrNoMatch)));
                }
                else {
                    kimDetail.push({ "CompanyName": comName, "KIMNumberOrNoMatch": rdPText });
                }
            }
            else {
                kimDetail.push({ "CompanyName": comName, "KIMNumberOrNoMatch": rdPText });
            }
        }
    },

    submit: function (component, event, helper) {
        helper.saveBusinessTraceData(component);
    },

    submitToPco: function (component, event, helper) {
        helper.submitToPowerCurve(component);
    }
})