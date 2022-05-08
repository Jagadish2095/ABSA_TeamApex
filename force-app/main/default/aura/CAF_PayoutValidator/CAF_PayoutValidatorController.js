({
    doInit : function(cmp, event, helper) {
        var selection = [
            { label: "Yes", value: "YES" },
            { label: "No", value: "NO" },
            { label: "Not Applicable", value: "N/A" }
        ];
        cmp.set("v.select", selection);
        helper.getSendTO(cmp, event, cmp.get("v.recordId"));
        //call helper function to load decision history records if any
        helper.loadHistoryRecords(cmp);
        helper.fetchReasonForPicklistValues(cmp, event, helper);
        helper.fetchnformationSourceForPicklistValues(cmp, event, helper);
        helper.setRadioButtonValues(cmp, event, helper);
    },
    
    landlordClick : function (cmp, event, helper){
        var landlordAddressVal = cmp.find("LandlordAddressGroup").get("v.value");
        cmp.find("landlordAddressValId").set("v.value",landlordAddressVal); 
        console.log ('LandLord Address :: ' + landlordAddressVal);   
    },   
    form25Click : function (cmp, event, helper){
        var form25CompleteVal = cmp.find("Form25CompletedGroup").get("v.value");
        cmp.find("form25CompleteValId").set("v.value",form25CompleteVal);
    },
    pricingDocReceivedClick : function (cmp, event, helper){
        var priceDocRec = cmp.find("PricingDocReceivedGroup").get("v.value");
        cmp.find("pricingDocReceivedValId").set("v.value",priceDocRec);
    },
    docFeeClick : function (cmp, event, helper){
        var docFeeRec = cmp.find("DocFeeCreditApprovalGroup").get("v.value");
        cmp.find("docFeeValId").set("v.value",docFeeRec);
    },
    amountFeeClick : function (cmp, event, helper){
        var amountFin = cmp.find("AmountFinancedGroup").get("v.value");
        cmp.find("amountFinValId").set("v.value", amountFin);
    },
    debitOrderClick : function (cmp, event, helper){
        var debitOrderCheck = cmp.find("DebitOrderCheckGroup").get("v.value");
        cmp.find("debitOrderValId").set("v.value", debitOrderCheck);
    },
    signedDOClick : function (cmp, event, helper){
        var signedDOCheck = cmp.find("SignedDOGroup").get("v.value");
        cmp.find("signedDOValId").set("v.value", signedDOCheck);  
    },
    signedAgreeClick : function (cmp, event, helper){
        var signedAgreement = cmp.find("SignedAgreementGroup").get("v.value");
        cmp.find("signedAgreeValId").set("v.value", signedAgreement);
    },
    creditAgreeTermClick : function (cmp, event, helper){
        var creditAgreementTerm = cmp.find("CreditAgreementTermGroup").get("v.value");
        cmp.find("creditAgreeTermValId").set("v.value", creditAgreementTerm);
    },
    creditAgreeTypeClick : function (cmp, event, helper){
        var creditAgreementType = cmp.find("CreditAgreementTypeGroup").get("v.value");   
        cmp.find("creditAgreeTypeValId").set("v.value", creditAgreementType);
    },
    articleFinanceClick : function (cmp, event, helper) {
        var articleFin = cmp.find("ArticleFinancedGroup").get("v.value");
        cmp.find("articleFinanceValId").set("v.value", articleFin);
    },
    nonVATGroupClick : function (cmp, event, helper) {
        var nonVAT = cmp.find("NonVATRegGroup").get("v.value");    
        cmp.find("nonVATGroupValId").set("v.value", nonVAT);
    },
    vatRegGroupClick : function (cmp, event, helper) {
        var vatReg = cmp.find("VATRegGroup").get("v.value");
        cmp.find("vatRegGroupValId").set("v.value", vatReg);
    },
    invSignedClick : function (cmp, event, helper) {
        var invSig = cmp.find("InvoiceSignedGroup").get("v.value");  
        cmp.find("invSignedValId").set("v.value", invSig);
    },
    invAmountClick : function (cmp, event, helper) {
        var invAmount = cmp.find("InvoiceCheckGroup").get("v.value"); 
        cmp.find("invAmountValId").set("v.value", invAmount);
    },
    confirmFromSalesClick : function (cmp, event, helper) {
        var confirm = cmp.find("ConfirmationGroup").get("v.value");
        cmp.find("confirmFromSalesValId").set("v.value", confirm);
    },
    descriptionOfGoodsClick : function (cmp, event, helper) {
        var descriptionGoods = cmp.find("GoodsDescriptionGroup").get("v.value");
        cmp.find("descriptionOfGoodsValId").set("v.value", descriptionGoods);
    },
    bankInterestClick : function (cmp, event, helper) {
        var bankInterest = cmp.find("BankInterestGroup").get("v.value");
        cmp.find("bankInterestValId").set("v.value", bankInterest);
    },
    freedomOfChoiceClick : function (cmp, event, helper) {
        var freedomChoice = cmp.find("FreedomOfChoiceGroup").get("v.value");
        cmp.find("freedomOfChoiceValId").set("v.value", freedomChoice); 
    },
    formSignedClick	: function (cmp, event, helper) {
        var formSigned = cmp.find("Form23SignedGroup").get("v.value");
        cmp.find("formSignedValId").set("v.value", formSigned); 
    },
    faisDocClick : function (cmp, event, helper) {
        var faisDoc = cmp.find("FAISDocGroup").get("v.value");
        cmp.find("faisDocValId").set("v.value", faisDoc); 
    },
    dicPaidClick : function (cmp, event, helper) {
        var dicPaid = cmp.find("DICPaidGroup").get("v.value");
        cmp.find("dicPaidValId").set("v.value", dicPaid); 
    },
    dealerCheckClick : function (cmp, event, helper) {
        var dealerCheck = cmp.find("DealerCheckGroup").get("v.value");
        cmp.find("dealerCheckValId").set("v.value", dealerCheck); 
    },
    signedByManClick : function (cmp, event, helper) {
        var signMan = cmp.find("SignedByMandateGroup").get("v.value");
        cmp.find("signedByManValId").set("v.value", signMan); 
    },
    inspectReportClick : function (cmp, event, helper) {
        var inspectRep = cmp.find("InspectionReportGroup").get("v.value");
        cmp.find("inspectReportValId").set("v.value", inspectRep); 
    },
    goodsPaidClick : function (cmp, event, helper) {
        var goodsPaid = cmp.find("GoodsPaidInFullGroup").get("v.value");
        cmp.find("goodsPaidValId").set("v.value", goodsPaid); 
    },
    depMatchClick : function (cmp, event, helper) {
        var depMatch = cmp.find("DepositMatchGroup").get("v.value");
        cmp.find("depMatchValId").set("v.value", depMatch); 
    },
    signConsentClick : function (cmp, event, helper) {
        var signCons = cmp.find("SignedConsentFormGroup").get("v.value");
        cmp.find("signConsentValId").set("v.value", signCons); 
    },
    casaRefNoClick : function (cmp, event, helper) {
        var casaRefNo = cmp.find("CASARefNoGroup").get("v.value");
        cmp.find("casaRefNoValId").set("v.value", casaRefNo); 
    },
    engChassNoClick : function (cmp, event, helper) {
        var engChassNo = cmp.find("EngineChassisNoGroup").get("v.value");
        cmp.find("engChassNoValId").set("v.value", engChassNo); 
    },
    clientNameCheckClick : function (cmp, event, helper) {
        var clientNameCheck = cmp.find("ClientNameCheckGroup").get("v.value");
        cmp.find("clientNameCheckValId").set("v.value", clientNameCheck); 
    },
    screenInfoMatchClick : function (cmp, event, helper) {
        var screenInfo = cmp.find("ScreenInfoMatchGroup").get("v.value");
        cmp.find("screenInfoMatchValId").set("v.value", screenInfo); 
    },
    ficaInfoClick : function (cmp, event, helper) {
        var ficaInfo = cmp.find("FICAInfoLoadedGroup").get("v.value");
        cmp.find("ficaInfoValId").set("v.value", ficaInfo); 
    },
    signedAckClick : function (cmp, event, helper) {
        var signedAck = cmp.find("SignedCheckGroup").get("v.value");
        cmp.find("signedAckValId").set("v.value", signedAck); 
    },
    infoSignContrClick : function (cmp, event, helper) {
        var infoSignContr = cmp.find("InfoOnSignedContractGroup").get("v.value");
        cmp.find("infoSignContrValId").set("v.value", infoSignContr); 
    },
    debitOrderInfoClick : function (cmp, event, helper) {
        var debitOrderInfo = cmp.find("DebitOrderInfoGroup").get("v.value");
        cmp.find("debitOrderInfoValId").set("v.value", debitOrderInfo); 
    },
    monthDebitOrderVal : function (cmp, event, helper) {
        var montDebitOrder = cmp.find("MonthlyDebitOrderGroup").get("v.value");
        cmp.find("monthDebitOrderValId").set("v.value", montDebitOrder); 
    },
    InsureInfoClick : function (cmp, event, helper) {
        var insureInfo = cmp.find("InsuranceInfoGroup").get("v.value");
        cmp.find("InsureInfoValId").set("v.value", insureInfo); 
    },
    customerLoadedClick : function (cmp, event, helper) {
        var custLoaded = cmp.find("CustomerLoadedGroup").get("v.value");
        cmp.find("customerLoadedValId").set("v.value", custLoaded); 
    },
    affordInfoClick : function (cmp, event, helper) {
        var affordInfo = cmp.find("AffordabilityInfoGroup").get("v.value");
        cmp.find("affordInfoValId").set("v.value", affordInfo); 
    },
    serviceFeeClick : function (cmp, event, helper) {
        var servFee = cmp.find("ServiceFeeGroup").get("v.value");
        cmp.find("serviceFeeValId").set("v.value", servFee); 
    },
    docFeeLoadedClick : function (cmp, event, helper) {
        var docFeeLoad = cmp.find("DocFeeLoadedGroup").get("v.value");
        cmp.find("docFeeLoadedValId").set("v.value", docFeeLoad); 
    },
    dicPayClick : function (cmp, event, helper) {
        var dicPay = cmp.find("DICPayableGroup").get("v.value");
        cmp.find("dicPayValId").set("v.value", dicPay); 
    },
    noDicPayClick : function (cmp, event, helper) {
        var noDicPay = cmp.find("NoDICPayableGroup").get("v.value");
        cmp.find("noDicPayValId").set("v.value", noDicPay); 
    },
    clientInfoUpdClick : function (cmp, event, helper) {
        var clientInfoUpdated = cmp.find("ClientInfoUpdatedGroup").get("v.value");
        cmp.find("clientInfoUpdValId").set("v.value", clientInfoUpdated); 
    },
    vapsLoadedClick : function (cmp, event, helper) {
        var vapsLoad = cmp.find("VAPSLoadedGroup").get("v.value");
        cmp.find("vapsLoadedValId").set("v.value", vapsLoad); 
    },
    vapsCancelClick : function (cmp, event, helper) {
        var vapsCancel = cmp.find("VAPSCancelledGroup").get("v.value");
        cmp.find("vapsCancelValId").set("v.value", vapsCancel); 
    },
    
    grantButtonClick : function (cmp, event, helper) {
        var buttonlabel = event.getSource().get("v.label");
        //alert(buttonlabel + 'button clicked');
        cmp.set('v.grantbutton',true); 
        cmp.set('v.requestmoreinfo',false); 
        cmp.set('v.confirmcheck',false);
    },
    
    confirmClick : function (cmp, event, helper) {
        cmp.set('v.confirmcheck',true);
    },
    
    requestmoreInfoClick : function (cmp, event, helper) {
        cmp.set('v.requestmoreinfo',true);
        cmp.set('v.grantbutton',false);
        cmp.set('v.confirmcheck',false);
    },
    
    submitApplicationDecision : function(cmp, event, helper) {
        helper.updateDecisionData(cmp, event, helper,'Payout Validation',cmp.get("v.recordId"));
        if( cmp.get('v.grantbutton') == true && 
           (cmp.get('v.landlordAddressVal') == undefined ||  
            cmp.get('v.form25CompleteVal') == undefined ||
            cmp.get('v.pricingDocReceivedVal') == undefined ||
            cmp.get('v.docFeeVal') == undefined ||
            cmp.get('v.amountFinVal') == undefined ||
            cmp.get('v.debitOrderVal') == undefined ||
            cmp.get('v.signedDOVal') == undefined ||
            cmp.get('v.signedAgreeVal') == undefined ||
            cmp.get('v.creditAgreeTermVal') == undefined ||
            cmp.get('v.creditAgreeTypeVal') == undefined || 
            cmp.get('v.articleFinanceVal') == undefined ||
            cmp.get('v.nonVATGroupVal') == undefined ||
            cmp.get('v.vatRegGroupVal') == undefined ||
            cmp.get('v.invSignedVal') == undefined ||
            cmp.get('v.invAmountVal') == undefined ||
            cmp.get('v.confirmFromSalesVal') == undefined ||
            cmp.get('v.descriptionOfGoodsVal') == undefined ||
            cmp.get('v.bankInterestVal') == undefined ||
            cmp.get('v.freedomOfChoiceVal') == undefined ||  
            cmp.get('v.formSignedVal') == undefined ||
            cmp.get('v.faisDocVal') == undefined ||
            cmp.get('v.dicPaidVal') == undefined ||
            cmp.get('v.dealerCheckVal') == undefined ||
            cmp.get('v.signedByManVal') == undefined ||
            cmp.get('v.inspectReportVal') == undefined ||
            cmp.get('v.goodsPaidVal') == undefined ||
            cmp.get('v.depMatchVal') == undefined ||
            cmp.get('v.signConsentVal') == undefined ||  
            cmp.get('v.casaRefNoVal') == undefined ||
            cmp.get('v.engChassNoVal') == undefined ||
            cmp.get('v.clientNameCheckVal') == undefined ||
            cmp.get('v.screenInfoMatchVal') == undefined ||
            cmp.get('v.ficaInfoVal') == undefined ||
            cmp.get('v.signedAckVal') == undefined ||
            cmp.get('v.infoSignContrVal') == undefined ||
            cmp.get('v.debitOrderInfoVal') == undefined ||  
            cmp.get('v.monthDebitOrderVal') == undefined ||
            cmp.get('v.InsureInfoVal') == undefined ||
            cmp.get('v.customerLoadedVal') == undefined ||
            cmp.get('v.affordInfoVal') == undefined ||
            cmp.get('v.serviceFeeVal') == undefined || 
            cmp.get('v.docFeeLoadedVal') == undefined ||
            cmp.get('v.dicPayVal') == undefined ||
            cmp.get('v.noDicPayVal') == undefined ||
            cmp.get('v.clientInfoUpdVal') == undefined ||
            cmp.get('v.vapsLoadedVal') == undefined ||
            cmp.get('v.vapsCancelVal') == undefined 
           ))
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "Please complete the whole checklist before approving."
            });
            toastEvent.fire();   
        }else{
            helper.showSpinner(cmp);
            // console.log("decision"+cmp.get('v.requestmoreinfo'));
            var infoSource;
            if(cmp.get('v.requestmoreinfo') == true){
                console.log("in if" );    
                infoSource =  cmp.find("InfoSourceId").get("v.value");       
                
            }
            else{infoSource = '';}     
            // console.log("infoSource"+infoSource);
            // console.log("infoSource2"+cmp.find("InfoSourceId").get("v.value"));
            //cmp.find("payoutvalidator").submit();
            var method1 = cmp.get("c.insertDecisionHistoryRec");
            method1.setParams({
                "caseId" : cmp.get('v.recordId'), 
                "detail" : cmp.get('v.moreInfoRequested'),
                "comments" : cmp.get('v.commentArea'),
                "grant"	   : cmp.get('v.grantbutton'),
                "requestInfo" : cmp.get('v.requestmoreinfo'),
                "typeOfValidator" : "Payout Validator", 
                "infoSource" : infoSource
            });
            method1.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.hideSpinner(cmp);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Payout Validator Submitted Successfully',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                    
                    helper.loadHistoryRecords(cmp); 
                    $A.get('e.force:refreshView').fire(); 
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
            })
            $A.enqueueAction(method1);
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
        cmp.set("v.InfoSourceValue", cmp.find("InfoSourceId").get("v.value"));         
    },
    commentText : function(cmp, event, helper) {
        var CT = cmp.find("commentId").get("v.value");
        var commentTextArea = cmp.find("commentId").get("v.value");
        cmp.set('v.commentArea', commentTextArea);
        cmp.set('v.approvalDecisionComment', CT);
        console.log ('Comment : ' + CT);
        
    },
    
    commentText2 : function(cmp, event, helper) {
        var CT = cmp.find("commentId2").get("v.value");
        var commentTextArea = cmp.find("commentId2").get("v.value");
        cmp.set('v.commentArea', commentTextArea);
        cmp.set('v.approvalDecisionComment', CT);
        console.log ('Comment : ' + CT);
        
    },
    
    handleError: function (cmp, event, helper) {
        cmp.find('notifLib').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("error"),
            "variant": "error"
        });
    }
})