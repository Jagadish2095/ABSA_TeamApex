({    
   doInit: function (component, event, helper) {
       var opts = [];
        opts.push({
            class: "optionClass",
            label: "Enquire",
            value: "E"
        });
        opts.push({
            class: "optionClass",
            label: "Create",
            value: "C"
        });
        
        opts.push({
            class: "optionClass",
            label: "Update",
            value: "U"
        });
       
       opts.push({
            class: "optionClass",
            label: "Delete",
            value: "D"
        });
        component.set("v.requestOptions" , opts);
       /*
        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get("v.clientAccountId");
        console.log('clientAccountId ******'+ clientAccountId);
        action.setParams({clientAccountId:clientAccountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                console.log('--------getSourceAccountDetails-------'+respObj);
                component.set('v.responseList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                for(var key in respObj){
                    console.log('==='+respObj[0].productType);
                    if (!prodList.includes(respObj[key].productType)) {
                        prodList.push(respObj[key].productType);
                    } 
                }
                component.set('v.prodTypesList',prodList);
                
            } else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            } else{
                
            }
        });
        $A.enqueueAction(action);
        */
    },
    getAccountNumbers : function(component, event, helper) {
         var selectedProdType = component.get('v.selectedProductValue');
         var respObj = component.get('v.responseList');
         
         console.log(respObj);
         var acc = [];
         
         for(var key in respObj){
             if(respObj[key].productType == selectedProdType){
                 acc.push(respObj[key].oaccntnbr);
                 
             }
         }
         component.set('v.accNumList',acc);
    },
    
     getSelectedAccount : function(component, event, helper) {
        var selectedAccountValue = component.get('v.selectedAccountNumber');
      
     },
    onRequestTypeChnage :function(component, event, helper) {
        
    },
    onChange :function(component, event, helper) {
      
        //Maintain functionality
        var selectedVal = component.get("v.selectedVal");
        
        if(selectedVal=="Maintain"){
            let savePromise = Promise.resolve(
             helper.promiseSaveCI(component)
         );
         savePromise.then(
             $A.getCallback(function (result) {
                  let isCISaved = result;
                  if (!isCISaved) {
                       component.find('notifLib').showToast({
                             "variant": "error",
                             "message": "Unable to save CI"
                       });
                  }else {
                    /*   component.find('notifLib').showToast({
                             "variant": "success",
                             "message": "CI Saved! "
                       });*/
                    	component.set("v.accountInfo",response.getResponseValue);    
                  }
                  
             }),
             $A.getCallback(function (status) {
                  
                  component.find('notifLib').showToast({
                       "variant": "error",
                       "message": "Unable to save CI! "+status.message
                  });
             })
       ).catch(function (error) {
             
             $A.reportError("Unable to save CI!", error);
       });

                
            
        }
            

        
        
    },
    submit :function(component, event, helper) {
    },
    
    submitRequest : function(component, event, helper){
        component.set("v.isEquiry" , false); 
        component.set("v.isDeleted" , false);
        var action = component.get("c.registerMantain");
        var requestValue =  component.find("requestType").get("v.value");
        var email =  component.find("emailAddress").get("v.value");
        var Product =  component.get("v.selectedProductValue");
        var AccountNumber =  component.get("v.selectedAccountNumber");
        
        console.log('Select Request ********************' + requestValue);
        console.log('Select Request Email ********************' + email);
        console.log('Select Request Product ********************' + Product);
        console.log('Select Request Account ********************' + AccountNumber);
        
        if(requestValue =='' || requestValue == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Request Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }else if((email =='' || email == null) && (requestValue == 'C' || requestValue == 'U')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Email Address Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
           
        }else if(Product =='' || Product == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }else if(AccountNumber == '' || AccountNumber == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account Number Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }else{ 
        action.setParams({requests:requestValue , accountNumber: AccountNumber , product:Product,email:email});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
               
                var respObj = JSON.parse(response.getReturnValue());
                
                console.log('--------Service Results-------'+respObj);
                
                if(respObj != null){
                    
                    console.log("Request **********" +  respObj.request);
                    
                    if(respObj.request != null){
                        if(respObj.status == "A" || respObj.status == "E"){
                           console.log('Enquiry Email---------' + respObj.entry[0].email);
                           component.set("v.enquiryEmail" , respObj.entry[0].email.split(";")[0]); 
                           component.set("v.isEquiry" , true); 
                           component.set("v.isDeleted" , false);
                        }else if(respObj.status == "D"){
                           component.set("v.enquiryEmail" , respObj.entry[0].email.split(";")[0]); 
                           component.set("v.isDeleted" , true);
                           component.set("v.isEquiry" , false);
                        }else if(respObj.request == 'C'){
                           var toastEvent = $A.get("e.force:showToast");
                    	   toastEvent.setParams({
                           "title": "Success!",
                           "message": "The " + respObj.entry[0].email + " email address has been successfully created.",
                           "type":"Success"   
                        });
                        toastEvent.fire();
                        }else if(respObj.request == 'U'){
                           var toastEvent = $A.get("e.force:showToast");
                    	   toastEvent.setParams({
                           "title": "Success!",
                           "message": "The email address has been successfully update to " + respObj.entry[0].email,
                           "type":"Success"   
                        });
                        toastEvent.fire();
                        }else if(respObj.request == 'D'){
                            var toastEvent = $A.get("e.force:showToast");
                    	   toastEvent.setParams({
                           "title": "Success!",
                           "message": "The " + respObj.entry[0].email + " email address has been successfully deleted.",
                           "type":"Success"   
                        });
                        toastEvent.fire();
                        }
                    }else{
                       var toastEvent = $A.get("e.force:showToast");
                       toastEvent.setParams({
                       "title": "Error!",
                       "message": "Something went wrong! Try again later",
                       "type":"Error"
                		});
                		toastEvent.fire();
                		} 
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "title": "Error!",
                    "message": "Something went wrong! Please contact system administrator",
                    "type":"Error"
                });
                toastEvent.fire();
                }
                
                
            } else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            } else{
                
            }
        });
        $A.enqueueAction(action);
        }
      }
   
    
})