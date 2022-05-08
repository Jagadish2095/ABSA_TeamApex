({
    createObjectData: function(component, event) {
        
        var RowItemList = component.get("v.caseList");
        
        RowItemList.push({
            'sobjectType': 'Case',
            'Subject': '',
            'Description': '',
            'Service_Group_Search__c': ''
        });
        
        component.set("v.caseList", RowItemList);
    }, 
    validateRequired: function(component, event) {
        var isValid = true;
        var allCaseRows = component.get("v.caseList");
        for (var indexVar = 0; indexVar < allCaseRows.length; indexVar++) {
            if (allCaseRows[indexVar].Subject == '') {
                isValid = false;
                alert('Subject Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    },
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Function to show toast for Errors/Warning/Success
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
})