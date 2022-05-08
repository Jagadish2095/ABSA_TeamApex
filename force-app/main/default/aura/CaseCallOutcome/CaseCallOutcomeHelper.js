({
    fetchPicklistValues: function(component,event,helper) {
            // call the server side function
            var recId = component.get("v.recordId");
            var action = component.get("c.getOutcomes");
            console.log('recId = ' + recId);
            // pass paramerters [object definition , contrller field name ,dependent field name] -
            // to server side function
            action.setParams({
                'recordId' : recId
            });
            //set callback
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    //store the return response from server (map<string,List<string>>)
                    var StoreResponse = response.getReturnValue();
					console.log('Log Data'+ JSON.stringify(response.getReturnValue()));
                    // once set #StoreResponse to depnedentFieldMap attribute
                    component.set("v.depnedentFieldMap",StoreResponse);

                    // create a empty array for store map keys(@@--->which is controller picklist values)
                    var listOfkeys = []; // for store all map keys (controller picklist values)
                    var ControllerField = []; // for store controller picklist value to set on lightning:select.

                    // play a for loop on Return map
                    // and fill the all map key on listOfkeys variable.
                    for (var singlekey in StoreResponse) {
                        listOfkeys.push(singlekey);
                    }

                    //set the controller field value for lightning:select
                    if (listOfkeys != undefined && listOfkeys.length > 0) {
                        ControllerField.push('--- None ---');
                    }

                    for (var i = 0; i < listOfkeys.length; i++) {
                        ControllerField.push(listOfkeys[i]);
                    }
                    // set the ControllerField variable values to country(controller picklist field)
                    component.set("v.listControllingValues", ControllerField);
                }else{
                    console.log('Something went wrong..'+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        },

        fetchDepValues: function(component, ListOfDependentFields) {
            // create a empty array var for store dependent picklist values for controller field
            var dependentFields = [];
            dependentFields.push('--- None ---');
            for (var i = 0; i < ListOfDependentFields.length; i++) {
                dependentFields.push(ListOfDependentFields[i]);
            }
            // set the dependentFields variable values to store(dependent picklist field) on lightning:select
            component.set("v.listDependingValues", dependentFields);

        },
});