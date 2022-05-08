({
    doInit : function(component, event, helper) {
        
        helper.fetchTranslationValues(component, 'v.sourceOfFundsList', 'CIFCodesList', 'Sof', 'Outbound', 'Application__c', 'Source_of_Funds_Savings__c');
        
        helper.loadData(component,event);
                
        if (component.get("v.doClientUpdate"))
        {
            var lockId = component.get("v.lockVersionId");

            if ((lockId != null) && (lockId == ""))
            {
                var promise = helper.getApplicationAsPromise(component, event)
                .then(
                    // resolve handler
                    $A.getCallback(function(result) {
                        component.set("v.showSpinner", false);

                        var clientUpdatePromise = helper.clientUpdateAsPromise(component, event)
                        .then(
                            $A.getCallback(function(result) {
                                //helper.loadData(component,event);
                                var promise = helper.loadDataAsPromise(component,event)
                                .then(
                                    $A.getCallback(function(result) {
                                        component.set("v.showSpinner", false);

                                        $A.getCallback(function(result) {

                                        }),
                                        $A.getCallback(function(error) {                                
                                            component.set("v.showSpinner", false);
                                            
                                            component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                                            component.find('branchFlowFooter').set('v.message', error.errorMessage);
                                            component.find('branchFlowFooter').set('v.showDialog', true);                
                                        })
                                    })    
                                )
                            }),
                        
                            // reject handler
                            $A.getCallback(function(error) {                                
                                component.set("v.showSpinner", false);
                                
                                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                                component.find('branchFlowFooter').set('v.message', error.errorMessage);
                                component.find('branchFlowFooter').set('v.showDialog', true);                
                            })
                        )
                    }),
                    
                    // reject handler
                    $A.getCallback(function(error) {                                
                        component.set("v.showSpinner", false);
                        
                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                        component.find('branchFlowFooter').set('v.message', error.errorMessage);
                        component.find('branchFlowFooter').set('v.showDialog', true);                
                    })
                )

            }
            else
            {
                var clientUpdatePromise = helper.clientUpdateAsPromise(component, event)
                .then(
                    $A.getCallback(function(result) {
                        helper.loadData(component,event);
                    }),
                
                    // reject handler
                    $A.getCallback(function(error) {                                
                        component.set("v.showSpinner", false);
                        
                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                        component.find('branchFlowFooter').set('v.message', error.errorMessage);
                        component.find('branchFlowFooter').set('v.showDialog', true);                
                    })
                )
            }

            component.set("v.doClientUpdate", false);
        }
    },

    loadIncome : function (component, event, helper) 
    {
        helper.loadData(component,event);
    },

    updateIncome : function(component, event, helper)
    {        
        var v = component.get("v.readOnly");

        if (v == true)
        {
            component.set("v.readOnly", false);
        }
        else {
            var promise = helper.saveDataAsPromise(component, event)
                .then(
                    // resolve handler
                    $A.getCallback(function(result) {
                        component.set("v.showSpinner", false);

                        helper.loadData(component,event);
                        // var promise = helper.loadDataAsPromise(component,event)
                        // .then(
                        //     $A.getCallback(function(result) {
                        //         component.set("v.showSpinner", false);

                        //         $A.getCallback(function(result) {
                                    
                        //         }),
                        //         $A.getCallback(function(error) {                                
                        //             component.set("v.showSpinner", false);
                                    
                        //             component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                        //             component.find('branchFlowFooter').set('v.message', error.errorMessage);
                        //             component.find('branchFlowFooter').set('v.showDialog', true);                
                        //         })
                        //     })    
                        // );

                        component.set("v.readOnly", true);
                    }),
                    
                    // reject handler
                    $A.getCallback(function(error) {                                
                        component.set("v.showSpinner", false);
                        
                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                        component.find('branchFlowFooter').set('v.message', error.errorMessage);
                        component.find('branchFlowFooter').set('v.showDialog', true);

                        component.set("v.readOnly", true);
                    })
                )

            //helper.saveData(component, event);

            //helper.loadData(component,event);
            
            //component.set("v.readOnly", true);
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
                    console.log("Next");

                    helper.removeValidation(component, event);
                    
                    var valid = helper.handleValidation(component, event);
                   
                    if (valid)
                    {
                        component.set("v.showSpinner", false);
                        
                        var promise = helper.saveDataAsPromise(component, event)
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
                                component.find('branchFlowFooter').set('v.message', error.errorMessage);
                                component.find('branchFlowFooter').set('v.showDialog', true);                
                            })
                        )
                    }
                    
                    break;
                }
            case "BACK":
                {
                    component.set("v.showSpinner", false);

                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    component.set("v.showSpinner", false);
                    //component.set("v.readOnly", true);

                    helper.saveData(component, event);                    

                    navigate(event.getParam("action"));
                    break;
                }
        }
       
    }
})