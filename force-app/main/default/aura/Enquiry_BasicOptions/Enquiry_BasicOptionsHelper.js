({
    getComponentDataAttributes: function () {
        return [
            'belowDetails',
            'dateFrom',
            'dateTo',
        ];
    },

    checkValidityAdditional: function (component, attributes) {
        let dateFromValue = component.get("v.dateFrom");
        let dateToValue = component.get("v.dateTo");
        let dateFromField = component.find('dateFrom');
        let dateToField = component.find('dateTo');

        if (!$A.util.isEmpty(dateFromValue) && !$A.util.isEmpty(dateToValue)) {
            //check if datefrom less or equal to dateto
            let lessOrEqualCheckStatus = new Date(dateFromValue) <= new Date(dateToValue);
            //check if the difference between the dates is less than limit(4 months)
            let limitCheckStatus = 4 >= this.monthDiff(new Date(dateFromValue), new Date(dateToValue));
            //check if dateto less than today date
            let startDateCheckStatus = new Date().setHours(0,0,0,0) > new Date(dateToValue).setHours(0,0,0,0);

            if (lessOrEqualCheckStatus && limitCheckStatus && startDateCheckStatus) {
                dateFromField.setCustomValidity("");
                dateToField.setCustomValidity("");
            } else if (!lessOrEqualCheckStatus && limitCheckStatus) {
                dateFromField.setCustomValidity($A.get("$Label.c.Enquiry_Date_From_must_be_less_than_or_equal_to_Date_To"));
                dateToField.setCustomValidity($A.get("$Label.c.Enquiry_Date_To_must_be_greater_than_or_equal_to_Date_From"));
            } else if (!limitCheckStatus && lessOrEqualCheckStatus) {
                dateFromField.setCustomValidity($A.get("$Label.c.Enquiry_The_difference_between_Date_From_and_Date_To_can_not_be_more_than_4"));
                dateToField.setCustomValidity($A.get("$Label.c.Enquiry_The_difference_between_Date_From_and_Date_To_can_not_be_more_than_4"));
            } else if (limitCheckStatus && lessOrEqualCheckStatus && !startDateCheckStatus) {
                dateFromField.setCustomValidity($A.get("$Label.c.Enquiry_Date_From_and_Date_To_must_be_less_than_today_date"));
                dateToField.setCustomValidity($A.get("$Label.c.Enquiry_Date_From_and_Date_To_must_be_less_than_today_date"));
            }

            dateFromField.reportValidity();
            dateToField.reportValidity();

            return lessOrEqualCheckStatus && limitCheckStatus;
        }

        return true;
    },

    setBelowDetailsLabels: function (component) {
        let customLabels = [
            { label: $A.get("$Label.c.Enquiry_Detail"), value: "detail" },
            { label: $A.get("$Label.c.Enquiry_Summary"), value: "summary" }
        ];

        component.set('v.belowDetailsOptions', customLabels);
    },
})