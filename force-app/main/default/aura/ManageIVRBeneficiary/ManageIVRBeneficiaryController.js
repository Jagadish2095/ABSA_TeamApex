({
    doInit : function(component, event, helper) {
        
        var opts = [];
        
        
        opts.push({
            class: "optionClass",
            label: "Current/Cheque",
            value: "02"
        });
        opts.push({
            class: "optionClass",
            label: "Savings",
            value: "01"
        });
        
        component.set("v.targetAccTypeoptions" , opts);
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        var selectedAccountValue = component.get('v.selectedAccountNumberToFlow');
        var pageSize = component.get("v.pageSize");
        
        console.log('clientId: ' + clientAccountId);
        console.log('selectedAccountNumber: ' + selectedAccountValue);
        
        var action = component.get("c.mblistinstrpersourceacc");
        action.setParams({
            clientAccountId: clientAccountId,srcAcc: selectedAccountValue
        });
        
        component.set('v.showSpinner',true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('Response : '+response.getReturnValue());
                if(response.getReturnValue() != null){
                    console.log('Update Ben Value : '+component.get('v.updateAddBen'));
                    var resp = response.getReturnValue();
                    if(resp.includes('uniqueEft')){
                        var respObj = JSON.parse(response.getReturnValue());
                        if(respObj != null){
                            component.set('v.showSpinner',false);
                            component.set("v.instructionList", respObj);
                            component.set("v.totalSize", component.get("v.instructionList").length);
                            component.set("v.start",0);
                            component.set("v.end",pageSize-1);
                            var instructionList = component.get("v.instructionList");
                            var lengthComp = component.get("v.instructionList").length;
                            var paginationList = [];
                            for(var i=0; i< pageSize; i++){
                                paginationList.push(respObj[i]);
                                
                            }
                            component.set("v.paginationList", paginationList);
                            helper.updateBeneficiary(component, event, helper);
                            component.set('v.showSpinner',false);
                        }
                    }
                    
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": resp,
                            "type":"error"           
                        });
                        component.set('v.showSpinner',false);
                        toastEvent.fire(); 
                        
                    }
                }
                else{
                    component.set('v.showSpinner',false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'No beneficiary list ' ,
                        "type":"error"
                    });
                }
            }
            else{
                component.set('v.showSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": 'UNSUCCESSFUL ' ,
                    "type":"error"
                });
                component.set('v.showSpinner',false);
                toastEvent.fire();
            }  
            
            
        });
        $A.enqueueAction(action);
        
        
    } ,
    
    handleBrachCodeComponentEvent:function(component, event, helper){
        
        //Event handler to get branch code from child comp
        var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.branchCode" , pselectedBranchCodeGetFromEvent);  
        
        
    },
    
    onTargetAccTypeChange :function(component, event, helper){
        console.log('target change acc type :'+ component.get("v.accountType"));
        
    },
    
    handleClickEdit : function(component, event, helper){
        var instrNo = event.getSource().get("v.value");
        console.log('Instruction number : '+ instrNo);
    },
    
    addNewBeneficiary : function(component, event, helper){
        
        var errorExist = false;
        var beneficiaryList =  component.get("v.instructionList");
        console.log('Beneficiriary Lenghth ' + beneficiaryList.length);
        var IVR_Number = component.get("v.IVR");
        for(var i = 0; i < beneficiaryList.length; i++){
            //console.log('Beneficiriary Lenghth ' + beneficiaryList[i].length);
            if(IVR_Number == beneficiaryList[i].ivrNominate){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "IVR number already exists",
                    "type":"error"           
                });
                errorExist = true;
            }
            else{
                console.log('does not exist' +IVR_Number);
            }
        }
        
        if(component.get('v.branchCode')== null || component.get('v.branchCode')==''|| component.get('v.branchCode')=='0000000')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Branch code or Bank Name can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        if(component.get('v.name')== null || component.get('v.name')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Beneficiary Name can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.IVR')== null || component.get('v.IVR')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "IVR  can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.recipientRef')== null || component.get('v.recipientRef')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Recipient Reference can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.accountType')== null || component.get('v.accountType')=='' || component.get('v.accountType')=='Select type')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please seelect account type ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.ownReference')== null || component.get('v.ownReference')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Own Reference can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.accountNumber')== null || component.get('v.accountNumber')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account number can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        if (errorExist){
           // console.log("There's  error");
            toastEvent.fire();
        }
        
        else{
            console.log('IVR Number does not exist'); 
            var action = component.get("c.addBeneficiary");
            action.setParams({
                beneficiaryNameP: component.get('v.name'),
                targetAccP :component.get('v.accountNumber'),
                productTypeP : component.get('v.accountType'),
                accountNumberP : component.get('v.selectedAccountNumberToFlow'),
                accountTypeP : component.get('v.selectedProductValue'),
                beneficiaryReferenceP : component.get('v.recipientRef'),
                ownReferenceP : component.get('v.ownReference'), 
                branchCodeP : component.get('v.branchCode')
                
            });
            component.set('v.showSpinner',true);
            component.set("v.updateBeneFiciaryModal", false);
            component.set("v.AddBen", false);
            
            
            action.setCallback(this, function(response) {
                var state = response.getState(),
                    respStr = JSON.parse(response.getReturnValue());
                
                if (state === "SUCCESS") {
                    if (respStr != null){
                        if (respStr.respDesc === "SUCCESSFUL PROCESS"){
                            component.set('v.showRefresh',true);
                            component.set('v.updateData',true);
                            component.set("v.updateAddBen",true);
                            // helper.updateBeneficiary(component, event, helper);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "Beneficiary succesfully added ",
                                "type":"Success"           
                            });
                            toastEvent.fire();
                            //New addition
                            //component.set('v.branchCode','');
                            //component.set('v.selectedBankName','');
                        }
                        else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Errror!",
                                "message": respStr.respDesc,
                                "type":"Error"           
                            });
                            toastEvent.fire();   
                        }
                    }
                    component.set('v.showSpinner',false);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'UNSUCCESSFUL ' ,
                        "type":"error"
                    });
                    toastEvent.fire();
                }  
                
                
            });
            $A.enqueueAction(action);
        }
        
    },
    
    
    
    
    openModel : function(component,event,helper){
        console.log('Adding new Beneficiary');
        console.log('Product type : '+component.get("v.selectedProductValue"));
        
        component.set("v.AddBen",true);
    },
    
    cancel : function(component, event, helper) {
        
        component.set("v.updateBeneFiciaryModal", false);
        component.set("v.AddBen", false);
        
    },
    onSelectChange : function(component, event, helper) {
        
        var selected = component.find("records").get("v.value");
        console.log('Selected Value' + selected);
        var paginationList = [];
        var instructionList = component.get("v.instructionList");
        console.log('Instruction List' + instructionList);
        for(var i=0; i< selected; i++)
        {
            if(instructionList[i] != null){
                paginationList.push(instructionList[i]);
            }
        }
        component.set("v.paginationList", paginationList);
        
    },
    first : function(component, event, helper){
        var notificationList = component.get("v.instructionList");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        for(var i=0; i< pageSize; i++){
            paginationList.push(notificationList[i]);
        }
        component.set("v.paginationList", paginationList);
    },
    last : function(component, event, helper){
        var notificationList = component.get("v.instructionList");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        for(var i=totalSize-pageSize+1; i< totalSize; i++){
            paginationList.push(notificationList[i]);
        }
        component.set("v.paginationList", paginationList);
        component.set("v.start" , 1);
    },
    
    next : function(component, event, helper){
        var notificationList = component.get("v.instructionList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(notificationList.length > end){
                paginationList.push(notificationList[i]);
                counter ++ ;
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.paginationList", paginationList);
        
    },
    
    previous : function(component, event, helper){
        var notificationList = component.get("v.instructionList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                paginationList.push(notificationList[i]);
                counter ++;
            }
            else {
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);
        component.set("v.paginationList", paginationList);
    },
    
    
    selectedItem : function(component,event, helper){
        console.log('retrieving selected');
        var beneficiaryList =  component.get("v.instructionList");
        console.log('Beneficiary length '+ beneficiaryList.length);
        var selectedBeneficiary;  
        var ctarget = event.currentTarget.dataset;
        var id_str = ctarget.value;
        
        
        
        for(var i = 0; i < beneficiaryList.length; i++){
            if(beneficiaryList[i].instrRefName == id_str){
                component.set("v.name",beneficiaryList[i].instrRefName); 
                component.set("v.selectedBankNameUpd",beneficiaryList[i].trgInstCode); 
                component.set("v.accountNumber",beneficiaryList[i].trgAcc);
                component.set("v.accountType",beneficiaryList[i].trgAccType); 
                component.set("v.IVR",beneficiaryList[i].ivrNominate);
                component.set("v.branchCode",beneficiaryList[i].trgBusinessCode);
                component.set("v.tieb",beneficiaryList[i].tieb);
                component.set("v.instrNo",beneficiaryList[i].instrNo);
            }
        }
        /*if(component.get("v.accountType")=='CQ' || component.get("v.accountType")== '02'){
            component.set("v.accountType",'Current/Cheque');
        }*/
        
        //Added piece starts here
        var getBenListAction = component.get('c.getBankIdByName');
        var bankNameVal = component.get('v.selectedBankNameUpd');
        
        getBenListAction.setParams({
            "bankName" : bankNameVal
        });
        
        getBenListAction.setCallback(this, $A.getCallback(function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                       
                if(result != null) {
                    //Set Bank Name and Branch
                    component.set("v.selectedBankId",result.Bank__c);
                    component.set("v.selectedBranchCodeId", result.Id);
                    component.set("v.selectedBranchCodeName", result.Name);
                } else {
                    //Set Bank Name and Branch
                    component.set("v.selectedBankId",null);
                    component.set("v.selectedBranchCodeId", null);
                    component.set("v.selectedBranchCodeName", null);
                }

               // helper.hideSpinner(component);
                
            } else if (state === "ERROR") {
                
               /* var toast = helper.getToast("Error", "There was an error retrieving the list of Bank Accounts", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();*/
            }
        }));
        
        $A.enqueueAction(getBenListAction);
        
        //Added piece ends here
        
        component.set("v.updateBeneFiciaryModal", true); 
        
    },
    actionUpdate : function(component,event, helper){
        var errorExist = false;
        var beneficiaryList =  component.get("v.instructionList");
        console.log('Beneficiriary Lenghth ' + beneficiaryList.length);
        console.log('Branch code : '+component.get('v.branchCode')+' Bank name :'+component.get('v.selectedBankId'));
        
        //selectedBankId
        
        if(component.get('v.selectedBranchCodeId')== null || component.get('v.selectedBranchCodeId')=='' ||component.get('v.selectedBranchCodeId')=='0000000 ')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Branch code  can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        if(component.get('v.name')== null || component.get('v.name')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Beneficiary Name can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.selectedBankId')== null || component.get('v.selectedBankId')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Bank Name can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.recipientRef')== null || component.get('v.recipientRef')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Recipient Reference can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.ownReference')== null || component.get('v.ownReference')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Own reference can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        
        if(component.get('v.accountNumber')== null || component.get('v.accountNumber')=='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account number can not be blank ",
                "type":"error"           
            });
            errorExist = true;
        }
        if (errorExist){
            toastEvent.fire();
        }
        
        else{
            
        component.set('v.updateData',true); 
        component.set('v.showRefresh',true);
        component.set('v.updateAddBen',false);
        component.set('v.refreshUpdate',true);
        helper.updateBeneficiary(component, event, helper);
            
        }
        
        
    },
    actionDelete : function(component,event, helpers){
        
        var actionDelete = component.get("c.deleteBeneficiary");
        component.set('v.showRefresh',true);
        actionDelete.setParams({
            clientAccountId: component.get("v.clientAccountIdFromFlow"),
            tieb : component.get("v.tieb"),
            instrNo : component.get("v.instrNo")
            
        });
        component.set("v.updateBeneFiciaryModal", false);
        component.set('v.showSpinner',true);
        actionDelete.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Response : '+response.getReturnValue());
            if (state === "SUCCESS") {
                if(response.getReturnValue() !=null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": response.getReturnValue() ,
                        "type":"Success"           
                    });
                    toastEvent.fire();
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There was an error when removing beneficiary",
                        "type":"Error"           
                    }); 
                    toastEvent.fire();
                }
                
            }
            component.set('v.showSpinner',false);
        });
        $A.enqueueAction(actionDelete);
        
    },
    
    closeCase : function(component, event, helper){
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