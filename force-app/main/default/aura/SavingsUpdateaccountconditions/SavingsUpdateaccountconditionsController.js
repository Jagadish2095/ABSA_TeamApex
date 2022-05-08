({
    doInit: function(component, event, helper) {        

       // helper.fetchTranslationValues(component, 'v.investmentTermList', 'Savings', 'Investment Term', 'Outbound');
        helper.fetchTranslationValues(component, 'v.noticePeriodList', 'Savings', 'Notice Period', 'Outbound');
        },
    handleNavigate: function (component, event, helper) {
		const fieldIsMandatoryError = "Please fulfill required fields";
        var withdrawalPercentage = component.get("v.percentageAvailableforWithdraw");  
        if(withdrawalPercentage == undefined)
        {
           component.set("v.errorMessage", "Please capture percentage available for withdrawal.");
           return null;
        }
        if(component.get("v.productCode") == '09501'  && (component.get("v.investTerm") == undefined))
        {
           component.set("v.errorMessage", "Please capture investment term.");
           return null;
        }
        if (!helper.validateRequiredFields(component)) {
            helper.fireToast("Error",fieldIsMandatoryError, "error");
            return;
        }/**/
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
       
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':  
                             
            let Ipromise = helper.callupdateAccountConditionsRequestService(component, event, helper).then(
                $A.getCallback(function (result) {
                  
                    navigate("NEXT");
                }),
                $A.getCallback(function (error) {
                    component.set("v.errorMessage", "There was an error while Adding product conditions ");
                })
            );
              
                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked); 
                break;
            }
    },
    
  
})