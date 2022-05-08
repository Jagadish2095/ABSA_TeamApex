({
    fetchVAP2Edit: function (cmp, event, helper, recId) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getVAP2Edit");
        action.setParams({
            recId: recId
        });
        //debugger;
        action.setCallback(this, function (response) {
            var state = response.getState();
            var vap = response.getReturnValue();
            console.log('vap 12 '+JSON.stringify(vap));
            var OpportunityLineItem = vap.OpportunityLineItem;
            console.log("extrasVal: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                cmp.set("v.vapId", OpportunityLineItem.Id);
                cmp.set("v.vendorCode", OpportunityLineItem.Vendor_Code__c);
                //alert(OpportunityLineItem.Product_name_Product_code__c.split('-')[1].trim());
                cmp.set("v.productNameAndCode", OpportunityLineItem.Product_name_Product_code__c);
                //Added by Rajesh START
                //alert(vap.PRODUCTCODE);
                cmp.find("productNameCodePicklist").set("v.value",vap.PRODUCTCODE.trim());
                if(OpportunityLineItem.Product_name_Product_code__c.includes('Dealer Split Payment Warranty')){
                    cmp.set("v.showInsuranceCompany",false);
                }else{
                    cmp.set("v.showInsuranceCompany",true);
                }
                if(vap.ACCOUNTPRODRELATIONID != null && vap.ACCOUNTPRODRELATIONID != undefined ){
                    cmp.set("v.accProductRelId",vap.ACCOUNTPRODRELATIONID);
                }else{
                    cmp.set("v.accProductRelId",'');
                }
                //Added by Rajesh END
                cmp.set("v.insuranceCompany", OpportunityLineItem.Insurance_Company__c);
                cmp.set("v.numberOfweeksCoverSelected", OpportunityLineItem.Number_of_weeks_cover_selected__c);
                cmp.set("v.randValuePerWeek", OpportunityLineItem.Rand_value_per_week__c);
                cmp.set("v.VAPpremium", OpportunityLineItem.VAP_Premium__c);
            }
        });
        $A.enqueueAction(action);
        cmp.set("v.showSpinner", false);
    },
    confirmDelete: function (cmp, event, helper, recId) {
        component.set("v.showConfirmDialog", true);
    },

    fetchVAPs: function (component, event, helper, recordId) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getVAPs");
        var oppId = component.get("v.oppId");
        action.setParams({
            oppId: oppId,
            recordId: recordId
        });

        action.setCallback(this, function (response) {
            //debugger;
            var state = response.getState();
            var extrasVal = response.getReturnValue();

            if (state === "SUCCESS") {
                var actions = [
                    { label: "Edit", name: "edit" },
                    { label: "Delete", name: "delete" }
                ];

                component.set("v.columns", [
                    { label: "Vendor Code", fieldName: "Vendor_Code__c", type: "text" },
                    { label: "Product Name", fieldName: "Product_name_Product_code__c", type: "text" },
                    { label: "Insurance Company", fieldName: "Insurance_Company__c", type: "text" },
                    { label: "Number of weeks cover selected", fieldName: "Number_of_weeks_cover_selected__c", type: "text" },
                    { label: "Rand value per week", fieldName: "Rand_value_per_week__c", type: "text" },
                    { label: "VAP Premium", fieldName: "VAP_Premium__c", type: "text" },
                    { type: "action", typeAttributes: { rowActions: actions } }
                ]);

                var extrasSize = extrasVal.length;
                component.set("v.vaplength", extrasSize);
                component.set("v.dataList", extrasVal);

                //this.loadPriorApplicationId(extrasVal[extrasSize-1].Id);
            } else {
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    loadVAPsProducts: function (component, event, helper) {
        var action = component.get("c.getVAPsProduct2");

        action.setCallback(this, function (response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            var vapsProductMap = {};
            var vapsProductOptions = [];

            if (resp && state === "SUCCESS") {
                for (var i = 0; i < resp.length; i++) {
                    vapsProductMap[resp[i].ProductCode] = resp[i];
                    var option = {
                        label: resp[i].Name + ' - ' + resp[i].ProductCode,
                        value: resp[i].ProductCode
                    };
                    vapsProductOptions.push(option);
                }
                component.set("v.vapsProductMap", vapsProductMap);
                component.set("v.vapsProductOptions", vapsProductOptions);
                component.set("v.vapsProductOptionsAll", vapsProductOptions);
            } else {
            }
        });
        $A.enqueueAction(action);
    },

    successMsg: function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "success",
            title: "Success!",
            message: msg
        });
        toastEvent.fire();
    },

    errorMsg: function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: msg
        });
        toastEvent.fire();
    },
    createJunctionRecord: function (component, event, helper) {
        var selectedAccount = component.get("v.selectedAccount");
        var productNameCode = component.get("v.productNameCode");
        var vapsProductMap = component.get("v.vapsProductMap");
        console.log('selectedAccount '+selectedAccount);
        console.log('productNameCode '+productNameCode);
        //alert(vapsProductMap[productNameCode].Id);
        component.set("v.selectedProduct",vapsProductMap[productNameCode].Id);
        component.find("accProdRelationForm").submit();
    },
    fetchAccData: function (component, event, accId) {
        var action = component.get("c.queryAccountData");
        action.setParams({"accId":''+accId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resp = response.getReturnValue();
            //alert(state);
            if (state === "SUCCESS") {
                console.log('resp '+JSON.stringify(resp));
                if(resp != null && resp != undefined){
                    component.set("v.vendorCode",resp.Vendor_Code__c);
                     }	
            }else{	
                	
            }	
        });	
        $A.enqueueAction(action);	
    },	
    getVAPPremium: function (component, event, productName,oppLineId) {	
        var action = component.get("c.getVAPPremiumData");	
        action.setParams({	
            "productCode":productName,	
            "oppLineId":oppLineId	
        });	
        action.setCallback(this, function (response) {	
            var state = response.getState();	
            var resp = response.getReturnValue();	
            //alert(resp);	
            if (state === "SUCCESS") {	
                console.log('resp '+JSON.stringify(resp));	
                if(resp != null && resp != undefined){	
                    component.set("v.VAPpremium",resp.VAPPREMIUM);	
                    //alert(resp.SUMINSURED);	
                    if(resp.SUMINSURED > 1500000){	
                        //alert('Sum insured should be less than 1500000');	
                        component.set("v.isSumInsuredGT15L",true);	
                    }else{	
                        component.set("v.isSumInsuredGT15L",false);	
                    }
                }
            }else{
                
            }
        });
        $A.enqueueAction(action);
    }
});