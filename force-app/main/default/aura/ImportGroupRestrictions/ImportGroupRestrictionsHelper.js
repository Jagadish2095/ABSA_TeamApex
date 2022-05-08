({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getRestrictionHierarchy")
        action.setParams({
            "customerKey" : component.get("v.CIF")
        });
        action.setCallback(this, $A.getCallback(function (response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.showSpinner", false);
                var responseBean = JSON.parse(response.getReturnValue());
                if(responseBean != null){
                    if(responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.HasErrors == "false"){
                        if(responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.Data  != null){
                            var data = responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.Data.GroupRestrictionHierarchyModel;
                            var restrictionGrpData = [];
                            for(var i=0; i<data.length; i++){
                                console.log('data '+JSON.stringify(data[i]));
                                var childData =[{"ObjectID":"Customers","SchemeNodeID":"Customers"+i},{"ObjectID":"Accounts","SchemeNodeID":"Accounts"+i},{"ObjectID":"Excluded Accounts","SchemeNodeID":"ExcludedAccounts"+i},{"ObjectID":"Transaction Types","SchemeNodeID":"TransactionTypes"+i}];
                                //adding restriction grp to list
                                var restriction = {};
                                restriction.ObjectID = data[i].ObjectID;
                                restriction.EntityType = data[i].EntityType;
                                restriction.EffectiveStartDate = data[i].EffectiveStartDate;
                                restriction.EffectiveEndDate = data[i].EffectiveEndDate;
                                restriction.Description = data[i].Description;
                                restriction.IsEffectiveEndDateInfinity = data[i].IsEffectiveEndDateInfinity;
                                restriction.ParentSchemeNodeID = data[i].ParentSchemeNodeID;
                                restriction.SchemeNodeID = data[i].SchemeNodeID;
                                restriction.ClusterID = data[i].ClusterID;
                                //adding child records to the restriction
                                for(var j=0; j<childData.length; j++) {
                                    if(childData[j].ObjectID == 'Customers'){
                                        if(data[i].Customers != null){
                                            childData[j]._children = data[i].Customers.CustomerModel;
                                        }
                                    }
                                    else if(childData[j].ObjectID == 'Accounts'){
                                        if(data[i].Accounts != null){
                                            childData[j]._children = data[i].Accounts.AccountModel;
                                        }
                                    }
                                        else if(childData[j].ObjectID == 'Excluded Accounts'){
                                            if(data[i].ExcludedAccounts != null){
                                                childData[j]._children = data[i].ExcludedAccounts.ExcludedAccountModel;
                                            }
                                        }
                                            else if(childData[j].ObjectID == 'Transaction Types'){
                                                if(data[i].TransactionTypes != null){
                                                    childData[j]._children = data[i].TransactionTypes.TransactionTypeModel;
                                                }
                                            }
                                }
                                restriction._children = childData;
                                restrictionGrpData.push(restriction);
                            }
                            console.log('restrictionGrpData '+JSON.stringify(restrictionGrpData));
                            component.set("v.restrictionGrpData", restrictionGrpData);
                            component.set("v.restrictionGrpDataCopy", restrictionGrpData);
                        }
                        else{
                            component.set("v.showConfirmationModal", true);
                            component.set("v.body", "No Group Restrictions found!");
                        }
                    }
                    else{
                        alert('Error : '+ responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.HasErrors);
                    }
                }
                else{
                    alert("Something went wrong");
                }
            } else if (state === "ERROR") {
                component.set("v.showSpinner", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        }));
        $A.enqueueAction(action);
    },
    
    updateSelectedRows : function(component, event, helper){
        var selectedRows =  event.getParam('selectedRows');
        var restrictionGrpDataCopy = component.get("v.restrictionGrpDataCopy");
        var data = JSON.parse(JSON.stringify(restrictionGrpDataCopy));
        var currentSelected = component.get("v.currentSelected");
        var selectedRecords = [];
        var selectedData = [];
        
        for ( var i = 0; i < selectedRows.length; i++ ) {
            for ( var j = 0; j < data.length; j++ ){
                if ( selectedRows[ i ].SchemeNodeID == data[ j ].SchemeNodeID ) {
                    var childrenRecs = data[ j ][ '_children' ];
                    selectedData.push( data[ j ].SchemeNodeID );
                    selectedRecords.push(data[ j ]);
                    for ( var k = 0; k < childrenRecs.length; k++ ){
                        if(childrenRecs[k][ '_children' ] != undefined){
                            var grandChildRecs = childrenRecs[k][ '_children' ];
                            selectedData.push( childrenRecs[ k ].SchemeNodeID ); 
                            for( var key =0; key <grandChildRecs.length ; key++ ){
                                selectedData.push( grandChildRecs[ key ].SchemeNodeID );
                                selectedRecords.push(grandChildRecs[ key ]);
                            }
                        }
                    }
                }
            }           
        }
        
        selectedRecords.forEach(row=>{
            if(row.hasOwnProperty('_children')){
            delete row._children;
        }
                                })
        
        console.log('selectedData '+JSON.stringify(selectedData));
        component.set('v.currentSelected', selectedData);
        component.set('v.selectedRows', selectedData );
        component.set('v.selectedRecords', selectedRecords);
    },
    
    onToggle : function(component, event, helper) {
        var toggledId = event.getParam("name");
        var toggledIds = component.get("v.toggledIds");
        if (event.getParam("isExpanded") === false) {
            toggledIds.push(toggledId);
        } else {
            const index = toggledIds.indexOf(toggledId);
            if (index > -1) {
                toggledIds.splice(index, 1);
            }
        }
        console.log('toggledIds '+toggledIds);
        component.set("v.toggledIds", toggledIds);
        var currentSelectedDispo = component.get("v.currentSelected");
        console.log('currentSelectedDispo '+JSON.stringify(currentSelectedDispo));
        if (currentSelectedDispo.length > 0) {
            component.set("v.selectedRows", currentSelectedDispo);
        }
    },
    
    import : function(component, event, helper){
        var selectedRows = component.get("v.selectedRecords");
        var action = component.get("c.bulkImportNodes");
        action.setParams({
            caseId : component.get("v.caseId"),
            records : JSON.stringify(selectedRows)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": resp
                });
                toastEvent.fire();
                window.location.reload();  
                component.destroy();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
                component.destroy();
            }
        });
        $A.enqueueAction(action);
    }
})