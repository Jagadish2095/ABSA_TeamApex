({
	doInit : function(component, event, helper) {
        
        var opts = [];
        
		var accountId = component.get("v.clientAccountIdFromFlow");
        console.log('accountId--'+accountId);
        var action = component.get("c.getBankerName");
        action.setParams({
            accountId : accountId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('response state---'+state);
            
            if (component.isValid() && state === "SUCCESS") {
                
                console.log('response ---'+response);
                
                var responseBean = JSON.parse(response.getReturnValue());
                console.log('Service response ' +  responseBean);
                console.log('message---'+JSON.stringify(responseBean));
                console.log('length ' + responseBean);
                if(responseBean != null){ 
                    if(responseBean.length > 0){
                        for(var i = 0; i < responseBean.length; i++){
                            if(responseBean[i].role == 'Business Banker' && responseBean[i].name != ''){
                                opts.push({
            						class: "optionClass",
            						label: responseBean[i].name + '(Business Banker)',
            						value: responseBean[i].email
        							});
                                component.set('v.name' , responseBean[i].name);
                                console.log('Email ****************** ' + component.get("v.emailAddress"));
                            }
                        }
                        component.set("v.notifyBankerOptions" , opts);
                    }else{
                        var toast = helper.getToast('error', 'Something went wrong! CIF not linked to a banker','Error');
                        toast.fire();
                        component.set("v.isBanker" , true);
                    }
                    
                    
                }else{
                    var toast = helper.getToast('error', 'Something went wrong! Service issue','Error');
                    toast.fire();
                }
              }
            
        });
        
        
        $A.enqueueAction(action); 
	},
    onItemSubmit: function(component, event, helper){
       var productName = component.find("Product").get("v.value");
       console.log("Product Name " + productName);
       var table = document.getElementById("myTable");
  	   var row = table.insertRow(0);
       var cell1 = row.insertCell(0);
       var cell2 = row.insertCell(1);
       
  	   cell1.innerHTML = productName;
       var button = document.createElement('input');

       // set the attributes.
       button.setAttribute('type', 'button');
       button.setAttribute('value', '-');
       button.onclick = function(){table.deleteRow(button.parentNode.parentNode.rowIndex);};
  	   cell2.appendChild(button);
    },
    // function to delete a row.
    removeRow : function(oButton) {
        
        var empTab = document.getElementById('myTable');
        empTab.deleteRow(oButton.parentNode.parentNode.rowIndex); // buttton -> td -> tr
    },
    bankerNotify : function(component,events,helper){
        var notifyBankerCheck = component.find("notifyBankerCheck").get("v.checked");
        if(notifyBankerCheck){
            component.set("v.notifyBanker" , true);
            console.log('Text ----> ' + component.find("myBankerselection").get("v.Text"));
            console.log('Value ----> ' + component.find("myBankerselection").get("v.value"));
            
        }else{
            component.set("v.notifyBanker" , false);
        }

        
    },
    closeCase : function(component,events,helper){
        helper.showSpinner(component);
        helper.updateCase(component);
        
        var notifyBankerCheck = component.find("notifyBankerCheck").get("v.checked");
        
    	if(notifyBankerCheck){
        	var action = component.get('c.sendEmail');

        	var caseId = component.get('v.caseRecordId');
        	var email = '';
        	var name = component.get('v.name');
        	var templateName = '';
        	var bankerAddress = component.find("myBankerselection").get("v.value");
        
        	
        
        action.setParams({
            "emailAddress" : email,
            "caseRecordId" : caseId,
            "name" : name,
            "templateName" : '',
            "bankerEmail":bankerAddress,
            "balance": '',
            "accountNumber": '',
            "flowplstCardNumbers": '',
            "jsonResponseString": '',
            "templateAttrVal": ''
		});
		
        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			
            if (state === "SUCCESS") {
                var toast = helper.getToast("Success", "Case closed successfully", "Success");
                toast.fire();
				$A.get('e.force:refreshView').fire();
                helper.hideSpinner(component);
            } else if (state === "ERROR") {
                helper.hideSpinner(component);
				var toast = helper.getToast("Error", "There was an error when sending an email to a banker", "error");
			
                toast.fire();
                
            }
        }));

       
            $A.enqueueAction(action);
        }else{
            $A.get('e.force:refreshView').fire();
            helper.hideSpinner(component);
        }
    },
    
    
    

})