({
    init: function (component,evt,helper) {
        helper.refreshData(component, event, helper);
        var accId;
         if(component.get("v.recordId") == undefined) {
            accId = component.get("v.accRecordId"); //when the component is on the NTB form
        } else {
            accId = component.get("v.recordId") //when the component is on the Account form
        }
        //W-008562
       // helper.getOpportunityStage(component, event, helper, accId);
    },
    
    refreshRecords : function(component, event, helper) {
        helper.refreshData(component, event, helper);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to handle Row Actions***********/
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'add_a_submember':
                var row = event.getParam('row');
                var shareholderName = row.Shareholder;
                var accRecId = row.relatedAccountId;
                var primaryEntityId = row.primaryEntityId;
                var recordId = row.recordId;
                component.set("v.parentRelationshipId", recordId);
                
                console.log('MyId'+component.get("v.parentRelationshipId"));
                //Added by Rajesh for the Roles Issue
                
                
                var action = component.get("c.fetchClientType"); 
                action.setParams({
                    "recordId" : recordId
                });
                action.setCallback(this, function(a){
                    var state = a.getState();
                    if(state == 'SUCCESS') {
                        //alert(a.getReturnValue());
                        var returnValue = a.getReturnValue();
                        //alert(returnValue.FinServ__RelatedAccount__r.Client_Type__c);
                        component.set("v.selectedRowsParentClientType", returnValue.FinServ__RelatedAccount__r.Client_Type__c);
                        helper.showModalToAddSubEntity(component, event, helper,shareholderName,accRecId,primaryEntityId);
                    }
                });
                $A.enqueueAction(action);
                
                /*var gridData = component.get("v.gridData");
                console.log('gridData '+JSON.stringify(gridData));
                for(var i in gridData){
                    var childData = gridData[i]._children;
                    console.log('childData '+JSON.stringify(childData));
                    if(childData != null && childData != undefined && childData !=''){
                        for(var j in childData){
                            if(recordId == childData[j].recordId){
                                component.set("v.selectedRowsParentClientType",childData[j].Type);
                            }else{
                                
                            }
                        }
                    }
                }*/
                
                
                break;
                
            case 'view':
                var row = event.getParam('row');
                var recordId = row.recordId;
                component.set("v.rowIdToView", recordId);
                if(recordId.startsWith("07k")){
                    component.set("v.selectedRecordObjectApiName", 'AccountContactRelation');
                }else{
                    component.set("v.selectedRecordObjectApiName", 'FinServ__AccountAccountRelation__c');
                }
                component.set("v.showRelationship", true);
                break;
                
            case 'edit':
                var row = event.getParam('row');
                var recordIdEdit = row.recordId;
                //Added by Rajesh for the Roles Issue
                console.log('recordIdEdit '+recordIdEdit);
                /*var gridData = component.get("v.gridData");
                console.log('gridData '+JSON.stringify(gridData));
                for(var i in gridData){
                    var childData = gridData[i]._children;
                    console.log('childData '+JSON.stringify(childData));
                    if(childData != null && childData != undefined && childData !=''){
                        for(var j in childData){
                           component.set("v.accountClientType",childData[j].Type);
                        }
                    }
                }*/
                var action = component.get("c.fetchClientTypeEdit"); 
                action.setParams({
                    "recordId" : recordIdEdit
                });
                action.setCallback(this, function(a){
                    var state = a.getState();
                    if(state == 'SUCCESS') {
                        var returnValue = a.getReturnValue();
                        console.log('EDIT TYPE '+returnValue.Account.Client_Type__c);
                        component.set("v.accountClientType", returnValue.Account.Client_Type__c);
                        
                    }
                });
                $A.enqueueAction(action);
                
                //Added by Rajesh for the Roles Issue End
                
                component.set("v.showRelationshipEdit",true);
                var row = event.getParam('row');
                var recordId = row.recordId;
                component.set("v.recordIdToEdit",recordId);
                var ChkUBOField = row.UBO;
                component.set("v.ChkUBOField",ChkUBOField);
				var gridData = component.get("v.gridData");
                var primaryEntityId;
                
                if(component.get("v.accRecordId") == undefined){
                primaryEntityId = component.get("v.recordId");}
                else{
                primaryEntityId = component.get("v.accRecordId");     
                }
                component.set("v.primaryEntityId",primaryEntityId);
                console.log('primaryEntityId2 '+component.get("v.primaryEntityId"));
                console.log('primaryEntityId3 '+component.get("v.recordId"));
                if(recordId.startsWith("07k")){
                    component.set("v.showAccConRelationshipEdit",true);
                }else{
                    component.set("v.selectedRecordObjectApiName", 'FinServ__AccountAccountRelation__c');
                }
                break;
                
            case 'delete':
                var row = event.getParam('row');
                var recordId = row.recordId;
                console.log('row.primaryEntityId'+row.primaryEntityId);
                component.set("v.deleteRowPrimaryEntityId", row.primaryEntityId);
                component.set("v.rowIdToDelete", recordId);
                component.set("v.showDeleteRelationshipConfirmation",true);    
                break;
        }
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to close modal*****************/
    closeModel: function(component, event, helper) {
        component.set("v.showRelationship", false);
        component.set("v.showRelationshipEdit", false);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004945***************************************
 	***@ Description: Method Added by chandra to handle submit*****************/
    handleSubmit : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        helper.showSpinner(component);
        const fields = event.getParam('fields');
        var recordId = component.get("v.recordIdToEdit");
        if(!recordId.startsWith("07k")){
            var sharePercentage = fields.Shareholding_Percentage__c;
            var roles = fields.Roles__c;
            helper.calculateControllingPercentageforAccAccRel(component, event, helper, recordId, sharePercentage, roles);
        }
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to handle record form load******/
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") {
            // record is loaded (render other component which needs record data value)
            var rowIdToDelete = component.get("v.rowIdToDelete");
          //  if(rowIdToDelete.startsWith("07k")){
           //     helper.reEvaluateControllingPercentage(component, event, helper, rowIdToDelete);
         //   }else{
                helper.showSpinner(component);
                helper.deleteRelatedHierarchyRecords(component, event, helper, rowIdToDelete);
        //    }
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to handle record form load******/
    handleComponentEvent : function(component, event, helper) {
        var showRelatedParties = event.getParam("showRelatedParties");
        var showOnboardingRelatedParty = event.getParam("showOnboardingRelatedParty");
        component.set("v.showRelationshipEdit",showRelatedParties);
        component.set("v.showOnboardingRelatedParty",showOnboardingRelatedParty);
    },
    
    /****************@ Author: Chandra*********************************************
 	****************@ Date: 06/07/2020*********************************************
 	****************@ Work Id: W-004939********************************************
 	***@ Description: Method Added by chandra to open OnboardingRelatedParties******/
    handleAdd : function(component, event, helper) {
        //W-008562
        var stage = component.get("v.OppStage");
        if(stage == "Closed"){
            helper.closedOpportunityValidation(component, event, helper);
        }else{
             component.set("v.showOnboardingRelatedParty",true);
        }
    },
    
    /****************@ Author: Chandra*********************************************
 	****************@ Date: 06/07/2020*********************************************
 	****************@ Work Id: W-004939********************************************
 	***@ Description: Method Added by chandra to handle aura method****************/
    doAction: function(component, event, helper) {
        var parentValue = event.getParam('arguments'); 
        console.log('Process Type from Big form'+JSON.stringify(parentValue));
        if (parentValue) {
            var accountRecId = parentValue.accId;//params
            var processTypeP = parentValue.processTypeparam;
        }
        component.set("v.accRecordId",accountRecId);
        component.set('v.processTyperp',processTypeP);
        
         helper.refreshData(component);
    },
    
    onSelected : function( component, event, helper ) {
        
        var selectedRows = event.getParam( 'selectedRows' );
        var data = component.get( 'v.gridData' );
        var selectedData = [];
        
        for ( var i = 0; i < selectedRows.length; i++ ) {
            
            for ( var j = 0; j < data.length; j++ ){
                
                if ( selectedRows[ i ].Id == data[ j ].Id ) {
                    
                    var childrenRecs = data[ j ][ '_children' ];
                    selectedData.push( data[ j ].Id );
                    
                    for ( var k = 0; k < childrenRecs.length; k++ )
                        selectedData.push( childrenRecs[ k ].Id );   
                    
                }
                
            }
            
        }
        
        component.set( 'v.gridData', data );
        component.set( 'v.selectedRows', selectedData );
        
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 25/08/2020****************************************
 	****************@ Work Id: W-004746***************************************
 	***@ Description: Method Added by chandra to set Client Type*************/
    setClientType : function(component, event, helper) {
         var methodParam = event.getParam('arguments');
         var clientTypeChangedVal;
        
        if(methodParam) {
            clientTypeChangedVal = methodParam.clientTypeVal;
            
            console.log('setClientType : ' + clientTypeChangedVal);
            
            component.set("v.accountClientType",clientTypeChangedVal);  
        }     
    },
    
});