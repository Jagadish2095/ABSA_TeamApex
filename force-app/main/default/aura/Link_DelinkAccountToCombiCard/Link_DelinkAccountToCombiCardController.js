({
    doInit : function(component, event, helper) {
        debugger;
        helper.getAccountDetailsHelper(component, event, helper);
        
       /*if(component.get("v.selectedProductValue") != 'CO'){
             var toastEvent = $A.get("e.force:showToast");
         toastEvent.setParams({
                "title": "Error!",
                "message": "Please Select Combi Card Product!",
                "type":"error"
            });
            toastEvent.fire(); 
            component.set("v.invalidProduct", true);
        }else{
            component.set("v.invalidProduct", false);            
        }*/
        
        
        var action = component.get("c.getAccountDetails");
        var caseId = component.get("v.recordId");
        console.log('clientAccountId ******'+ caseId);
        action.setParams({caseId:caseId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                console.log('--------getSourceAccountDetails-------'+JSON.stringify(respObj));
                component.set('v.responseList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                for(var key in respObj){
                    console.log('==='+respObj[0].productType);
                    if (!prodList.includes(respObj[key].productType) && respObj[key].productType != 'CO' ) {
                        prodList.push(respObj[key].productType);
                    } 
                    if(respObj[key].productType == 'CO')	 component.set('v.cbcardRecord',respObj[key]);
                }
               // component.set('v.prodTypesList',prodList);
                
                
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
        
        component.set('v.columns', [
            {label: 'Account Number', fieldName: 'accountNumber', type: 'text'},
            {label: 'Account Name', fieldName: 'accountName', type: 'text'},
            {label: 'Product', fieldName: 'product', type: 'text'},
            {label: 'Account Type', fieldName: 'accountType', type: 'text'},
            {label: 'Linked', fieldName: 'linked', type: 'text'}
        ]);  
        
        
    }, 
    getSelectedName: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedRows",selectedRows);
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            if(selectedRows.length > 0){
                var selectedRow=selectedRows[i];
                
                
            }
        }
        
    },
    getAccountNumbers : function(component, event, helper) {
        component.set("v.linkSectionEnabled",false);
        component.set('v.actionItem','');
        var selectedProdType = component.get('v.selectedProductValue');
        var ViewDebitList =[];
        var respObj = component.get('v.responseList');
        console.log(respObj);
        var acc = [];
        
        for(var key in respObj){
            if(respObj[key].productType == selectedProdType){
                //component.set('v.accWrapper[0].productType',respObj[key].productType);
                //component.set("v.tableHeading",respObj[key].product);
                acc.push(respObj[key].oaccntnbr);
                ViewDebitList.push({accountNumber:respObj[key].oaccntnbr, accountName:component.get("v.fullName"),product:respObj[key].product ,accountType:respObj[key].productType,linked:''});
            }
        }
        
        component.set('v.accNumList',acc);
        component.set('v.selectedAccountNumber','');
        component.set('v.ViewDebitList',ViewDebitList);  
    },
    onAccountSubmit: function(component, event, helper) {  
        component.set("v.linkSectionEnabled",false);
        component.set('v.actionItem','');
        if(component.get('v.selectedAccountNumber') == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Select Account!",
                "type":"error"
            });
            toastEvent.fire(); 
        }else  if(component.get('v.cbcardRecord').length > 0){
            component.set("v.linkSectionEnabled",true);
           // component.find("cardNumber").set("v.value", component.get('v.cbcardRecord')[0].oaccntnbr);
            component.find("clientName").set("v.value", component.get('v.fullName'));
            component.set('v.actionItem','');
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "No Combi card for selected Account.",
                "type":"error"
            });
            toastEvent.fire(); 
        }
    },
    updateTableList: function(component, event, helper) {
        
        var ViewDebitList =[];
        var respObj = component.get('v.responseList');
        if(component.get('v.actionItem') == 'Link'){            
            for(var key in respObj){
                if(respObj[key].oaccntnbr ==  component.get('v.selectedAccountNumber')){
                    ViewDebitList.push({accountNumber:respObj[key].oaccntnbr, accountName:component.get("v.fullName"),product:respObj[key].product ,accountType:respObj[key].productType,linked:''});
                }
            }            
        } else if(component.get('v.actionItem')  == 'DeLink'){
            for(var key in respObj){
                ViewDebitList.push({accountNumber:respObj[key].oaccntnbr, accountName:component.get("v.fullName"),product:respObj[key].product ,accountType:respObj[key].productType,linked:''});
            }  
        }
        debugger;
        component.set('v.ViewDebitList',ViewDebitList); 
    },
    
    linkDelinkUpdate: function(component, event, helper) {
        
        helper.linkDelinkUpdateHelper(component, event, helper);
    },
    showModal: function(component, event, helper) {
        component.set('v.isModalShow',true);
    },
    closeModal: function(component, event, helper) {
        component.set('v.isModalShow',false);
    },
    
})