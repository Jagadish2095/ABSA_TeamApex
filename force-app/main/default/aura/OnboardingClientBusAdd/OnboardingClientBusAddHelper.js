({
    getAccountDetails : function(component, event, helper,isFromDoInit) {
        var parentValue = event.getParam('arguments');
        var accountRecId = component.get("v.accRecId");
        var predefinedClientType = component.get("v.accountClientType");
        
        if(parentValue) {
            if(accountRecId == null) {
                accountRecId = parentValue.accId;//params
                component.set("v.accRecId",accountRecId);
            }
            
            predefinedClientType = parentValue.clientTypeVal;
            
        }
        
        var action = component.get("c.getClientType");  //get all address
        action.setParams({
            recordId : accountRecId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (component.isValid() && state === "SUCCESS") {
                var isFromEditRelatedParty  = component.get("v.isFromEditRelatedParty");
                var isFromNonIndividualRelatedParty = component.get("v.isFromNonIndividualRelatedParty");
                //alert(isFromEditRelatedParty);
                if(isFromEditRelatedParty){
                    component.set("v.addressRecord.Client_Entity_Type__c",'Individual Related Party');
                }else{
                    var clientTypeReturned = response.getReturnValue();
                    if(clientTypeReturned != null) {
                        //alert(clientTypeReturned);
                        component.set("v.accountClientType",clientTypeReturned); 
                        component.set("v.addressRecord.Client_Entity_Type__c",clientTypeReturned); 
                    }  
                    var isFromNonIndividualRelatedParty = component.get("v.isFromNonIndividualRelatedParty");
                    if(isFromNonIndividualRelatedParty){
                        //alert(component.get("v.accountClientType"));
                        var ReturnclientType = component.get("v.accountClientType");
                        if(ReturnclientType == 'Trusts' || ReturnclientType =='Foreign Trust'){
                            var addressRecord = component.get("v.addressRecord");
                            addressRecord.Client_Entity_Type__c = 'Trusts Related Party';
                            component.set("v.addressRecord",addressRecord);
                        }
                        /*if(ReturnclientType == 'Private Company'){
                            var addressRecord = component.get("v.addressRecord");
                            addressRecord.Client_Entity_Type__c = 'Private Related Party';
                            component.set("v.addressRecord",addressRecord);
                        }*/
                        if(ReturnclientType == 'Foreign Listed Companies' || ReturnclientType == 'Foreign Companies' ||
                           ReturnclientType == 'Co-operative' || ReturnclientType == 'Public Listed Company' ||
                ReturnclientType == 'Close Corporation' || ReturnclientType == 'Non Profit Companies' || ReturnclientType == 'Non Profit Organizations (NGO)'){
                            var addressRecord = component.get("v.addressRecord");
                            addressRecord.Client_Entity_Type__c = 'Non-Individual Related Party';
                            component.set("v.addressRecord",addressRecord);
                        }
                    }
                }
                if(isFromDoInit == 'No'){
                    component.set("v.showNewAddressModal", true); 
                }
            }else{
                if(isFromDoInit == 'No'){
                    component.set("v.showNewAddressModal", true);
                }
            }
        });     
        
        $A.enqueueAction(action);
    },
    
	getAddresses : function(component, event, helper) {
        var parentValue = event.getParam('arguments');
        
        if (parentValue) {
            var accountRecId = parentValue.accId;//params
            console.log('++++accountRecId+++++'+accountRecId);
            component.set("v.accRecId",accountRecId);
        }
        
        var accRecId = component.get("v.accRecId");
        
        if (accRecId) {
            var action = component.get("c.displayAddresses");  //get all address
            action.setParams({
                accRecId : accRecId
            });
            
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var addList = response.getReturnValue();
                    component.set("v.addList", addList); 
                    component.find("dtTable").set("v.selectedRows", component.get('v.preSelectedRows'));
                    
                }
            });     
            $A.enqueueAction(action);
        }
    },
    // Edit and Save Business Address Information
    handleSaveEdition:function(cmp, event, helper) {
        
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updateAddress");
        action.setParams({"add" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                cmp.set("v.addList",[]); 
                cmp.set('v.columns', []);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                        "message": "Address has been Successfully Refreshed.",
                        "type":"success"
                    });
             toastEvent.fire();
                 var action2 = cmp.get("c.displayAddresses");  
                 action2.setParams({
                     accRecId : cmp.get("v.accRecId")
                 });
                 
                 
                 action2.setCallback(this, function(response2) {
                     var state2 = response.getState();
                     if (cmp.isValid() && state2 === "SUCCESS") {
                         var addList = response2.getReturnValue();
                         cmp.set('v.columns', [
                             {label: 'Street', fieldName: 'Shipping_Street__c', type: 'text' ,editable: true},
                             {label: 'Street 2', fieldName: 'Shipping_Street_2__c', type: 'text' ,editable: false},
                             {label: 'Suburb', fieldName: 'Shipping_Suburb__c', type: 'text' ,editable: true},
                             {label: 'City', fieldName: 'Shipping_City__c', type: 'text' ,editable: true},
                          //{label: 'State/Province', fieldName: 'Shipping_State_Province__c', type: 'text' ,editable: true},//W-006583
                             {label: 'Country', fieldName: 'Shipping_Country__c', type: 'text' ,editable: true},
                             {label: 'Zip Postal code', fieldName: 'Shipping_Zip_Postal_Code__c', type: 'text' ,editable: true},
                             {label: 'Address Type', fieldName: 'Address_Type__c', type: 'text' ,editable: false}
                             
                         ]);
                         cmp.set("v.addList",addList); 
                         
                     }
                 });     
                 $A.enqueueAction(action2); 
             }
            else {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while updating address, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);       
    },    
                             
     //Function to show toast for Errors/Warning/Success
      getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
    
        toastEvent.setParams({
          title: title,
          message: msg,
          type: type
        });
    
        return toastEvent;
      },
    getAddressTypes:function(component, event,entityTypeValue) {
        var action = component.get("c.fetchAddressTypes");  
        console.log('entityTypeValue' + entityTypeValue);

        action.setParams({
            "entityTypeValue" : entityTypeValue
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var addList = response.getReturnValue();
                console.log('addList '+JSON.stringify(addList));
                if(addList != null && addList != undefined){
                    var addressTypeList = [];
                    for(var i in addList){
                        var eachField = {'label': addList[i], 'value': addList[i]};
                        addressTypeList.push(eachField);
                    }
                    component.set("v.addressTypeList",addressTypeList);
                    component.set("v.allTypeList",addressTypeList);
                }
            }
        });     
        $A.enqueueAction(action);
    },
    //8818
    fetchProcessType : function(component, event, helper) {
       
        var accRecId = component.get("v.accRecId");
        //alert(accRecId);
        if (accRecId) {
            var action = component.get("c.fetchProcessType"); 
            action.setParams({
                accId : accRecId
            });
            
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                if (component.isValid() && state === "SUCCESS") {
                    var processDefined = response.getReturnValue();
                    //alert('processDefined '+processDefined);
                    component.set("v.processType", processDefined); 
                   
                }
            });     
            $A.enqueueAction(action);
        }
    }
})