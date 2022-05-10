({
    assignContactInformation: function (component, event, helper) {
        helper.helperAssignCIFValues(component, event);
    },
    getInformation: function (component, event, helper) {
        helper.helperGetInformation(component, event);
        var cpbResidentialInformation = component.find('ccResidentialInformationFromCPB');
        cpbResidentialInformation.collectSavedResidentialInfo();
        /* alert(JSON.stringify(component.get('v.creditValidatedResidentialInformation'))); */
        var residentialInfFromCPB = new Map();
        residentialInfFromCPB['cpbResidentialInformation'] = component.get('v.creditValidatedResidentialInformation');
        component.set('v.validatedResidentialInformation', residentialInfFromCPB);
    },
    clickedYes: function(component, event, helper){
        var residentialInformation = component.find('ccResidentialInformationFromCPB');
        residentialInformation.collectResidentialInformationFromCPB(); 
    },
    clickedNo: function(component, event, helper){
        var residentialInformation = component.find('ccResidentialInformationFromCPB');
        residentialInformation.collectModifiedResidentialInformation(); 
    }  
})