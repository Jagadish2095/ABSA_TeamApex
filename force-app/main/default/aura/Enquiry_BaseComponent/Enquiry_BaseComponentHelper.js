({
    doBaseInit: function (component, helper) {
        let isFirst = component.get("v.isFirst");
        let isLast = component.get("v.isLast");
        let componentData = this.getBaseEnquiryData(component, helper);

        this.mergeComponentDataWithExistingData(component, componentData);

        if (isLast) {
            component.set("v.nextButtonLabel", $A.get("$Label.c.Enquiry_submit"));
        }

        if (isFirst) {
            component.set("v.previousButtonLabel", $A.get("$Label.c.Enquiry_cancel"));
        }
    },

    checkValidity: function (component, attributes) {
        if (!this.checkValidityAdditional(component, attributes)) {
            return false;
        }

        return attributes.every(attribute => {
            let componentField = component.find(attribute);

            if (componentField === undefined) {
                return true;
            }

            return componentField.get("v.validity").valid;;
        });
    },

    checkValidityAdditional: function (component, attributes) {
        return true;
    },

    updateComponentData: function (component, helper) {
        let attributes = helper.getComponentDataAttributes();
        let isDataValid = helper.checkValidity(component, attributes);
        let componentData = {};

        if (!isDataValid) {
            return;
        }

        let button = component.getSuper().find("nextButton");
        button.set("v.disabled", !isDataValid);

        attributes.forEach(attribute => {
            let fieldData = component.get("v." + attribute);
            componentData[attribute] = fieldData;
        });

        this.mergeComponentDataWithExistingData(component, componentData);
    },

    mergeComponentDataWithExistingData: function (component, componentData) {
        let oldEnquiryDataJSON = component.get("v.enquiryData");

        if (oldEnquiryDataJSON) {
            let oldEnquiryData = oldEnquiryDataJSON ? JSON.parse(component.get("v.enquiryData")) : '';
            componentData = Object.assign({}, oldEnquiryData, componentData);
        }

        component.set("v.enquiryData", JSON.stringify(componentData));
    },

    getBaseEnquiryData: function (component, helper) {
        let accountName = component.get("v.name");
        let firstName = component.get("v.firstName");
        let lastName = component.get("v.lastName");
        let clientType = component.get("v.clientType");
        let enquiryType = component.get("v.enquiryType");
        let clientKey = component.get("v.clientKey");
        let caseId =component.get("v.caseId");
        let customerName = "";

        if (firstName) {
            customerName += firstName + " ";
        }
        if (lastName) {
            customerName += lastName;
        }
        if(customerName) {
            customerName = accountName;
        }
		console.log(clientType);
        return {
            enquiryType: enquiryType,
            CIF: clientKey,
            customerName: customerName,
            accountName: accountName,
            clientType: clientType,
            caseId: caseId
        };
    },

    nextButtonClick: function (component, helper) {
        let navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },

    previousButtonClick: function (component, helper) {
        let isFirst = component.get("v.isFirst");

        if (isFirst) {
            let enquiryData = JSON.parse(component.get("v.enquiryData"));
            helper.getDataFromApex(component, helper, "c.closeCase", {caseId: enquiryData.caseId}, null, null, null);
            helper.closeFocusedTab(component);
        } else {
            let navigate = component.get("v.navigateFlow");
            navigate("BACK");
        }
    },

    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})