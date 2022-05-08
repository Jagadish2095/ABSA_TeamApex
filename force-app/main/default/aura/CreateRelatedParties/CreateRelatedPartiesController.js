({
    init: function (component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
       
        let promise = helper.createAccountContactRelationship(component, event, helper).then(
            $A.getCallback(function (result) {

                navigate("NEXT");
                resolve("success");
            }),
                $A.getCallback(function (error) {
                    component.set("v.errorMessage", "There was an error while trying to link RelatedParty: \n" + error);
                })
            );


    },

    handleNavigate: function (component, event, helper) {
		
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
       
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':  
                             
            let promise = helper.createAccountContactRelationship(component, event, helper).then(
                $A.getCallback(function (result) {

                    navigate("NEXT");
                    resolve("success");
                }),
                	$A.getCallback(function (error) {
                		component.set("v.errorMessage", "There was an error while trying to link RelatedParty: \n" + error);
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
        }

 
})