({
    handleDoInit: function (component) {
        component.set("v.showLoading", true);
        //fetch person account record type to be inserted
        var recordTypeId;
        var recordId = component.get('v.recordId');
        var action = component.get("c.getSpouseAccount");

        action.setParams({
            "oppId": recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.spouseAccount", data);

                if (data) {
                    if (data.isSpouseContributing) {
                        component.set('v.isSpouseContributing', 'Yes');
                        component.set('v.showRemainFields', true);
                    } else {
                        component.set('v.isSpouseContributing', 'No');
                    }

                    if (data.isUnderDebtCounselling) {
                        component.set('v.isUnderDebtCounselling', 'Yes');
                    } else {
                        component.set('v.isUnderDebtCounselling', 'No');
                    }

                    if (data.firstName) {
                        if (data.firstName != '') {
                            component.set('v.enableRemove', true);
                        }
                    }
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Spouse: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Spouse: unknown error", "error");
                }
            }

            component.set("v.showLoading", false);
        });

        $A.enqueueAction(action);

        var options = [
            { label: "Yes", value: "Yes" },
            { label: "No", value: "No" }
        ];

        component.set("v.options", options);
    },

    handleSubmitSpouseAccount: function (component) {
        component.set("v.showLoading", true);
        var spouseAccount = component.get("v.spouseAccount");
        var action = component.get("c.saveSpouseAccount");
        var oppId = component.get('v.recordId');

        action.setParams({
            "accountDetails": JSON.stringify(spouseAccount),
            "oppId": oppId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();

                if (data) {
                    if (data.firstName) {
                        if (data.firstName != '') {
                            component.set('v.enableRemove', true);
                            this.showToast("Success!", "Spouse record linked successfully ", "success");
                            var oppId = component.get("v.recordId");
                            var eventHandler = $A.get("e.c:creditOriginationEvent");
                            eventHandler.setParams({ "sourceComponent": "SolePropSpouseDetail" });
                            eventHandler.setParams({ "opportunityId": oppId });
                            eventHandler.fire();
                        } else {
                            this.showToast("Error!", "Spouse record not linked", "error");
                        }
                    } else {
                        this.showToast("Error!", "Spouse record not linked", "error");
                    }
                } else {
                    this.showToast("Error!", "Spouse record not linked", "error");
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Spouse: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Spouse: unknown error", "error");
                }
            }

            component.set("v.showLoading", false);
        });

        $A.enqueueAction(action);
    },

    handleDelinkSpouseAccount: function (component) {
        component.set("v.showLoading", true);
        var spouseAccount = component.get("v.spouseAccount");
        var action = component.get("c.delinkSpouseAccount");
        var oppId = component.get('v.recordId');

        action.setParams({
            "accountDetails": JSON.stringify(spouseAccount),
            "oppId": oppId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();

                if (data) {
                    if (!data.firstName) {
                        component.set("v.spouseAccount", data);

                        if (data.firstName == '') {
                            component.set('v.enableRemove', false);
                            this.showToast("Success!", "Spouse record delinked successfully ", "success");
                            var oppId = component.get("v.recordId");
                            var eventHandler = $A.get("e.c:creditOriginationEvent");
                            eventHandler.setParams({ "sourceComponent": "SolePropSpouseDetail" });
                            eventHandler.setParams({ "opportunityId": oppId });
                            eventHandler.fire();
                        } else {
                            this.showToast("Error!", "Spouse record not delinked", "error");
                        }
                    } else {
                        this.showToast("Error!", "Spouse record not delinked", "error");
                    }
                } else {
                    this.showToast("Error!", "Spouse record not delinked", "error");
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Spouse: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Spouse: unknown error", "error");
                }
            }

            component.set("v.showLoading", false);
        });

        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})