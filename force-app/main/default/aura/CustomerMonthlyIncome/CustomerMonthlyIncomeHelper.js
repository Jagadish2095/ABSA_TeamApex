({
    loadApplication : function(component, event)
    {
        component.set("v.showSpinner", true);

        var action = component.get("c.getApplication");
        
        action.setParams({
            "accountId": component.get("v.applicationId"),
            "opportunityId": component.get("v.opportunityId")
        });

        action.setCallback(this, function (response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               var results = response.getReturnValue();

               //set attribute values from results 
               
               component.set("v.applicationId", results.Id);
               
           }else{
               console.log('failed---'+state);
           }

           component.set("v.showSpinner", false);
       });
       
       $A.enqueueAction(action);
    },

    loadDataAsPromise: function(component, event)
    {
        component.set("v.showSpinner", true);
        
        return new Promise(function(resolve, reject) {
            var action = component.get("c.getIncome");
        
            action.setParams({
                "applicationId": component.get("v.applicationId")
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                     var results = JSON.parse(response.getReturnValue());
                     
                     component.set("v.incomeRecord", results);
     
                     if (results.bankStatementsConsent == true)
                     {
                     component.set("v.bankStatementsConsent", "true");
                     }
                     
                     var l = component.get("v.sourceOfFundsList"); 
                     
                     console.log(l);
                     
                     var items = [];
     
                     for (let i = 0; i < l.length; i++) {
                         var itm = {
                             "label": l[i],
                             "value": l[i]
                         };
     
                         items.push(itm); 
                     }
     
                     component.set("v.optionsSOF", items);
     
                     var s = component.get("v.incomeRecord.sourceOfFunds");
     
     
                     var sofItems = (!s || s.length === 0) ? [] : (s.includes(";")) ? s.split(";") : [s];
     
                     var selectedItems = [];
     
                     for (let i = 0; i < sofItems.length; i++) {                    
                         selectedItems.push(sofItems[i]); 
                     }
     
                     component.set("v.selectedSOF", selectedItems);

                     resolve( { isValid: true, errorMessage: '', actionResult: ''} );
     
                }else{
                     var errors = response.getError();
     
                     reject( { isValid: false, errorMessage: errors } );
                }
     
                component.set("v.showSpinner", false);
            });
            
            $A.enqueueAction(action);
        });
    },

    loadData : function(component,event) {
        console.log('Load');
        component.set("v.showSpinner", true);

        var action = component.get("c.getIncome");
        
        action.setParams({
            "applicationId": component.get("v.applicationId")
        });

        action.setCallback(this, function (response) {
           var state = response.getState();
           
           if (state === "SUCCESS") {
                var results = JSON.parse(response.getReturnValue());
                
                component.set("v.incomeRecord", results);

                if (results.bankStatementsConsent == true)
                {
                component.set("v.bankStatementsConsent", "true");
                }
                
                var l = component.get("v.sourceOfFundsList"); 
                
                console.log(l);
                
                var items = [];

                for (let i = 0; i < l.length; i++) {
                    var itm = {
                        "label": l[i],
                        "value": l[i]
                    };

                    items.push(itm); 
                }

                component.set("v.optionsSOF", items);

                var s = component.get("v.incomeRecord.sourceOfFunds");


                var sofItems = (!s || s.length === 0) ? [] : (s.includes(";")) ? s.split(";") : [s];

                var selectedItems = [];

                for (let i = 0; i < sofItems.length; i++) {                    
                    selectedItems.push(sofItems[i]); 
                }

                component.set("v.selectedSOF", selectedItems);

           }else{
                var errors = response.getError();

                console.log('failed---'+state);
                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                component.find('branchFlowFooter').set('v.message', errors[0].message);
                component.find('branchFlowFooter').set('v.showDialog', true);
           }

           component.set("v.showSpinner", false);
       });
       
       $A.enqueueAction(action);
   },

//    saveData : function(component,event) {
//         console.log('Saving Income');
//         component.set("v.showSpinner", true);

//         var bankStatementsConsent = component.get("v.bankStatementsConsent");

//         component.set("v.incomeRecord.bankStatementsConsent", false);

//         if (bankStatementsConsent == "true")
//         {
//             component.set("v.incomeRecord.bankStatementsConsent", true);
//         }

//         var action = component.get("c.saveIncome");

//         var d = component.get("v.incomeRecord");
// 		console.log("Data to sent");
//         console.log(JSON.stringify(d));
//         action.setParams({ "data" : JSON.stringify(d) });

//         action.setCallback(this, function (response) {
//             component.set("v.showSpinner", false);
            
//             var state = response.getState();
            
//             if (state != "SUCCESS") {
//                 var errors = response.getError();

//                 console.log('failed---'+state);
//                 console.log(errors);

//                 component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
//                 component.find('branchFlowFooter').set('v.message', errors[0].message);
//                 component.find('branchFlowFooter').set('v.showDialog', true);
//             }
//         });
   
//         $A.enqueueAction(action);
//    },

    saveDataAsPromise : function(component, event) {
        component.set("v.showSpinner", true);
        
        return new Promise(function(resolve, reject) {
            var bankStatementsConsent = component.get("v.bankStatementsConsent");

            component.set("v.incomeRecord.bankStatementsConsent", false);

            if (bankStatementsConsent == "true")
            {
            component.set("v.incomeRecord.bankStatementsConsent", true);
            }

            var l = component.get("v.selectedSOF");

            var s = "";

            for (let i = 0; i < l.length; i++) {
                s = s + l[i] + ";";
            }

            console.log(s);

            component.set("v.incomeRecord.sourceOfFunds", s);

            var action = component.get("c.saveIncome");

            var d = component.get("v.incomeRecord");
            console.log("Data to sent");
            console.log(JSON.stringify(d));
            action.setParams({ "data" : JSON.stringify(d) });
            
            action.setCallback(this, function (response) {
                component.set("v.showSpinner", false);
        
                var state = response.getState();
        
                if (state === "SUCCESS") {           
                    resolve( { isValid: true, errorMessage: '', actionResult: ''} );
                }else{
                    var errors = response.getError();
            
                    reject( { isValid: false, errorMessage: errors } );
                }
            });
        
            $A.enqueueAction(action);
        });
    },

    getApplicationAsPromise : function(component,event) {
        component.set("v.showSpinner", true);

        return new Promise(function(resolve, reject) {

            var action = component.get("c.getApplicationInformation");

            console.log('getApplication Service');
            console.log('Application Number:' + component.get("v.applicationNumber"));

            action.setParams({            
                "applicationNumber": component.get("v.applicationNumber")
            });
            
            action.setCallback(this, function (response) {
                component.set("v.showSpinner", false);
    
                console.log(response.getReturnValue());
                
                var results = JSON.parse(response.getReturnValue());
    
                var state = response.getState();
                    
                if (state === 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    
                    var results = JSON.parse(returnValue);
                    
                    component.set("v.lockVersionId", results.getApplicationInformationResponse.z_return.application.lockVersionId);

                    resolve( { isValid: true, errorMessage: '', actionResult: returnValue} );

                } else {
                    var errors = response.getError();
                    
                    console.log('failed---'+state);
                    console.log(errors);
                    
                    var s = "";
                    
                    for (var i = 0; i < errors.length; i++)
                    {
                        s = s + errors[i].message;
                    }
                    
                    reject( { isValid: false, errorMessage: s } );
                }
            });
        
            $A.enqueueAction(action);
        });
    },

    clientUpdateAsPromise : function(component,event) {
        component.set("v.showSpinner", true);

        return new Promise(function(resolve, reject) {
            var action = component.get("c.applyClientUpdate");
        
            action.setParams({
                "applicationId": component.get("v.applicationId"),
                "applicationNumber": component.get("v.applicationNumber")
            });
            
            action.setCallback(this, function (response) {
                component.set("v.showSpinner", false);
    
                var state = response.getState();
                console.log(response.getReturnValue());
                var results = JSON.parse(response.getReturnValue());
                
                if (state === "SUCCESS") {
                    if (results.statusCode == 200)
                    {                    
                        if ((results.applyResponse.z_return.responseCommons != null) && 
                            (results.applyResponse.z_return.responseCommons.responseMessages != null) && 
                            (results.applyResponse.z_return.responseCommons.responseMessages.length > 0))
                        {
                            var s = "";
                            
                            component.set("v.isNextDisabled", true);
                            component.set("v.isPauseDisabled", true);

                            for (var i = 0; i < results.applyResponse.z_return.responseCommons.responseMessages.length; i++)
                            {
                                console.log(results.applyResponse.z_return.responseCommons.responseMessages[i].message);
    
                                s = s + results.applyResponse.z_return.responseCommons.responseMessages[i].message + "\r\n";
    
                                s = s.replace("&lt;", "<");
                                s = s.replace("&gt;", ">");
                            }
    
                            var errors = response.getError();
                    
                            reject( { isValid: false, errorMessage: s } );
                        }
                        else {
                            component.set("v.preAssessedCreditLimit", results.preAssessedCreditLimit);
                            component.set("v.expense", JSON.stringify(results.expense));
                            component.set("v.lockVersionId", results.applyResponse.z_return.application.lockVersionId);

                            resolve( { isValid: true, errorMessage: '', actionResult: ''} );
                        }
                    }
                }
                else
                {   
                    component.set("v.isNextDisabled", true);
                    component.set("v.isPauseDisabled", true);

                    var errors = response.getError();
    
                    console.log('failed---'+state);
                    console.log(errors);
    
                    var s = "";
    
                    for (var i = 0; i < errors.length; i++)
                    {
                        s = s + errors[i].message;
                    }
    
                    reject( { isValid: false, errorMessage: s } );
                }
            });
    
            $A.enqueueAction(action);
        });
    },

    clientUpdate : function(component,event) {
        component.set("v.showSpinner", true);

        console.log('clientUpdate Service');
        console.log('Application Number:' + component.get("v.applicationNumber"));
        
        var action = component.get("c.applyClientUpdate");
        
        action.setParams({
            "applicationId": component.get("v.applicationId"),
            "applicationNumber": component.get("v.applicationNumber")
        });

        action.setCallback(this, function (response) {
            component.set("v.showSpinner", false);

            var state = response.getState();
            console.log(response.getReturnValue());
            var results = JSON.parse(response.getReturnValue());
            
            if (state === "SUCCESS") {
                if (results.statusCode == 200)
                {                    
                    if ((results.applyResponse.z_return.responseCommons != null) && 
                        (results.applyResponse.z_return.responseCommons.responseMessages != null) && 
                        (results.applyResponse.z_return.responseCommons.responseMessages.length > 0))
                    {
                        var s = "";

                        for (var i = 0; i < results.applyResponse.z_return.responseCommons.responseMessages.length; i++)
                        {
                            console.log(results.applyResponse.z_return.responseCommons.responseMessages[i].message);

                            s = s + results.applyResponse.z_return.responseCommons.responseMessages[i].message + "\r\n";

                            s = s.replace("&lt;", "<");
                            s = s.replace("&gt;", ">");
                        }

                        component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                        component.find('branchFlowFooter').set('v.message', s);
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    else {
                        component.set("v.preAssessedCreditLimit", results.preAssessedCreditLimit);
                        component.set("v.expense", JSON.stringify(results.expense));
                        component.set("v.lockVersionId", results.applyResponse.z_return.application.lockVersionId);
                    }
                }
            }
            else
            {                
                var errors = response.getError();

                console.log('failed---'+state);
                console.log(errors);

                var s = "";

                for (var i = 0; i < errors.length; i++)
                {
                    s = s + errors[i].message;
                }

                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                component.find('branchFlowFooter').set('v.message', s);
                component.find('branchFlowFooter').set('v.showDialog', true);
            }
        });

        $A.enqueueAction(action);    
   },

   handleValidation: function(component,event) {                
        var sof = component.find("SOF");
        var grossIncome = component.find("grossIncome");
        var netIncome = component.find("netIncome");

        if (!sof.get("v.value"))
        {
            $A.util.addClass(sof,'slds-has-error');
            
            return false;
        }

        if ((!grossIncome.get("v.value")) || (grossIncome.get("v.value") <= 0))
        {
            $A.util.addClass(grossIncome,'slds-has-error');
            
            return false;
        }

        if ((!netIncome.get("v.value")) || (netIncome.get("v.value") <= 0))
        {
            $A.util.addClass(netIncome,'slds-has-error');

            return false;
        }

        return true;
    },

    removeValidation: function(component,event) {
        var soi = component.find("SOI");
        var sof = component.find("SOF");

        $A.util.removeClass(soi,'slds-has-error');
        $A.util.removeClass(sof,'slds-has-error');
    },

    fetchTranslationValues: function(component, listName, systemName, valueType, direction, objName, objField) {
        var action = component.get('c.getTranslationValues');
        var objObject = { 'sobjectType': objName };
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction,
            'objObject': objObject,
            'objField': objField
        });
        action.setCallback(this, function(response) {
            var mapValues = response.getReturnValue();
            var listValues = [];
            
            for(var itemValue in mapValues) {
                if (mapValues[itemValue] == 'valid') {
                    listValues.push(itemValue);
                } else {
                    // Add function to log/mail system admin with missing values
                }
            }

            listValues.sort();

            component.set(listName, listValues);
        });
        $A.enqueueAction(action);
    }
})