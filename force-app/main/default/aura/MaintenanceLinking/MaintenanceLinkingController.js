({
    init : function(cmp, event, helper) {
        /*  cmp.set('v.validate', function() 
                {
                    cmp.find("MaintenanceLinking").submit();
                })*/
        
        cmp.set('v.columns',[
            {label: 'Package Name', fieldName: 'packageName', type: 'text',wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Scheme Code', fieldName: 'schemeCode', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Cheque Acc NO', fieldName: 'accountNumber', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
            ,{label: 'Credit Card NO', fieldName: 'creditAccountNumber', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'}
        ]);
        
        helper.fetchDataAccounts(cmp, event, helper);
        helper.fetchGoldProducts(cmp, event, helper); 
        helper.fetchPremiumProducts(cmp, event, helper); 
        
    },
    onCheckboxChange : function(component, event, helper) {
        //Gets the checkbox group based on the checkbox id
        var availableCheckboxes = component.find('rowSelectionCheckboxId');
        var resetCheckboxValue  = false;
        if (Array.isArray(availableCheckboxes)) {
            //If more than one checkbox available then individually resets each checkbox
            availableCheckboxes.forEach(function(checkbox) {
                checkbox.set('v.value', resetCheckboxValue);
            }); 
        } else {
            //if only one checkbox available then it will be unchecked
            availableCheckboxes.set('v.value', resetCheckboxValue);
        }
        //mark the current checkbox selection as checked
        event.getSource().set("v.value",true);
    },
    
    handleSelect1 : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            //alert(selectedRows[i].packageName);
            setRows.push(selectedRows[i]);
            //setting the selected row values
            var packageName = selectedRows[i].packageName;
            var packageName1 = packageName.split(' ')[0];
            var pricingCode = selectedRows[i].schemeCode;
            var creditCardNumber = selectedRows[i].creditAccountNumber;
            var chequeAccount = selectedRows[i].accountNumber;            
            component.set('v.CanNavigate', true);
            component.set('v.packageName', packageName1);
            component.set('v.pricingCode', pricingCode);
            component.set('v.creditCardNumber', creditCardNumber);
            component.set('v.chequeAccount', chequeAccount);

            var selectedValue = selectedRows[i].packageName;
            if (selectedValue == "GOLD PACKAGE"){
                component.set("v.displayedSection","sectionGold");
                var section1InputValue = component.find("goldvalue");
                var section2InputValue = component.find("premiumvalue");
            } else {
                component.set("v.displayedSection","sectionPremium");
                var section1InputValue = component.find("goldvalue");
                var section2InputValue = component.find("premiumvalue");
            }
            
        }
        
        
    },
    
    showSelectedName : function(component, event, helper) {
        
        var records = component.get("v.selectedAccts");
        for ( var i = 0; i < records.length; i++ ) {
            
            alert(records[i].packageName);
            
        }
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        
        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                {   
                   var promise = helper.CreateLink(component, event,helper)
                    .then(
                        $A.getCallback(function(result) {
                            navigate(actionClicked);  
                            //alert(component.get("v.opportunityId"));
                        }),
                        $A.getCallback(function(error) {   
                            component.set('v.CanNavigate',true);
                            component.find('branchFlowFooter').set('v.heading', 'Something went wrong');                            
                            component.find('branchFlowFooter').set('v.message', error.errorMessage);                            
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        })
                    )  
                    break;   
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    navigate(event.getParam("action"));
                    break;
                }
        }
        
    }
    
})