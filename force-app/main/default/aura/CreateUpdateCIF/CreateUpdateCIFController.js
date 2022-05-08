({
    init: function (component, event, helper) {
        debugger;
         var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
        let promise = helper.ScreenRelatedParties(component,event, helper).then(
            $A.getCallback(function (result) {
                
                let Ipromise = helper.CreateUpdateCIF(component, event,helper).then(
                    $A.getCallback(function (result) {
                        component.set("v.IsAddingRelatedParty", false);
                        navigate("NEXT");
                    }),
                    $A.getCallback(function (error) {
                        component.set("v.errorMessage", "There was an error while trying to create CIF Error: " + JSON.stringify(error));
                    })
                );
            }),
            $A.getCallback(function (error) {
                component.set("v.errorMessage", "There was an error while trying to screen Signatory: \n" + error);
            })
        );
      
	}, 

	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
               {
                let promise = helper.ScreenRelatedParties(component, helper).then(
                    $A.getCallback(function (result) {
                        
                        let Ipromise = helper.CreateUpdateCIF(component, helper).then(
                            $A.getCallback(function (result) {/**/
                                component.set("v.IsAddingRelatedParty", false);
                                navigate("NEXT");
                        	}),
                            $A.getCallback(function (error) {
                                component.set("v.errorMessage", "There was an error while trying to create CIF Error: " + JSON.stringify(error));
                            })
                        );
                    }),
                    $A.getCallback(function (error) {
                        component.set("v.errorMessage", "There was an error while trying to screen Signatory: \n" + JSON.stringify(error));
                    })
                );
               }
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	}
});