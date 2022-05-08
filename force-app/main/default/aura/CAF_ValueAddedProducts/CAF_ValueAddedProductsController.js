({
    openBlock4AddNewVap: function (component, event, helper) {
        component.set("v.showYesNoDialog",false);	
        component.set("v.accProductRelId",'');	
        //Added by RAJESH START	
        var selectedOpt = event.getSource().get("v.label");	
        var vapsProductOptionsAll = component.get("v.vapsProductOptionsAll");	
        if(selectedOpt == 'Yes'){	
            var vapsProductOptions = [];	
            for (var i in vapsProductOptionsAll) {	
                if(vapsProductOptionsAll[i].label.includes('MBW') || vapsProductOptionsAll[i].label.includes('Warranty')){	
                    vapsProductOptions.push(vapsProductOptionsAll[i]);	
                }	
            }	
            component.set("v.vapsProductOptions", vapsProductOptions);	
        }else{	
            var vapsProductOptions = [];	
            for (var i in vapsProductOptionsAll) {	
                if(!vapsProductOptionsAll[i].label.includes('MBW') && !vapsProductOptionsAll[i].label.includes('Warranty')){	
                    vapsProductOptions.push(vapsProductOptionsAll[i]);	
                }	
            }	
            component.set("v.vapsProductOptions", vapsProductOptions);	
        }	
        //Added by RAJESH END
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);
        
        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes."
            });
            toastEvent.fire();
        } else {
            component.set("v.openNewVapBlockValue", "Yes");
        }
    },
    doInit: function (component, event, helper) {
        //debugger;var recordId 	= helper.loadPriorApplicationId(component, event, helper);
        var recordId = component.get("v.recId");
        helper.fetchVAPs(component, event, helper, recordId);
        
        if ($A.util.isEmpty(component.get("v.vapsProductOptions"))) {
            helper.loadVAPsProducts(component, event, helper);
        }
        
        $A.get("e.force:refreshView").fire();
    },
    handleRowAction: function (cmp, event, helper, recId) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        var recId = row.Id; //'00k3N000006lsaxQAA';
        
        switch (action.name) {
            case "edit":
                helper.fetchVAP2Edit(cmp, event, helper, recId);
                cmp.set("v.openNewVapBlockValue", "Yes");
                
                break;
            case "delete":
                cmp.set("v.recordId", recId);
                cmp.set("v.showConfirmDialog", "true");
                break;
        }
    },
    btnSave: function (component, event, helper) {
        //debugger;
        var isSumInsuredGT15L = component.get("v.isSumInsuredGT15L");	
        if(isSumInsuredGT15L){	
            alert('Sum insured should be less than 1500000');	
            return;	
        }
        component.set("v.showSpinner", true);
        var msg = "";
        var err = 0;
        var oppId = component.get("v.oppId");
        var recId = component.get("v.recId");
        var vapId = component.get("v.vapId");
        var vendorCode = component.get("v.vendorCode");
        var productNameAndCode = component.get("v.productNameAndCode");
        var insuranceCompany = component.get("v.insuranceCompany");
        var numberOfweeksCoverSelected = component.get("v.numberOfweeksCoverSelected");
        var randValuePerWeek = component.get("v.randValuePerWeek");
        var VAPpremium = component.get("v.VAPpremium");
        var selectedAccount = component.get("v.selectedAccount");
        //alert(productNameAndCode);
        if (vendorCode == "") {
            err++;
            msg += "Enter Vendor Code<br/>";
        }
        if (insuranceCompany == "") {
            err++;
            msg += "Enter Insurance Companyt<br/>";
        }
        if (numberOfweeksCoverSelected == "") {
            err++;
            msg += "Enter number of weeks cover selected<br/>";
        }
        if (randValuePerWeek == "") {
            err++;
            msg += "Enter Rand Value Per Week<br/>";
        }
        if (VAPpremium == "") {
            err++;
            msg += "Enter VAP Premium<br/>";
        }
        
        if (err == 0) {
            var action = "";
            
            if (vapId == "") {
                action = component.get("c.addVAP");
                action.setParams({
                    oppId: oppId,
                    recordId: recId,
                    vendorCode: vendorCode,
                    productNameCode: productNameAndCode,
                    insuranceCompany: insuranceCompany,
                    numberOfweeksCoverSelected: numberOfweeksCoverSelected,
                    randValuePerWeek: randValuePerWeek,
                    VAPpremium: VAPpremium,
                    selectedAccount:''+selectedAccount
                });
            } else {
                action = component.get("c.updateVAP");
                action.setParams({
                    oppId: oppId,
                    recordId: vapId,
                    vendorCode: vendorCode,
                    productNameCode: productNameAndCode,
                    insuranceCompany: insuranceCompany,
                    numberOfweeksCoverSelected: numberOfweeksCoverSelected,
                    randValuePerWeek: randValuePerWeek,
                    VAPpremium: VAPpremium,
                    selectedAccount:''+selectedAccount
                });
            }
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                var extrasVal = response.getReturnValue();
                
                if (state === "SUCCESS") {
                    var showInsuranceCompany = component.get("v.showInsuranceCompany");
                    if(!showInsuranceCompany && vapId ==''){
                        helper.createJunctionRecord(component, event, helper);
                    }
                    msg = "Saved Successfully";
                    helper.fetchVAPs(component, event, helper, recId);
                    $A.enqueueAction(component.get("c.btnCancel"));
                    helper.successMsg(msg);
                } else {
                    helper.errorMsg(msg);
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.errorMsg(msg);
        }
        component.set("v.showSpinner", false);
    },
    btnCancel: function (component, event, helper) {
        component.set("v.openNewVapBlockValue", "No");
        component.set("v.vapId", "");
        component.set("v.vendorCode", "");
        
        component.set("v.productNameCode", "");
        component.set("v.productNameAndCode", "");
        component.set("v.insuranceCompany", "");
        component.set("v.numberOfweeksCoverSelected", "");
        component.set("v.randValuePerWeek", "");
        component.set("v.VAPpremium", "");
        component.set("v.accProductRelId", "");
    },
    callChildMethodVaps: function (component, event, helper) {
        var params = event.getParam("arguments");
        console.log("recordId>>" + params.appId);
        helper.fetchVAPs(component, event, helper, params.appId);
    },
    
    handleProductChange: function (component, event, helper) {
        var productNameCode = event.getSource().get("v.value");
        console.log('productNameCode '+productNameCode);
        var productRecord = component.get("v.vapsProductMap")[productNameCode];
        console.log('productRecord '+JSON.stringify(productRecord));
        var vapsProductOptions = component.get("v.vapsProductOptions");
        console.log('vapsProductOptions '+JSON.stringify(vapsProductOptions));
        var selectedProductNameCode = '';
        for(var i in vapsProductOptions){
            if(vapsProductOptions[i].value == productNameCode){
                selectedProductNameCode = vapsProductOptions[i].label;
            }
        }
        console.log('selectedProductNameCode '+selectedProductNameCode);
        console.log('productNameCode '+productNameCode);
        if(selectedProductNameCode.includes('Dealer Split Payment Warranty')){
            component.set("v.showInsuranceCompany",false);
        }else{
            component.set("v.showInsuranceCompany",true);
        }
        var oppLineId = component.get("v.recId");	
        helper.getVAPPremium(component, event,productNameCode,oppLineId);
        console.log(' productRecord '+JSON.stringify(productRecord));
        if (!$A.util.isEmpty(productRecord)) {
            component.set("v.vendorCode", productRecord.Scheme_Code__c);
            component.set("v.productNameAndCode", productRecord.Name + " - " + productRecord.ProductCode);
            component.set("v.insuranceCompany", productRecord.Description);
        } else {
            component.set("v.vendorCode", null);
            component.set("v.productNameAndCode", null);
            component.set("v.insuranceCompany", null);
        }
    },
    handleAccChange: function (component, event, helper) {
        var selectedAcc = event.getSource().get("v.value");
        //alert(selectedAcc);
        if(selectedAcc !=''){
            helper.fetchAccData(component, event,selectedAcc);
        }else{
            component.set("v.vendorCode",'');
        }
    },
    handleAccountProductRelationshipSuccess: function (component, event, helper) {
        /*var record = event.getParam("response");
        var myRecordId = record.id;
        //alert(myRecordId);
        component.set("v.accProductRelId",myRecordId);*/
        component.set("v.selectedAccount",'');
    },
    showYesNoDialog : function (component, event, helper) {	
        var dataList = component.get("v.dataList");	
        var flag = false;	
        for(var i in dataList){	
            if(!dataList[i].Product_name_Product_code__c.includes('MBW') && !dataList[i].Product_name_Product_code__c.includes('Warranty')){	
                flag = true;    	
            }	
        }	
        if(flag){	
            component.set("v.openNewVapBlockValue", "Yes");	
            var vapsProductOptionsAll = component.get("v.vapsProductOptionsAll");	
            var vapsProductOptions = [];	
            for (var i in vapsProductOptionsAll) {	
                if(!vapsProductOptionsAll[i].label.includes('MBW') && !vapsProductOptionsAll[i].label.includes('Warranty')){	
                    vapsProductOptions.push(vapsProductOptionsAll[i]);	
                }	
            }	
            component.set("v.vapsProductOptions", vapsProductOptions);	
        }else{	
            component.set("v.showYesNoDialog",true);   	
        }
    }
        
    });