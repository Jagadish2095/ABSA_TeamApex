({
    
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppPortfolioCpfRec(component, event, helper);
        helper.getopplineitemRec(component, event, helper);
    },
    handleportfolioApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var portfoliolist=component.get("v.newPortfolioList");
        portfoliolist.splice(rowinex,1);
        component.set("v.newPortfolioList",portfoliolist);
    },
    showHiddenFields :function(component, event, helper) {
        
        var amendmentVal = component.find("amendment").get("v.value");
       // var withdrawalVal = component.find("withdrawal").get("v.value");
        if(amendmentVal == "Yes" ){
            component.set("v.showCIFField", true);
        }   
        else{
            component.set("v.showCIFField", false);
        }
    },
    
    showequityFields :function(component, event, helper) {
         var equityVal = component.find("equity").get("v.value");
        if(equityVal == "Equity contribution amount" ){
            component.set("v.showEquityAmtField", true);
            component.set("v.showOtherEquityField", false);
        }   
        else if(equityVal== "Other" ){
            component.set("v.showEquityAmtField", false);
            component.set("v.showOtherEquityField", true);
        }
}, 
       showthresholdFields :function(component, event, helper) {
        var thresholdVal = component.find("threshold").get("v.value");

        if(thresholdVal == "Yes" ){
            component.set("v.showThresholdFields", true);
        }   
        else if(thresholdVal== "No" ){
            component.set("v.showThresholdFields", false);
        }
       },

    showadditionalDocFields :function(component, event, helper) {
        var additionalDocsVal = component.find("additionalDoc").get("v.value");
        if(additionalDocsVal == "Yes" ){
            component.set("v.showDocField", true);
        } 
        else if(additionalDocsVal== "No" ){
            component.set("v.showDocField", false);
        }
    },
    showfPurposeFields :function(component, event, helper) {
         var facilityPurposeVal = component.find("fPurpose").get("v.value");

        if(facilityPurposeVal == "PURPOSE AS APPROVED BY CREDIT" ){
            component.set("v.showApprovedByCreditField", true);
            component.set("v.showPortfolioDescriptionField", false);
            //component.set("v.showcreditPropField", true);
            component.set("v.showPropertyDescriptionField", false);
        }   
        else if(facilityPurposeVal== "To finance in whole or in part the acquisition of the Property" ){
            // component.set("v.showcreditPropField", true);
            component.set("v.showApprovedByCreditField", false);
            component.set("v.showPortfolioDescriptionField", false);
            component.set("v.showPropertyDescriptionField", true);
        }
            else if(facilityPurposeVal=="To finance in whole or in part the acquisition of a portfolio of Properties" ){
                component.set("v.showPortfolioDescriptionField", true);
                //  component.set("v.showcreditPropField", false);
                component.set("v.showApprovedByCreditField", false);
                component.set("v.showPropertyDescriptionField", false);
            }
        
                else if(facilityPurposeVal==undefined ){
                    component.set("v.showPortfolioDescriptionField", false);
                    component.set("v.showPropertySelectionField", false);
                    component.set("v.showApprovedByCreditField", false);
                    component.set("v.showPropertyDescriptionField", false);
                }
    },
    showdevproptype:function(component, event, helper) {
        var devproptype = component.find("devproptype").get("v.value");
        if(devproptype == "other please specify" ){
            component.set("v.devproptype", true);
        } 
        else{
            component.set("v.devproptype", false);
        }
    },
    showdevloanvatfaciamt:function(component, event, helper) {
        var devloanvatfaciamt = component.find("devloanvatfaciamt").get("v.value");
        component.set("v.devloanvatfaciamt", devloanvatfaciamt);

    },
    showdevloanfinalrepaypick:function(component, event, helper) {
        var devloanfinalrepaypick = component.find("devloanfinalrepaypick").get("v.value");
            component.set("v.devloanfinalrepaypick", devloanfinalrepaypick);
    },
    showvatrepayoptions:function(component, event, helper) {
        var vatrepayoptions = component.find("vatrepayoptions").get("v.value");
        component.set("v.vatrepayoptions", vatrepayoptions);
    },
    
    handleSaveError: function (component, event, helper) {
        component.find('iApplicationRecord').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("message"),
            "variant": "error"
        });
    },
    
    handleSaveSuccess: function (component, event, helper) {
        //   var clientName = component.get("v.clientName")
        component.find('iApplicationRecord').showToast({
            "title": "Record saved!",
            "message": "record saved successfully.",
            "variant": "success"
        });
    },
    handleSubmit : function(component, event, helper) {
        //VALIDATION SECTION START 
        var isValid = false;
        var amendmentVal = component.find("amendment").get("v.value");
        var facilityPurposeVal ;//= component.find("fPurpose").get("v.value");
        if(component.find("fPurpose") == undefined){
            facilityPurposeVal=null;
        }else{
            facilityPurposeVal = component.find("fPurpose").get("v.value");
        }

        if(amendmentVal == 'Yes' && $A.util.isEmpty(component.find("CPFF_accNo").get("v.value"))){
            isValid = true;
        }else if((facilityPurposeVal == "To finance in whole or in part the acquisition of the Property" && 
                 ($A.util.isEmpty(component.find("propselection").get("v.value")) || $A.util.isEmpty(component.find("propDescription1").get("v.value"))))
                 || (facilityPurposeVal == "PURPOSE AS APPROVED BY CREDIT" && $A.util.isEmpty(component.find("propDescription").get("v.value")))){
            isValid = true;
        }
            else {
                isValid = false;
            }
        
        
        if(isValid == true ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"Error",
                "message": "Please complete all required fields"
            });
            toastEvent.fire();
            return;
        }
        //VALIDATION SECTION END
        else{
            helper.updateAppPrdctcpf(component, event, helper);
            
        }
        
        
    },
    
    addNewPortfolio: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.addPortfolio(component, event);
        
    }
    
    
})