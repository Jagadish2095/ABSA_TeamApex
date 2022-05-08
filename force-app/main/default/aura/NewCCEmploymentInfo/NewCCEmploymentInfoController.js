({
    //Last modified 2021/05/28
    init: function(component, event, helper)
    {
		helper.fetchTranslationValues(component, 'v.occupationStatusOptions', 'CIFCodesList', 'Emplstatus', 'Outbound', 'Account', 'Occupation_Status__pc');
        helper.fetchTranslationValues(component, 'v.occupationLevelOptions', 'CIFCodesList', 'Occulvl', 'Outbound', 'Account', 'Occupation_Level__pc');
        helper.fetchTranslationValues(component, 'v.occupationCategoryOptions', 'CIFCodesList', 'Occucode', 'Outbound', 'Account', 'Occupation_Category__pc');
        helper.fetchTranslationValues(component, 'v.qualificationOptions', 'CIFCodesList', 'Postmatq', 'Outbound', 'Account', 'Post_Matric_Qualification__pc');
        helper.fetchTranslationValues(component, 'v.employerSectorOptions', 'CIFCodesList', 'Emplsector', 'Outbound', 'Account', 'Employer_Sector__pc');
        helper.fetchTranslationValues(component, 'v.incomeTaxReasonOptions', 'CIFCodesList', 'ReasonSATaxNotGiven', 'Outbound', 'Account', 'Income_Tax_Number_Reason__pc');
        component.set('v.hasQualificationOptions', helper.getHasQalificationOptions());
        component.set('v.incomeTaxOptions', helper.getIncomeTaxOptions());
        component.set('v.foreignTaxOptions', helper.getForeignTaxOptions());
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

                var addressComponent = component.find("branchAddress");
                addressComponent.set('v.addressStreet', '');
                addressComponent.set('v.addressSuburb', '');
                addressComponent.set('v.addressProvince', '');
                addressComponent.set('v.addressCity', '');
                addressComponent.set('v.addressPostalCode', '');
                addressComponent.set('v.addressCountry', '');
                break;
            default:
                component.set('v.disabled', false);
                break;
        }
    },

    handleIncomeTaxGroup: function(component, event, helper) {
        var incomeTaxValue = event.getSource().get('v.value');
        component.set('v.incomeTaxValue', incomeTaxValue);
    },

    handleForeignTaxGroup: function(component, event, helper) {
        var foreignTaxValue = event.getSource().get('v.value');
        component.set('v.foreignTaxValue', foreignTaxValue);
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
    },

    employmentRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var occupationStatus = component.get('v.occupationStatus');
        var occupationLevel = component.get('v.occupationLevel');
        var occupationCategory = component.get('v.occupationCategory');
        var hasQualification = component.get('v.hasQualification');
        var qualification = '';
        if (hasQualification == 'Yes') {
            qualification = component.get('v.qualification');
        }
        var employerSector = component.get('v.employerSector');
        var employerName = component.get('v.employerName');
        var employerPhone = component.get('v.employerPhone');
        var incomeTaxNumber = component.get('v.incomeTaxNumber');
        var incomeTaxReason = component.get('v.incomeTaxReason');
        var incomeTaxValue = component.find('IncomeTaxRadioGroup').get('v.value');
        var foreignTaxValue = component.find('ForeignTaxRadioGroup').get('v.value');
		eventFields['Occupation_Status__pc'] = occupationStatus;
        eventFields['Occupation_Level__pc'] = occupationLevel;
        eventFields['Occupation_Category__pc'] = occupationCategory;
        eventFields['Has_Post_Matric_Qualification__pc'] = helper.getTaxFieldValue(hasQualification);
        eventFields['Post_Matric_Qualification__pc'] = qualification;
        eventFields['Employer_Sector__pc'] = employerSector;
        eventFields['Employer_Name__pc'] = employerName;
        eventFields['Employer_Phone__c'] = employerPhone;
        eventFields['Income_Tax_Number__pc'] = incomeTaxNumber;
        eventFields['Income_Tax_Number_Reason__pc'] = incomeTaxReason;
        eventFields['Is_customer_registered_for_income_tax__c'] = helper.getTaxFieldValue(incomeTaxValue);
        eventFields['Is_customer_registered_for_foreign_tax__c'] = helper.getTaxFieldValue(foreignTaxValue);
        component.find('EmploymentDetail').submit(eventFields);
    },

    employmentRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
		component.set('v.updating', false);
    },

    employmentRecordSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');
        component.set('v.updating', false);
        navigate(actionClicked);
    },

    handleRecordEvent : function(component, event, helper) {
        var globalId = component.getGlobalId();
        var eventName = event.getParam("eventName");
        switch (eventName) {
            case 'RecordLoaded':
                component.set('v.addressLoaded', true);
                if (component.get('v.recordLoaded')) {
                    component.set('v.updating', false);
                }
                break;
            case 'RecordError':
                component.find('branchFlowFooter').set('v.heading', event.getParam("errorMessage"));
                component.find('branchFlowFooter').set('v.message', JSON.stringify(event.getParam("eventDetails")));
                component.find('branchFlowFooter').set('v.showDialog', true);
                component.set('v.updating', false);
                break;
            case 'RecordSuccess':
                document.getElementById(globalId + '_employment_submit').click();
                break;
        }
    },

    handleNavigate: function(component, event, helper) {
        var globalId = component.getGlobalId();
        var addressComponent = component.find('branchAddress');
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);

        switch(actionClicked)
        {
            case 'NEXT':
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    helper.handleRemoveValidation(component);
                    var promise = helper.executeValidate(component, helper)
                    .then(
                        $A.getCallback(function(result) {
                            component.set('v.recordLoaded', false);
                            var occupationStatus = component.get('v.occupationStatus');
                            switch (occupationStatus) {
                                case 'Housewife':
                                case 'Student':
                                case 'Unemployed':
                                case 'Pensioner':
                                case 'Pre-School/Scholar':
                                    document.getElementById(globalId + '_employment_submit').click();
                                    break;
                                default:
                                    addressComponent.SubmitAddress();
                                    break;
                            }
                        }),
                        $A.getCallback(function(error) {
                            helper.handleAddValidation(component);
                            component.set('v.updating', false);
                        })
                    )
                } else {
                    component.set('v.updating', false);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    addressComponent.SubmitAddress();
                } else {
                    component.set('v.updating', false);
                    var ignoreValidity = confirm('Validation failed! Continue without saving?');
                    if (ignoreValidity) {
                        navigate(actionClicked);
                    }
                }
                break;
        }
    }
})