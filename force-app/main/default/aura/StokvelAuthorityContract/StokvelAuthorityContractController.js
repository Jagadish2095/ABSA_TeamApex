({
    doInit: function(component, event, helper) {         
        var customerContractData = component.get('v.customerContractData');
        var customerProofAuthorityData = component.get('v.customerProofAuthorityData');
      	helper.saveOpportunitySatge(component, event, helper);
        if(customerContractData != null && customerContractData !='')
        {            
            if (customerContractData != null && customerContractData != "") {
               var promise = helper.saveDocumentInfo(component, event, helper)
                    .then(
                        $A.getCallback(function(result) {
                            var navigate = component.get("v.navigateFlow");
       						 navigate("NEXT");
                        }),
                        $A.getCallback(function(error) {
                            alert('Error');
                        })
                    )
            }
            
        }
       
    },
    handleNavigate: function (component, event, helper) {
		var actionClicked = event.getParam("action");
		let navigate = component.get("v.navigateFlow");

		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				{
                    navigate("NEXT");					
				}
				break;
			default:
				navigate(actionClicked);
				break;
		}
	}
})