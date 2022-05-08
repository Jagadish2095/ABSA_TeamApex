({
    initializePicklist: function (component, event) {
        var limitTypeOptions = [
            { label: "--None--", value: "--None--", selected: "true" },
            { label: "Fixed", value: "Fixed" },
            { label: "Reducing - Once Off Only", value: "Reducing - Once Off Only" },
            { label: "Reducing - Once Off And Recurring", value: "Reducing - Once Off And Recurring" },
            { label: "Reducing - Recurring Only", value: "Reducing - Recurring Only" },
            { label: "Variable", value: "Variable" }

        ];
        component.set('v.LimitTypeOptions', limitTypeOptions);

        var selRedFrequency = [
            { label: "--None--", value: "--None--", selected: "true" },
            { label: "Monthly", value: "Monthly" },
            { label: "Bi-weekly", value: "Bi-weekly" },
            { label: "Quartely", value: "Quartely" },
            { label: "B-Annual", value: "B-Annual" },
            { label: "Annually", value: "Annually" }

        ];
        component.set('v.selRedFrequency', selRedFrequency);

        var minDate = new Date();
        var maxDate = (minDate.getFullYear() + 1) + "-" + (minDate.getMonth() + 1) + "-" + (minDate.getDate() - 1); //add year;
        minDate = minDate.getFullYear() + "-" + (minDate.getMonth() + 1) + "-" + minDate.getDate();

        component.set("v.minDate", minDate);
        component.set("v.maxDate", maxDate);


        //acb 
        var CMSACBOptions = [
            { label: "--Please Select--", value: "--Please Select--", selected: "true" },
            { label: "CMS Limit", value: "CMS Limit" },
            { label: "CMS ACB Limit", value: "CMS ACB Limit" },
            { label: "N/A", value: "N/A" }

        ];

        component.set('v.CMSACBOptions', CMSACBOptions);

    },


    limitTypeChange: function (component, selectCmp) {

        console.log('onLimitSelectChange---' + selectCmp);

        if (selectCmp == "Reducing - Once Off Only") {
            component.set("v.isActiveOnceOffOnly", true);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Reducing - Once Off And Recurring") {
            component.set("v.isActiveOnceOffOnly", true);
            component.set("v.isActiveOnceOffRecurring", true);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Reducing - Recurring Only") {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", true);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Variable") {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", true);

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Variable amounts table.",
                message: "Please make sure to complete the variable amounts and dates in the variable amounts table.",
                type: "info", mode: 'pester'
            });
            toastEvent.fire();
        }
        else {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", false);
        }
    },
})