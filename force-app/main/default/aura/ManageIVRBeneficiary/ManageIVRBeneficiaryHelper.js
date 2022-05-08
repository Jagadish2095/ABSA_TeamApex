({
    updateBeneficiary : function(component, event, helper) {
        
        var updateData = component.get('v.updateData');
        var updateAddBen = component.get('v.updateAddBen');
        
        
        if(updateData === true){
            var action = component.get("c.updateBeneficiary");
            var IVR = component.get('v.IVR');
            if(updateAddBen === true){
                
                var pagList = component.get('v.instructionList');
                var pagListSize = pagList.length;
                component.set('v.tieb',pagList[pagListSize - 1].tieb);
                component.set('v.instrNo',pagList[pagListSize - 1].instrNo);
                
            }
            component.set('v.updateAddBen',false);
            if(component.get('v.refreshUpdate')===true){
                component.set('v.branchCode',component.get("v.selectedBranchCodeId"));
                console.log('Branch Code ::'+component.get("v.selectedBranchCodeId"));
            }
            action.setParams({
                beneficiaryName: component.get('v.name'),
                trgAccNumber :component.get('v.accountNumber'),
                trgAccType : component.get('v.accountType'),
                srcAcc : component.get('v.selectedAccountNumberToFlow'),
                srcStmtRef : component.get('v.ownReference'),
                trgStmtRef : component.get('v.recipientRef'),
                srcAccType : component.get('v.selectedProductValue'),
                clientAccountId : component.get('v.clientAccountIdFromFlow'),
                ivrCustNo : component.get('v.IVR'), 
                tieb : component.get('v.tieb'),
                instrNo : component.get('v.instrNo'),
                trgBranchCode : component.get('v.branchCode')
                
            });
            
            console.log('Tieb : '+component.get('v.tieb')+'  ivrCustNo : '+component.get('v.IVR')+ '  name : '+component.get('v.name')+
                       '   Branch code '+component.get('v.branchCode'));
            component.set('v.showSpinner',true);
            component.set("v.updateBeneFiciaryModal", false);
            component.set("v.AddBen", false);
            action.setCallback(this, function(response) {
                var state = response.getState(),
                    respStr = JSON.parse(response.getReturnValue());
                if (state === "SUCCESS") {
                    if (respStr != null){
                        component.set('v.showSpinner',false);
                        if (respStr.respDesc === "SUCCESSFUL PROCESS"){
                            console.log("IVR on the system : "+ respStr.ivrNominate);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "Beneficiary succesfully added or updated",
                                "type":"Success"           
                            });
                            helper.doRefresh(component, event, helper);
                            toastEvent.fire();   
                        }
                        else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Errror!",
                                "message": respStr.respDesc,
                                "type":"Error"           
                            });
                            component.set('v.showSpinner',false);
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
                    component.set('v.showSpinner',false);
                    toastEvent.fire();
                }  
                
                 component.set('v.branchCode','');
                 component.set('v.selectedBankName','');
            });
            $A.enqueueAction(action);
            
        }
        else{
            component.set('v.showSpinner',false);
            console.log("Retrieved Data");
        }
    },
    doRefresh : function(component, event, helper){
        component.set('v.updateData',false);
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    }
})