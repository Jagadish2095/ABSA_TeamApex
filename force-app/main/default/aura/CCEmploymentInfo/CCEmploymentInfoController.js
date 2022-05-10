({
	init : function(component, event, helper) {
		
	},
	occupationStatusChange: function(component, event, helper) {
        var occupationStatus = component.get('v.occupationStatus');
        switch (occupationStatus) {
            case 'Housewife':
            case 'Student':
            case 'Unemployed':
            case 'Pensioner':
            case 'Pre-School/Scholar':
                component.set('v.disabled', true);
                component.set('v.occupationLevel', '');
                component.set('v.occupationCategory', '');
                component.set('v.employerSector', '');
                component.set('v.employerName', '');
                component.set('v.employerPhone', '');

                break;
            default:
                component.set('v.disabled', false);
                break;
        }
    },

	employmentRecordLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var occupationStatus = '';
        if (payload.record.fields["Occupation_Status__pc"] != null) 
        {
            occupationStatus =payload.record.fields['Occupation_Status__pc'].value;
        }
       
        var occupationLevel = '';
        if (payload.record.fields["Occupation_Level__pc"] != null){
            occupationLevel = payload.record.fields['Occupation_Level__pc'].value;
        }
       
        var occupationCategory = '';
        if (payload.record.fields["Occupation_Category__pc"] != null){
            occupationCategory =payload.record.fields['Occupation_Category__pc'].value;
        }
        var hasQualification ='';
        if (payload.record.fields["Has_Post_Matric_Qualification__pc"] != null){
            hasQualification =  payload.record.fields['Has_Post_Matric_Qualification__pc'].value;
        }
        var qualification ='';
        if (payload.record.fields["Post_Matric_Qualification__pc"] != null){
            qualification = payload.record.fields['Post_Matric_Qualification__pc'].value;
        }

        var employerSector = '';
        if (payload.record.fields["Employer_Sector__pc"] != null){
            employerSector =  payload.record.fields['Employer_Sector__pc'].value;
        }
        var employerName = '';
        if (payload.record.fields["Employer_Name__pc"] != null){
            employerName = payload.record.fields['Employer_Name__pc'].value;
        }
        var employerPhone = '';
        if (payload.record.fields["Employer_Phone__c"] != null){
            employerPhone =  payload.record.fields['Employer_Phone__c'].value;}

		var incomeTaxNumber = '';
        if (payload.record.fields["Income_Tax_Number__pc"] != null){
            incomeTaxNumber=  payload.record.fields['Income_Tax_Number__pc'].value;
        }
        var incomeTaxReason = '';
        if (payload.record.fields["Income_Tax_Number_Reason__pc"] != null){
            incomeTaxReason =  payload.record.fields['Income_Tax_Number_Reason__pc'].value;
        }
        var incomeTaxValue = '';
        if (payload.record.fields["Is_customer_registered_for_income_tax__c"] != null){
            incomeTaxValue =  payload.record.fields['Is_customer_registered_for_income_tax__c'].value;
        }
        var foreignTaxValue = '';
        if (payload.record.fields["Is_customer_registered_for_foreign_tax__c"] != null){
            foreignTaxValue=   payload.record.fields['Is_customer_registered_for_foreign_tax__c'].value;
        }
        component.set('v.occupationStatus', occupationStatus);
        component.set('v.occupationLevel', occupationLevel);
        component.set('v.occupationCategory', occupationCategory);
        if (hasQualification != null) {
            component.set('v.hasQualification', helper.getTaxUiValue(hasQualification));
        }
        component.set('v.qualification', qualification);
        component.set('v.employerSector', employerSector);
        component.set('v.employerName', employerName);
        component.set('v.employerPhone', employerPhone);
        if (incomeTaxNumber != null && incomeTaxNumber != '0') {
            component.set('v.incomeTaxNumber', incomeTaxNumber);
        }
        component.set('v.incomeTaxReason', incomeTaxReason);
        component.set('v.incomeTaxValue', helper.getTaxUiValue(incomeTaxValue));
        component.set('v.foreignTaxValue', helper.getTaxUiValue(foreignTaxValue));
        component.set('v.recordLoaded', true);
        if (component.get('v.addressLoaded')) {
            component.set('v.updating', false);
        }
    }
})