({
    doInit : function(component, event,helper){
        
        
        var CIF_Key = component.get('v.customerKey');
        console.log('customer key : '+CIF_Key);
        var businessValue = component.get('v.isBusiness');
        console.log('is Business : '+businessValue);
        
        
        if(businessValue===true){
            
            //call service to list users on a specific account, to get userNo and userName
            
            var action = component.get('c.getUserList');
            var accountNumber = component.get('v.selectedAccountNumber'),
                customerKey = component.get('v.customerKey'),
                userNumber = '001';//when user number is 001 you are able to retrieve the entire list of users
            
            var accNum  =  (accountNumber * 1).toString();
            console.log('accountNumber : '+accNum+ ' userNumber : '+userNumber+' customerKey : '+customerKey);
            action.setParams({accNo:accNum,
                              userNo:userNumber,
                              cifKey:customerKey//'PIERIDO001'//customerKey
                             });
            
               
            
            component.set('v.showSpinner',true);
            action.setCallback(this, function(response) {
                
                var state = response.getState(),
                    respObj = JSON.parse(response.getReturnValue());
                console.log('Response list : '+response.getReturnValue()+'    State : '+state);
                if (state === "SUCCESS" && respObj!= null ) {
                    
                    console.log('-----SUCCESS-----');
                    
                    component.set('v.responseList',respObj)
                    
                    
                    var userList = [];
                    
                    for(var key in respObj){
                        
                        if (!userList.includes(respObj[key].userName)) {
                            
                            userList.push(respObj[key].userName);
                        } 
                    }
                    component.set('v.showSpinner',false);
                    component.set('v.userOptions',userList);
                    
                }
                
                else if(state === "SUCCESS" && respObj === null) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "title": "Error!",
                    "message": "There are no users for this profile",
                    "type":"error"
                });
                component.set('v.showSpinner',false);
                toastEvent.fire();
                } 

            else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                component.set('v.showSpinner',false);
                toastEvent.fire();
            }
                
            });
            $A.enqueueAction(action);
            
            
            
        }
        
        else{
            component.set('v.userNumber','001');
            helper.getUserLimits(component, event); 
            
            
        }
        
    },
    getUserLimits : function(component, event,helper) {
        
        console.log('Testing the if we are able to get user limits');
        var action = component.get("c.getAccountLimits");
        var customerKey = component.get('v.customerKey'),
            userNumber = component.get('v.userNumber');
        
        action.setParams({customerCifKeyP:customerKey,
                          userNumberP:userNumber});
        
        console.log('customerKey : '+customerKey+'  userNumber : '+userNumber);
        
        component.set('v.showSpinner',true);
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS" && response.getReturnValue()!= null) {
              
                var respObj = JSON.parse(response.getReturnValue());
                
                if(respObj.getUserLimitResp != null){
                    
                    var resp = respObj.getUserLimitResp;
                    component.set('v.data', [{
                    
                    opportunityName: 'Inter account tranfers',
                    dailyLimit: resp.intAccXfer,
                    todayUsed: resp.intAccXferUsed,
                    available :  parseInt(resp.intAccXfer - resp.intAccXferUsed)
                    
                },
                                         {
                                             opportunityName: 'Owned defined payments',
                                             dailyLimit: resp.ownDefPaym,
                                             todayUsed: resp.ownDefPaymUsed,
                                             available :  parseInt(resp.ownDefPaym - resp.ownDefPaymUsed)
                                             
                                         },
                                         {opportunityName: 'Account payments',
                                          dailyLimit: resp.billPaym,
                                          todayUsed: resp.billPaymUsed,
                                          available :  parseInt(resp.billPaym - resp.billPaymUsed)
                                         },
                                         
                                         {opportunityName: 'Future-dated payments transactions',
                                          dailyLimit: resp.futDtePaym,
                                          todayUsed: "0",
                                          available :  parseInt(resp.futDtePaym)
                                         }
                                         
                                        ]);
                    component.set('v.showSpinner',false);
                }
                
                
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "title": "Error!",
                    "message": respObj.errorList[0].description,
                    "type":"error"
                });
                component.set('v.showSpinner',false);  
                toastEvent.fire();
                }
            } 

            else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                component.set('v.showSpinner',false);
                toastEvent.fire();
            }
             
        });
        component.set('v.showCloseCase',true);
        $A.enqueueAction(action);
    },
    
    caseCurrentCaseHelper : function(component, event, helper){
        var action = component.get("c.caseClose");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var caseResponse = response.getReturnValue();
                debugger;
                if(caseResponse.isSuccess == 'true'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case successfully closed!",
                        "type":"success"
                    });
                    
                    $A.get('e.force:refreshView').fire();
                }else{
                     toastEvent.setParams({
                        "title": "Error!",
                        "message": caseResponse.errorMessage,
                        "type":"error"
                    });  
                }
                
            }else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } 
            
            toastEvent.fire();
        });
        
        
        $A.enqueueAction(action);
        
    }
   
    
})