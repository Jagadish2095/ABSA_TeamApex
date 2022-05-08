({
doInit: function (component, event, helper) {
    helper.getAppPrdctCpfRec(component, event);
    helper.getAppConClauseCpfRec(component, event, helper);
    helper.getAppConClauseCpfRecforPredisbursement(component, event, helper);
    helper.getAppPhaseRec(component, event, helper);
},
    addNewPerPhase: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isPrephase", true);
        helper.addPerphaseItems(component, event);
    }, 
    addOtherprelodgmentbtn: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.addOtherprelodgmentbtnItems(component, event);
    },
    addOtherpredisbursementbtn: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.addOtherpredisbursementbtnItems(component, event);
    }, 
     handleperphaseApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var perphaselist=component.get("v.newperphase");
        perphaselist.splice(rowinex,1);
        component.set("v.newperphase",perphaselist);
    },
    handleotherprelodgmentApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var otherprelodgmentlist=component.get("v.newOtherPreLodgmentConditions");
        otherprelodgmentlist.splice(rowinex,1);
        component.set("v.newOtherPreLodgmentConditions",otherprelodgmentlist);
    },
    handleotherpredisbursementApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var otherpredisbursementlist=component.get("v.newOtherpredisbursementConditions");
        otherpredisbursementlist.splice(rowinex,1);
        component.set("v.newOtherpredisbursementConditions",otherpredisbursementlist);
    },
     handleOtherprelodgmentSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.SaveOtherPreLodgment(component, event);
    },
     handleOtherpredisbursementSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.SaveOtherpredisbursement(component, event);
    },
     handlePresaleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
          var itemsToPass=component.get("v.newperphase");
          var item;
          var checkStatus = false;
         if(component.get('v.nonrefundabledepositvalue') == 'Amount' && (component.find("nonrefundabledepositamountId").get("v.value") == undefined || component.find("nonrefundabledepositamountId").get("v.value") == '')){
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
                 component.set("v.showSpinner", false);
             }else if(component.get('v.nonrefundabledepositvalue') == 'Percentage' && (component.find("nonrefundabledepositpercentageId").get("v.value") == undefined || component.find("nonrefundabledepositpercentageId").get("v.value") == '')){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
                 component.set("v.showSpinner", false);
         }else if(component.get('v.multiplepurchasesvalue') == 'Amount' && (component.find("multiplepurchaseamountId").get("v.value") == undefined || component.find("multiplepurchaseamountId").get("v.value") == '')){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
                 component.set("v.showSpinner", false);
         }else if(component.get('v.multiplepurchasesvalue') == 'Percentage' && (component.find("multipurposepercentageId").get("v.value") == undefined || component.find("multipurposepercentageId").get("v.value") == '')){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
                 component.set("v.showSpinner", false);
         }else if(component.get('v.proofofprevalue') == 'Yes' && (component.find("numberofpresalesId").get("v.value") == undefined || component.find("numberofpresalesId").get("v.value") == '' || component.find("aggregatepriceId").get("v.value") == undefined || component.find("aggregatepriceId").get("v.value") == '')){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
                 component.set("v.showSpinner", false);
         }else if(component.get('v.proofofprevalue') == 'Per Phase'){
             for (var i=0; i< itemsToPass.length; i++)
                {
                    item = itemsToPass[i];
                    if(item.Phase_Number__c=='' || item.Phase_Number__c==undefined || item.Number_of_pre_sales__c=='' || item.Number_of_pre_sales__c==undefined || item.Aggregate_price__c=='' || item.Aggregate_price__c==undefined){
                        checkStatus = true;
                    }
                }
             if(checkStatus ==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "error!",
                        "type":"Error",
                        "message": "Please complete all required fields"
                    });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                }else {
                    helper.updatePresales(component, event, helper);}
         }else{helper.updatePresales(component, event);}
       // helper.updatePresales(component, event);
    },
})