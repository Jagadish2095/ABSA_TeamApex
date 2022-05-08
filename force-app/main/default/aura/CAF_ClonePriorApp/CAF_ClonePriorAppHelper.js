({
    getRowActions: function(component, row, cb) {
        var actions = [];        
        actions.push(
            { label: "Edit", name: "edit" },
            { label: "Duplicate", name: "duplicate", disabled: row.Case_Number__c != null },
            { label: "Delete", name: "delete" }
        );
        cb(actions);        
    },

    /*resetCheckBox: function (component, event, helper) {
        component.set("v.assetArticleVal", false);
        component.set("v.shortTermInsuranceVal", false);
        component.set("v.contractDetailsVal", false);
        component.set("v.contractExtrasVal", false);
        component.set("v.valueAddedProductsVal", false);
        component.set("v.landlordWaiverDetailsVal", false);
        component.set("v.dealerDetailsVal", false);
        component.set("v.structureVal", false);
        component.set("v.creditApplicationDetailsVal", false);
        component.set("v.productionInformationVal", false);        
    },*/
	createDuplicateApp: function (component, event, helper) {
        
        /*if (component.get("v.duplicateNo") == null){
            component.set("v.isOpen", true);
            this.warningMsg ('Please make sure to specify the no of duplicates!');  
        }*/
        //else{
        var asartVal = component.find("assetArticle").get("v.checked");
        var stiVal = component.find("shortTerm").get("v.checked");
        var contrDetVal = component.find("contractDet").get("v.checked");
        var contrExVal = component.find("contractExtra").get("v.checked");
        var valAddProdVal = component.find("valueAddedProd").get("v.checked");
        var landwDetVal = component.find("landLordWaiverDet").get("v.checked"); 
        var dealerDetVal = component.find("dealerDet").get("v.checked");
        var structVal = component.find("structure").get("v.checked");
        var credAppDetVal = component.find("creditAppDet").get("v.checked");
        var prodInfoVal = component.find("prodInfo").get("v.checked");
        var documentsVal = component.find("documents").get("v.checked");
			console.log('landwDetVal '+landwDetVal);
            component.set("v.showSpinner", true);

                    var action = component.get("c.duplicateApplication");
                        action.setParams({
                                appProdCAFId: component.get("v.appProdCafId"),
                                oppId: component.get("v.oId"),
                                assetArt: asartVal,
                                shortTerm: stiVal,
                                contrDet: contrDetVal,
                                contrExt: contrExVal,
                                valueAddProd: valAddProdVal,
                                landDetVal: landwDetVal,
                                dealerDet: dealerDetVal,
                                structure: structVal,
                                credAppDet: credAppDetVal,
                                prodInfo: prodInfoVal,
                            	documents:documentsVal,
                                NoOfDup: component.get("v.duplicateNo")
                        });
                    
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                            if (state === "SUCCESS") {
                                component.set("v.showSpinner", false);
                                component.set("v.isOpen", false);
                                this.successMsg (component, response.getReturnValue());
                                $A.get("e.force:refreshView").fire();
                                //location.reload();
                                
                            }
                            else if (state === "ERROR") {
                                var errors = response.getError();
                                console.log('errors '+JSON.stringify(errors));
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {
                                            this.errorMsg (component, response.getReturnValue());
                                        }     
                                }
                            }  
                    });
                    $A.enqueueAction(action); 		
       // }		
	},
    successMsg: function (component, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "success",
            title: "Success!",
            message: msg
        });
        toastEvent.fire();
    },
    errorMsg: function (component, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: msg
        });
        toastEvent.fire();
    },
    warningMsg: function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "warning",
            title: "Warning!",
            message: msg
        });
        toastEvent.fire();
    }
})