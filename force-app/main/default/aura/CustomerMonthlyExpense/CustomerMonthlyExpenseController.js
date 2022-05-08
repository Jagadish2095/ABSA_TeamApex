({
    doInit : function(component, event, helper) {        
        component.set('v.validate', function()  
        {
            console.log("save Expenses"); 
            var de = component.find("monthlyExpenses");

            de.updateExpenses(); 

            var le = component.find("monthlyLivingExpenses"); 

            le.updateLivingExpenses(); 
        })
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");

        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                {
                    var promise = helper.clientUpdateAsPromise(component, helper)
                        .then(
                            // resolve handler
                            $A.getCallback(function(result) {
                                component.set("v.showSpinner", false);

                                navigate(event.getParam("action"));
                            }),
                            
                            // reject handler
                            $A.getCallback(function(error) {
                                component.set("v.showSpinner", false);
                                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                                component.find('branchFlowFooter').set('v.message', error);
                                component.find('branchFlowFooter').set('v.showDialog', true);                
                            })
                        );

                    break;
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    var promise = helper.clientUpdateAsPromise(component, helper)
                        .then(
                            // resolve handler
                            $A.getCallback(function(result) {
                                component.set("v.showSpinner", false);

                                navigate(event.getParam("action"));
                            }),
                            
                            // reject handler
                            $A.getCallback(function(error) {
                                component.set("v.showSpinner", false);

                                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                                component.find('branchFlowFooter').set('v.message', error);
                                component.find('branchFlowFooter').set('v.showDialog', true);                

                                navigate(event.getParam("action"));
                            })
                        );

                    break;
                }
        }
       
    }
})