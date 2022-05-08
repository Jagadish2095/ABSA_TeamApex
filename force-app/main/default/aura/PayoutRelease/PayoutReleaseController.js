({
    doInit : function(component, event, helper) {
        //set options
        var options = [
            { label: "Yes", value: "YES" },
            { label: "No", value: "NO" },
            { label: "Not Applicable", value: "N/A" }
        ];
        component.set("v.options", options);
        //get decision history records 
        helper.loadHistoryRecords(component);
        helper.getSendTO(component, event, component.get("v.recordId"));
        // get picklist values 
        helper.fetchReasonForPicklistValues(component, event, helper);
        helper.fetchnformationSourceForPicklistValues(component, event, helper);
        helper.fetchExistingCaseData(component, event, helper);
    },
    
    selectDecision : function(component, event, helper) {
        var buttonlabel = event.getSource().get("v.label");
        if(buttonlabel == 'Grant'){
            
            var elem = component.find('grantButton');
            var elemMoreInfo = component.find('moreInfoButton');
            $A.util.removeClass(elemMoreInfo, 'requestMoreInfo');
            $A.util.addClass(elem, 'backGroundColorGrant');
            
            component.set('v.showGrant',true);
            component.set('v.showMoreInfo',false);
            component.set('v.grantbuttonvalue',true);
            component.set('v.requestmoreinfo',false);
        }else if(buttonlabel == 'More Info Requested'){
            var elem = component.find('grantButton');
            var elemMoreInfo = component.find('moreInfoButton');
            $A.util.addClass(elemMoreInfo, 'requestMoreInfo');
            $A.util.removeClass(elem, 'backGroundColorGrant');
            
            component.set('v.showGrant',true);
            component.set('v.showMoreInfo',true);
            component.set('v.InfoSource',true);
            component.set('v.grantbuttonvalue',false);
            component.set('v.requestmoreinfo',true);
        }
    },
    
    showButton : function(component, event, helper) {
        var checkCmp = component.find("iTermsAndConditions").get("v.value");
        component.set("v.agreeToTerms",checkCmp);
    },
    
    HandlePaymentMethodRadioButtonGroup : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("PaymentMethodisLoadedasEId").set("v.value",valu1e);
    },
    
    HandleInvoiceinRadioButtonGroup : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("InvoiceInformationCorrespondsId").set("v.value",valu1e);
    },
    HandlePaymentismadeRadioButtonGroup : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("PaymentMadeCorrectDealerId").set("v.value",valu1e);
    },
    HandleTheAmountInvoidCorresponsRadioButton : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("TheAmountofTheInvoiceCorrespondsId").set("v.value",valu1e);
    },
    HandleServiceFeeRadioButtonGroup : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("ServiceFeeHasBeenLoadedCorrectlyId").set("v.value",valu1e);
    },
    HandleDocumentationFeeRadioBut : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("DocumentationFeeLoadedId").set("v.value",valu1e);
    },
    HandleDealerNameRadioButtonGroup : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("DealerNameInvoiceCorresponsId").set("v.value",valu1e);
    },
    HandlePaymentDetailsOfDealerisLoaded : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("PaymentDetailsOfDealerDealerApprovalId").set("v.value",valu1e);
    },
    HandleProofOfDepositRadioBut : function(component, event, helper) {
        var valu1e = event.getParam("value");
        component.find("ProofOfDepositfromtheInvoiceId").set("v.value",valu1e);
    },
    
    submitDecision: function(component, event, helper) {
         helper.updateDecisionData(component, event, helper,'Payout Release',component.get("v.recordId"));
       // component.find("payoutRelease").submit();
        if( component.get('v.grantbuttonvalue') == true && 
           (component.get("v.PaymentMethodisLoadedasE") == undefined ||
        	component.get("v.InvoiceInformationCorresponds") == undefined||
            component.get("v.PaymentMadeCorrectDealer") == undefined||
            component.get("v.TheAmountofTheInvoiceCorresponds") == undefined||
            component.get("v.ServiceFeeHasBeenLoadedCorrectly") == undefined||
            component.get("v.DocumentationFeeLoaded") == undefined||
            component.get("v.DealerNameInvoiceCorrespons") == undefined||
            component.get("v.PaymentDetailsOfDealerDealerApproval") == undefined||
            component.get("v.ProofOfDepositfromtheInvoice") == undefined))   
        {
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "Please complete the whole checklist before approving."
            });
            toastEvent.fire();   
            }else{
        helper.showSpinner(component);
        var infoSource;
                if(component.get('v.showMoreInfo') == true){
                    
            infoSource =  component.find("InfoSourceId").get("v.value");       
                    
                }
                else{infoSource = '';}
        var action = component.get("c.insertDecisionHistoryRec");
                
        action.setParams({
            "caseId" : component.get('v.recordId'), 
            "detail" : component.get('v.ReasonForMoreInformationValue'), 
            "comments" : component.get("v.commentAreaValue"),
            "grant"	   : component.get('v.grantbuttonvalue'),
            "requestInfo" : component.get('v.showMoreInfo'),
            "typeOfValidator" : "Payout Release",
            "infoSource" : infoSource
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            
            //alert(state);
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                $A.get('e.force:refreshView').fire();
                //alert("Controller response : " + response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Payout Release Decision Updated',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                helper.loadHistoryRecords(component);
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                }                
            }           
        });
        $A.enqueueAction(action);
            }   
    },
     ReasonForMoreInfoChange : function(cmp, event, helper) {
         
         var valu1e = event.getParam("value");
         cmp.find("ReasonForMoreInformation").set("v.value",valu1e);
         cmp.set("v.ReasonForMoreInformationValue", valu1e);
    },
     infoSourceonChange : function(cmp, event, helper) {
         
         var valu1e = event.getParam("value");
         cmp.find("InfoSourceId").set("v.value",valu1e);
        // cmp.set("v.InfoSourceValue", valu1e);
         cmp.set("v.InfoSourceValue", cmp.find("InfoSourceId").get("v.value")); 
         console.log("infoSource "+ cmp.get("v.InfoSourceValue"));
    },
    commentTextOnchange : function(cmp, event, helper) {
        var commentText = cmp.find("CommentsTextArea").get("v.value");
        cmp.set('v.commentAreaValue', commentText);
    },
    
    
    
    
})