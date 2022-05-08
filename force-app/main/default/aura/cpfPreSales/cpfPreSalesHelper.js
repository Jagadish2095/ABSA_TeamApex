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
                console.log("appPrdctCpfRecId 6: " + JSON.stringify(appPrdctCpfRecId));
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId);
                 if(appPrdctCpfRecId.Pre_sales__c != '' && appPrdctCpfRecId.Pre_sales__c!=null ){
                    component.set("v.presalesvalue", appPrdctCpfRecId.Pre_sales__c);
                }
                if(appPrdctCpfRecId.Non_refundable_deposit__c != '' && appPrdctCpfRecId.Non_refundable_deposit__c!=null ){
                    component.set("v.nonrefundabledepositvalue", appPrdctCpfRecId.Non_refundable_deposit__c);
                }
                 if(appPrdctCpfRecId.Multiple_purchase__c != '' && appPrdctCpfRecId.Multiple_purchase__c!=null ){
                    component.set("v.multiplepurchasesvalue", appPrdctCpfRecId.Multiple_purchase__c);
                }
                if(appPrdctCpfRecId.Proof_of_Pre_sales__c != '' && appPrdctCpfRecId.Proof_of_Pre_sales__c!=null ){
                    component.set("v.proofofprevalue", appPrdctCpfRecId.Proof_of_Pre_sales__c);
                }
                if(appPrdctCpfRecId.Schedule_of_net_sale__c != '' && appPrdctCpfRecId.Schedule_of_net_sale__c!=null ){
                    component.set("v.schedulenetsalevalue", appPrdctCpfRecId.Schedule_of_net_sale__c);
                }
                if(appPrdctCpfRecId.Schedule_of_sales__c != '' && appPrdctCpfRecId.Schedule_of_sales__c!=null ){
                    component.set("v.scheduleofsalevalue", appPrdctCpfRecId.Schedule_of_sales__c);
                }
                if(appPrdctCpfRecId.Copy_of_standard_sales_agreement__c != '' && appPrdctCpfRecId.Copy_of_standard_sales_agreement__c!=null ){
                    component.set("v.copyofstandardsalesvalue", appPrdctCpfRecId.Copy_of_standard_sales_agreement__c);
                }
                if(appPrdctCpfRecId.Copies_of_all_sale_agreements__c != '' && appPrdctCpfRecId.Copies_of_all_sale_agreements__c!=null ){
                    component.set("v.copiesofallsalesaggrementsvalue", appPrdctCpfRecId.Copies_of_all_sale_agreements__c);
                }
            }else {
                console.log("Failed with state3535: " + JSON.stringify(appPrdctCpfRecId));
            }
        });
        
        $A.enqueueAction(action);
    },
    addPerphaseItems : function(component, event) {
        var perphaselist = component.get("v.newperphase");
        perphaselist.push({
            'sobjectType' : 'Application_Phase_CPF__c',
            'Type__c' : ''
            
        });
        component.set("v.newperphase",perphaselist);   
        component.set("v.showSpinner", false);
    },
    addOtherprelodgmentbtnItems : function(component, event) {
        var otherprelodgmentlist = component.get("v.newOtherPreLodgmentConditions");
        otherprelodgmentlist.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Type__c' : ''
            
        });
        component.set("v.newOtherPreLodgmentConditions",otherprelodgmentlist);   
        component.set("v.showSpinner", false);
    },
    addOtherpredisbursementbtnItems : function(component, event) {
        var otherpredisbursementlist = component.get("v.newOtherpredisbursementConditions");
        otherpredisbursementlist.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Type__c' : ''
            
        });
        component.set("v.newOtherpredisbursementConditions",otherpredisbursementlist);   
        component.set("v.showSpinner", false);
    },
     SaveOtherPreLodgment: function(component, event) {
       var action = component.get("c.insertPreLodgmentConditions");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "newOtherprelodgmentConditions" : component.get("v.newOtherPreLodgmentConditions")
           	
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var Appconcpfrecs = response.getReturnValue();
               console.log('Appconcpfrecs---'+JSON.stringify(Appconcpfrecs));
                //var toastEvent = $A.get("e.force:showToast");
                this.fireToast("Success!","Pre-lodgment records Saved Successfully","success");
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
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    SaveOtherpredisbursement: function(component, event) {
       var action = component.get("c.insertpredisbursement");
       action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "newOtherpredisbursementConditions" : component.get("v.newOtherpredisbursementConditions")
           	
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var Appconcpfrecs = response.getReturnValue();
               console.log('AppconcpfrecsDisbursement---'+JSON.stringify(Appconcpfrecs));
                //var toastEvent = $A.get("e.force:showToast");
                this.fireToast("Success!","Pre-Disbursement records Saved Successfully","success");
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
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    getAppConClauseCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Pre-Lodgement Conditions'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newOtherPreLodgmentConditions: " + JSON.stringify(appConClauseRec));
              	component.set("v.newOtherPreLodgmentConditions",response.getReturnValue());
              
            }else {
                console.log("Failed with statenewOtherPreLodgmentConditions: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppConClauseCpfRecforPredisbursement :function(component, event, helper) {
        var action = component.get("c.getAppContractClauseRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Pre-Disbursement Conditions'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appConClauseRec = response.getReturnValue();
                console.log("newOtherpredisbursementConditions: " + JSON.stringify(appConClauseRec));
              	component.set("v.newOtherpredisbursementConditions",response.getReturnValue());
              
            }else {
                console.log("Failed with newOtherpredisbursementConditions: " + JSON.stringify(appConClauseRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppPhaseRec :function(component, event, helper) {
        var action = component.get("c.getAppPhaseCPFRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Per Phase'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appPhaseCPFRec = response.getReturnValue();
                console.log("appPhaseCPFRec: " + JSON.stringify(appPhaseCPFRec));
              component.set("v.newperphase",response.getReturnValue());
            }else {
                console.log("Failed with newperphase: " + JSON.stringify(appPhaseCPFRec));
            }
        });
        
        $A.enqueueAction(action);
    },
     updatePresales: function(component, event, helper) { 
        var nonrefundabledepositamount,nonrefundabledepositpercentage,multiplepurchaseamount,multipurposepercentage,numberofpresales,
            aggregateprice,maxbysingleinvestor;
        if(component.find("nonrefundabledepositamountId") == undefined){
            nonrefundabledepositamount=null;
        }else{
            nonrefundabledepositamount = component.find("nonrefundabledepositamountId").get("v.value");
        }
        if(component.find("nonrefundabledepositpercentageId") == undefined){
            nonrefundabledepositpercentage=null;
        }else{
            nonrefundabledepositpercentage = component.find("nonrefundabledepositpercentageId").get("v.value");
        }
        if(component.find("multiplepurchaseamountId") == undefined){
            multiplepurchaseamount=null;
        }else{
            multiplepurchaseamount = component.find("multiplepurchaseamountId").get("v.value");
        }
        if(component.find("multipurposepercentageId") == undefined){
            multipurposepercentage=null;
        }else{
            multipurposepercentage = component.find("multipurposepercentageId").get("v.value");
        }
        if(component.find("numberofpresalesId") == undefined){
            numberofpresales=null;
        }else{
            numberofpresales = component.find("numberofpresalesId").get("v.value");
        }
        if(component.find("aggregatepriceId") == undefined){
            aggregateprice=null;
        }else{
            aggregateprice = component.find("aggregatepriceId").get("v.value");
        }
        if(component.find("maxbysingleinvestorId") == undefined){
            maxbysingleinvestor=null;
        }else{
            maxbysingleinvestor = component.find("maxbysingleinvestorId").get("v.value");
        }
        var appProductcpf = new Object();
        appProductcpf.presalesvalue= component.get('v.presalesvalue');
        appProductcpf.nonrefundabledepositvalue= component.get('v.nonrefundabledepositvalue');
        appProductcpf.nonrefundabledepositamount= nonrefundabledepositamount;
        appProductcpf.nonrefundabledepositpercentage = nonrefundabledepositpercentage;
        appProductcpf.multiplepurchasesvalue= component.get('v.multiplepurchasesvalue');
        appProductcpf.multiplepurchaseamount= multiplepurchaseamount;
        appProductcpf.multipurposepercentage= multipurposepercentage;
        appProductcpf.proofofprevalue= component.get('v.proofofprevalue');
        appProductcpf.numberofpresales=numberofpresales;
        appProductcpf.aggregateprice= aggregateprice;
        appProductcpf.newperphase= component.get('v.newperphase');
        appProductcpf.schedulenetsalevalue= component.get('v.schedulenetsalevalue');
        appProductcpf.scheduleofsalevalue= component.get('v.scheduleofsalevalue');
        appProductcpf.maxbysingleinvestor= maxbysingleinvestor;
        appProductcpf.copyofstandardsalesvalue= component.get('v.copyofstandardsalesvalue');
        appProductcpf.copiesofallsalesaggrementsvalue= component.get('v.copiesofallsalesaggrementsvalue');
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "objData": JSON.stringify(appProductcpf),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            
            if (state === "SUCCESS"){
                var preSalesresp = response.getReturnValue();
                console.log("preSalesresp ="+JSON.stringify(preSalesresp));
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
                        alert("Error message: " +errors[0].message);
                    }
                }else{
                    alert("Unknown error");
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
     //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }

})