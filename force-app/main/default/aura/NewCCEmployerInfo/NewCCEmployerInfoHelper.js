({
    helperAssignCIFValues: function (component, event) {
        var employerInformation = component.get('v.employerInfo');
        component.set('v.employerInformation', employerInformation);
        this.mappingTheResponseValue(component, event, employerInformation);
		console.log("employerInformation"+JSON.stringify(employerInformation));
    },
    
    mappingTheResponseValue: function (component, event, response) {
        component.set('v.employerName', response.Employer_Name__pc);
        component.set('v.employerContactNumber', response.Employer_Phone__c);
        component.set('v.employerAddrLine1', response.Business_Address_Line_1__c);
        component.set('v.employerSuburb', response.Physical_Address_Suburb__c);
        component.set('v.employerCity', response.Physical_Address_City__c);
        component.set('v.employerPostCode', response.Postal_Code__c);
        
    },
    getInformation: function (component, event) {
        var employerDetails = new Map();
        employerDetails['employerName'] = component.get('v.employerName');
        employerDetails['employerContactNumber'] = component.get('v.employerContactNumber');
        employerDetails['employerAddrLine1'] = component.get('v.employerAddrLine1');
        employerDetails['employerSuburb'] = component.get('v.employerSuburb');
        employerDetails['employerCity'] = component.get('v.employerCity');
        employerDetails['employerPostCode'] = component.get('v.employerPostCode');
        component.set('v.employmentInformation', employerDetails);
    },
    
    helperValidate: function (component, event) {
        var allValid = true;
        var self = this;
        if(component.get('v.isEdit') == false){
            allValid = component.find('inputFld').reduce(function (validSoFar, inputCmp) {
                inputCmp.reportValidity();
                inputCmp.focus();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        } else {
            component.find('inputFld').reduce(function (validSoFar, inputCmp){
                if(inputCmp.get('v.class') == 'required' && (!inputCmp.get('v.value') || inputCmp.get('v.value') === '') ){
                    allValid = false;
                    self.getToast('Required field missing..!', 'Required field(s) missing', 'error' );
                }
            });
        }
        component.set('v.employmentValidity', allValid);
    },
    
    //Function to show toast for Errors/Warning/Success
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }, 
})