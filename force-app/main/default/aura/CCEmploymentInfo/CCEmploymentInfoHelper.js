({
	checkValidity: function(component, helper) {
        var returnValue = 'pass';
        if (!component.find('OccupationStatus').get('v.validity').valid) {
            component.find('OccupationStatus').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        var occupationStatus = component.get('v.occupationStatus');
        switch (occupationStatus) {
            case 'Housewife':
            case 'Student':
            case 'Unemployed':
            case 'Pensioner':
            case 'Pre-School/Scholar':
                break;
            default:
                if (!component.find('OccupationLevel').get('v.validity').valid) {
                    component.find('OccupationLevel').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('OccupationCategory').get('v.validity').valid) {
                    component.find('OccupationCategory').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('Industry').get('v.validity').valid) {
                    component.find('Industry').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('EmployerName').get('v.validity').valid) {
                    component.find('EmployerName').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('EmployerPhone').get('v.validity').valid) {
                    component.find('EmployerPhone').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (component.find('branchAddress').validate() != 'pass') {
                    returnValue = 'fail';
                }
                break;
        }

        if (!component.find('HasPostMatricQualificationRadioGroup').get('v.validity').valid) {
            component.find('HasPostMatricQualificationRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        var hasQualification = component.get('v.hasQualification');
        if (hasQualification == 'Yes') {
            if (!component.find('PostMatricQualification').get('v.validity').valid) {
                component.find('PostMatricQualification').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
        }

        if (!component.find('IncomeTaxRadioGroup').get('v.validity').valid) {
            component.find('IncomeTaxRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ForeignTaxRadioGroup').get('v.validity').valid) {
            component.find('ForeignTaxRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        return returnValue;
    }
})