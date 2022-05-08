({
    getDataFromApex: function (component, helper, apexMethod, methodParams, attribute, successCallBack, errorCallBack) {
        let action = component.get(apexMethod);

        if (methodParams) {
            action.setParams(methodParams);
        }

        action.setCallback(this, function (response) {
            let state = response.getState();
            let toastEvent = $A.get("e.force:showToast");

            if (state === "SUCCESS") {
                let data = response.getReturnValue();

                if ($A.util.isEmpty(data)) {
                    toastEvent.setParams({
                        "title": "Error",
                        "message": apexMethod + ' return empty',
                        "mode": "sticky",
                        "type": "error",
                    });
                    toastEvent.fire();
                    return;
                }

                if (attribute) {
                    component.set(attribute, data);
                }

                if (successCallBack) {
                    successCallBack(component, helper, data);
                }

                return data;
            } else if (state === "ERROR") {
                if (errorCallBack) {
                    errorCallBack(component, helper);
                }

                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    showGeneralMessage: function (title, message, type, options) {
        var actualOptions = options || {};
        actualOptions.title = title;
        actualOptions.message = $A.util.isObject(message) ? message.message : message;
        actualOptions.type = type;

        // default to "sticky" if not re-defined in incoming options
        actualOptions.mode = actualOptions.mode || "sticky";

        this.showToastMessage(actualOptions);
    },

    showToastMessage: function (options) {
        this.fireAppEvent(
            "force:showToast",
            options
        );
    },

    fireAppEvent: function (toastType, options) {
        let toastEvent = $A.get('e.' + toastType);
        toastEvent.setParams(options);

        toastEvent.fire();
    },

    monthDiff: function (d1, d2) {
        let months;
        months = (d2.getFullYear() - d1.getFullYear()) * 12;
        months -= d1.getMonth();
        months += d2.getMonth();

        return months <= 0 ? 0 : months;
    }
})