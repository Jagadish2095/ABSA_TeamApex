({
    getAppPrdctCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRecId = response.getReturnValue();
                console.log("appPrdctCpfRecId: " + JSON.stringify(appPrdctCpfRecId));
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId);

                if(appPrdctCpfRecId.Is_VAT_facility_applicable__c == 'Yes' ){
                    // component.set("v.vatApplicableoptionGiven", 'Yes');
                    component.set("v.vatApplicableValues", 'Yes');
                }else if(appPrdctCpfRecId.Is_VAT_facility_applicable__c == 'No' ){
                    //component.set("v.vatApplicableoptionGiven", 'No');
                    component.set("v.vatApplicableValues", 'No');

                }
                if(appPrdctCpfRecId.Include_VAT_on_charges__c == 'Yes' ){
                    component.set("v.includeVATchargeoptionGiven", 'Y');
                    component.set("v.IsIncludeVAToncharges", true);
                }else if(appPrdctCpfRecId.Include_VAT_on_charges__c == 'No' ){
                    component.set("v.includeVATchargeoptionGiven", 'N');
                    component.set("v.IsIncludeVAToncharges", false);
                }
                if(appPrdctCpfRecId.Difference_clause_applicable__c == 'None' ){
                    //component.set("v.DifferenceclauseapplicableoptionGiven", 'None');
                    // component.set("v.showdifferenceclausefields", 'None');
                    component.set("v.DifferenceclauseapplicableValues", 'None');
                }else if(appPrdctCpfRecId.Difference_clause_applicable__c == 'Standard Clause' ){
                    // component.set("v.DifferenceclauseapplicableoptionGiven", 'Standard clause');
                    // component.set("v.showdifferenceclausefields",'Standardclause');
                    component.set("v.DifferenceclauseapplicableValues", 'Standard Clause');
                }else if(appPrdctCpfRecId.Difference_clause_applicable__c == 'Payout In Tranches' ){
                    //component.set("v.DifferenceclauseapplicableoptionGiven", 'Payoutintranches');
                    // component.set("v.showdifferenceclausefields",'Payoutintranches');
                    component.set("v.DifferenceclauseapplicableValues", 'Payout In Tranches');
                }
                if(appPrdctCpfRecId.Include_balance_on_existing_account__c == 'Yes' ){
                    component.set("v.IncludebalanceonexistingaccountoptionGiven", 'Y');
                    component.set("v.showIncludebalanceonexistingacc",'Yes');
                }else if(appPrdctCpfRecId.Include_balance_on_existing_account__c == 'No' ){
                    component.set("v.IncludebalanceonexistingaccountoptionGiven", 'N');
                    component.set("v.showIncludebalanceonexistingacc",'No');
                }
                if(appPrdctCpfRecId.Include_repayment_schedule__c == 'Yes' ){
                    component.set("v.IncluderepaymentscheduleoptionGiven", 'Y');
                }else if(appPrdctCpfRecId.Include_repayment_schedule__c == 'No' ){
                    component.set("v.IncluderepaymentscheduleoptionGiven", 'N');
                }
                if(appPrdctCpfRecId.Final_repayment_date__c == 'Date' ){
                    component.set("v.finalRepaymentDate", 'Date');
                }else if(appPrdctCpfRecId.Final_repayment_date__c == 'Date After First Drawdown' ){
                    component.set("v.finalRepaymentDate", 'Date After First Drawdown');
                }else if(appPrdctCpfRecId.Final_repayment_date__c == 'Date After Signature' ){
                    component.set("v.finalRepaymentDate", 'Date After Signature');
                }
                if(appPrdctCpfRecId.Prime_rate_margin__c == 'Plus per annum' ){
                    component.set("v.marginRate", 'Plus per annum');
                }else if(appPrdctCpfRecId.Prime_rate_margin__c == 'Minus per annum' ){
                    component.set("v.marginRate", 'Minus per annum');
                }else if(appPrdctCpfRecId.Prime_rate_margin__c == 'No variance' ){
                    component.set("v.marginRate", 'No variance');
                }
                var wasadesktopvaluationdone = appPrdctCpfRecId.Was_a_desktop_valuation_done__c;
                console.log('wasadesktopvaluationdone'+wasadesktopvaluationdone);
                if (wasadesktopvaluationdone == "No"){
                    component.set("v.renderfield", true);
                }
                else{
                    component.set("v.renderfield", false);
                }
                if(appPrdctCpfRecId.Other_amounts_included_in_total_facility__c !=null)
                component.set("v.otheramountsincludedintotalfacilityValues",appPrdctCpfRecId.Other_amounts_included_in_total_facility__c);

            }else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
            }
        });

        $A.enqueueAction(action);
    },

    getAppFinAccCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppFinAccfRec");
        var oppRecId=component.get("v.recordId");

        action.setParams({
            "oppId": component.get("v.recordId"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appFinAccRec = response.getReturnValue();
                console.log(":finn " + JSON.stringify(appFinAccRec));
                // var resultforId =appFinAccRec[0].Account_to_be_closed__c;
                //console.log(":4566 " +resultforId);
                component.set("v.newFacilityAccount",response.getReturnValue());
                /* if(appFinAccRec.Account_to_be_closed__c == 'Yes' ){
                    component.set("v.accounttobeclosedoptn", 'Yes');
                }else if(appFinAccRec.Account_to_be_closed__c == 'No' ){
                    component.set("v.accounttobeclosedoptn", 'No');
                }*/
            }else {
                console.log("Failed with state: " + JSON.stringify(appFinAccRec));
            }
        });

        $A.enqueueAction(action);
    },

    addAccount : function(component, event) {
        var facacountlist = component.get("v.newFacilityAccount");
        facacountlist.push({
            'sobjectType' : 'Application_Financial_Account__c',
            'Existing_Number__c' : '',
            'Existing_Account_Number__c' : '',
            'Outstanding_Balance__c' : '',
            'Balance_as_at__c' : '',
            'Account_to_be_closed__c' : 'No'
        });
        component.set("v.newFacilityAccount",facacountlist);
        component.set("v.showSpinner", false);
    },

    /*addNewAccount: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var items = component.get("v.newFacilityAccount");

        var action = component.get("c.getFacilityAccounts");

        action.setParams({
            oppId: oppId,
            itemNum: items == null ? 0 : items.length,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                var resultforId=JSON.parse(result);
                console.log('result '+result);
                console.log('resultforId '+resultforId);
				console.log('result '+resultforId.Id);
                if (result != null) {
                    items.push(JSON.parse(result));
                    component.set("v.newFacilityAccount", items);
					component.set("v.appFinAccRecId",resultforId.Id);
                    console.log("newFacilityAccount:::: " + JSON.stringify(component.get("v.newFacilityAccount")));
                }
            }
            else {
               // this.showError(response, "getFacilityAccounts");
            }
            component.set("v.showSpinner", false);
           // this.refresh(component);
        });

        $A.enqueueAction(action);
    },*/
    updateAppPrdctcpf : function(component, event, helper) {
        //var IsvatfacilityApplicable=component.get("v.IsvatfacilityApplicable");
        var IsvatfacilityApplicable=component.get("v.vatApplicableValues");
        var IsIncludeVAToncharges=component.get("v.IsIncludeVAToncharges");
        var DifferenceclauseapplicableoptionGiven=component.get("v.DifferenceclauseapplicableoptionGiven");
        var IncludebalanceonexistingaccountoptionGiven =component.get("v.IncludebalanceonexistingaccountoptionGiven");
        var amountofexistingmortgage;
        var Remainingavailableamount,capitalinterest;
        if(component.get("v.DifferenceclauseapplicableValues") !='Payout In Tranches'){
            if(component.find("amountofexistingmortgage") == undefined){
                amountofexistingmortgage=null;
            }else{
                amountofexistingmortgage = component.find("amountofexistingmortgage").get("v.value");
            }
            if(component.find("Remainingavailableamount") == undefined){
                Remainingavailableamount=null;
            }else{
                Remainingavailableamount = component.find("Remainingavailableamount").get("v.value");
            }
        }else {
            amountofexistingmortgage = component.find("amountofexistingmortgage").get("v.value");
            Remainingavailableamount = component.find("Remainingavailableamount").get("v.value");
        }
        if(component.find("capitalinterest") == undefined){
            capitalinterest=null;
        }else{
            capitalinterest = component.find("capitalinterest").get("v.value");
    }

        console.log('FacilityAccRecords=='+JSON.stringify(component.get("v.newFacilityAccount")));
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),

            "drawdownamount" : component.find("drawdownamount").get("v.value"),
            "retentionamount" : component.find("retentionamount").get("v.value"),
            "IsvatfacilityApplicable" : component.get("v.vatApplicableValues"),
            "IsIncludeVAToncharges" : IsIncludeVAToncharges,
            "Isotheramountsincludedintotalfacility" : component.get("v.otheramountsincludedintotalfacilityValues"),
            "DifferenceclauseapplicableoptionGiven" : component.get("v.DifferenceclauseapplicableValues"),
            "amountofexistingmortgage" : amountofexistingmortgage,
            "Remainingavailableamount" : Remainingavailableamount,
            "IncludebalanceonexistingaccountoptionGiven" : IncludebalanceonexistingaccountoptionGiven,
            "FacAcclist" : component.get("v.newFacilityAccount"),
            "accounttobeclosedoptn" : component.get("v.accounttobeclosedoptn"),
            "capitalinterest":capitalinterest
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS"){
                var oppRecvat = response.getReturnValue();
                console.log('oppRecvat---'+JSON.stringify(oppRecvat));
                console.log('component.get("v.newFacilityAccount")'+component.get("v.newFacilityAccount"));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);

    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);

            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });

        $A.enqueueAction(action);
    },

    AddOtherFees : function(component, event) {
        var otherFeesdetails = component.get("v.newOtherfees");
        otherFeesdetails.push({
            'sobjectType' : 'Application_Fees__c',

        });
        component.set("v.newOtherfees",otherFeesdetails);
        component.set("v.showSpinner", false);
    },

    OtherFeesSaving : function(component, event, helper) {
        console.log('newOtherfees=='+JSON.stringify(component.get("v.newOtherfees")));
        var action = component.get("c.OtherFeesDetailUpdate");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "otherfeesdetaillist" : component.get("v.newOtherfees")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                console.log('oppRec---'+JSON.stringify(oppRec));
                /*   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other fees details saved Successfully"
                });
                toastEvent.fire(); */
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
         $A.enqueueAction(action);

     },

    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
        var otherfeeslist=component.get("v.newOtherfees");
        otherfeeslist.splice(unlimitedrowinex,1);
        component.set("v.newOtherfees",otherfeeslist);

    },

    getAppOtherFeesRec :function(component, event, helper) {
        var action = component.get("c.getApplicationFeesRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appFeesRec = response.getReturnValue();
                console.log("newOtherfees: " + JSON.stringify(appFeesRec));
                component.set("v.newOtherfees",response.getReturnValue());

            }else {
                console.log("Failed with state: " + JSON.stringify(appFeesRec));
            }
        });

        $A.enqueueAction(action);
    },


})