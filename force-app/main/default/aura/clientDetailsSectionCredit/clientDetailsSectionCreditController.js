({
    doInit: function (component, event, helper) {
        helper.initializeOptions(component);
        var updateEvent = $A.get("e.c:clientDetailsSectionCreditEvent");

        Promise.all([helper.getClientDetails(component, event, helper)]).then(function (results) {
            var p1Results = results[0];
            if (p1Results != null) {
                component.set("v.data", p1Results);

                if (p1Results.ClientType.toLowerCase() == "sole trader") {
                    component.set("v.isSAResident", (p1Results.IDType != 'SA Identity Document' ? true : false));
                    component.set("v.isSoleProprietorVisible", true);
                }
                else {
                    component.set("v.isPrivateCompanyVisible", true);
                }

                if (p1Results.ResidentialStatusAddressOptions != null) {
                    var optionList = p1Results.ResidentialStatusAddressOptions;
                    var valueAva = (p1Results.ResidentialStatusAddress != null ? true : false);
                    var addOptions = [{ class: "optionClass", label: "Select an Option", value: "Select an Option", selected: (!valueAva ? true : false) }];

                    for (var i = 0; i < optionList.length; i++) {
                        var selValue = (optionList[i].Address == p1Results.ResidentialStatusAddress ? true : false);
                        addOptions.push({ class: "optionClass", label: optionList[i].Address, value: optionList[i].Address, selected: (selValue ? true : false) });
                    }
                    //addOptions.push({class: "optionClass", label: "New Address", value: "New Address"})
                    component.set("v.addOptions", addOptions);
                }
                updateEvent.setParams({ "account": p1Results });
                updateEvent.fire();
            }
        }).catch(function (err) {
            var toastEvent = helper.getToast("Error clientDetailsSectionCredit!", err, "Error");
            toastEvent.fire();
        });
    },

    saveHandler: function (component, event, helper) {
        helper.saveHandler(component, event, helper);
    },

    clickCheckBox: function (component, event, helper) {
        helper.saveHandler(component, event, helper);
    }
})