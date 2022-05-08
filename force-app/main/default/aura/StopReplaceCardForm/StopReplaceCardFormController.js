({
	doInit : function(component, event, helper) {
        
        // get Todays date
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        component.set("v.todaysDate",today);
        
        component.set("v.isshowError",false);
        var plasticCardNumber = component.get("v.cardNumber");
        component.set("v.cardNumber",component.get("v.cardNumber"));
        var stopReason = component.get("v.stopCardReason");
        console.log('$$$$$plasticCardNumber$$$'+plasticCardNumber);
        console.log('$$$$$stopReason$$$'+stopReason);
		helper.getStopCardCircumstances(component, event, helper);
        helper.getStopCardReasons(component, event, helper);
        helper.getDeliveryMethods(component, event, helper);
	},
    saveCardDetails : function(component, event, helper){
       
               
        
        var plstCardNumber = component.find("plstCardNmr").get("v.value");
        var stopCardReason = component.find("stopReason").get("v.value");
        
        var circumstance = component.find("circum").get("v.value");
        var placeOfStolen = component.find("placeOfLost").get("v.value");
        
        var dateOfLost = component.find("dateOfLost").get("v.value");
        var timeOfLost = component.find("timeOfLost").get("v.value");
        var lastUsedDate = component.find("lastUsedDate").get("v.value");
        var lastPlace = component.find("lastPlace").get("v.value");
        
        var cardSigned = component.find("cardSigned").get("v.checked");
        var haveSafePin = component.find("haveSafePin").get("v.checked");
        var primaryAccHolder = component.find("primaryAccHolder").get("v.checked");
        var custComm = component.find("custComm").get("v.checked");
        
        var homePhone = component.find("homePhone").get("v.value");
        var officePhone = component.find("officePhone").get("v.value");
        
        var cardLostDescr = component.find("cardLostDescr").get("v.value");
        
        var siteCode = component.find("siteCode").get("v.value");
        
        var replaceCard = component.find("replaceCard").get("v.checked");
        var deliveryMethod = component.find("delMethod11").get("v.value");
            //document.getElementById("delMethod11").value;
        var deliveryBranchCode = ''; 
        if(component.get("v.deliverySiteCode")!=null){
            deliveryBranchCode = component.get("v.deliverySiteCode").Site_Code__c;
        }
        //var deliveryBranchCode = component.get("v.deliverySiteCode").Site_Code__c;
		console.log('-====deliveryBranchCode=====>'+deliveryBranchCode);
        console.log('-=========>'+$A.util.isEmpty(circumstance));
        /*
        var field1 = component.find('field1');
        var field1Value = field1.get('v.value');
        field1.set("v.errors", [{message:"Error message"}]);
        */
        
        /***********************VALIDATIONS START********************************/
        if(!$A.util.isEmpty(stopCardReason)){
            $A.util.removeClass(component.find("stopReason"), 'slds-has-error');
            var error = component.find("stopReasonerror");
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("stopReason"), 'slds-has-error');
            var error = component.find('stopReasonerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help');        
        } 
        
        if(!$A.util.isEmpty(circumstance)){
            $A.util.removeClass(component.find("circum"), 'slds-has-error');
            var error = component.find("circumerror");
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("circum"), 'slds-has-error');
            var error = component.find('circumerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help');
        }
        
        if(!$A.util.isEmpty(placeOfStolen)){  
            $A.util.removeClass(component.find("placeOfLost"), 'slds-has-error');  
            var error = component.find("placeOfLosterror");
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("placeOfLost"), 'slds-has-error');
            var error = component.find('placeOfLosterror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help');
            
        }
        
        if(!$A.util.isEmpty(dateOfLost)){
            $A.util.removeClass(component.find("dateOfLost"), 'slds-has-error');  
            var error = component.find("dateOfLosterror");
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("dateOfLost"), 'slds-has-error');
            var error = component.find('dateOfLosterror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help');
        }
        
        if(!$A.util.isEmpty(timeOfLost)){
            $A.util.removeClass(component.find("timeOfLost"), 'slds-has-error');  
            var error = component.find('timeOfLosterror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("timeOfLost"), 'slds-has-error');
            var error = component.find('timeOfLosterror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
            
        }
        
        if(!$A.util.isEmpty(lastUsedDate)){
            $A.util.removeClass(component.find("lastUsedDate"), 'slds-has-error'); 
            var error = component.find('lastUsedDateerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("lastUsedDate"), 'slds-has-error');
            var error = component.find('lastUsedDateerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
            
        }
        
        if(!$A.util.isEmpty(lastPlace)){
            $A.util.removeClass(component.find("lastPlace"), 'slds-has-error');   
            var error = component.find('lastPlaceerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("lastPlace"), 'slds-has-error');
            var error = component.find('lastPlaceerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
            
        }
        if($A.util.isEmpty(homePhone) || isNaN(homePhone)){
            $A.util.addClass(component.find("homePhone"), 'slds-has-error');
            var error = component.find('homePhoneerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
        } else{
            $A.util.removeClass(component.find("homePhone"), 'slds-has-error'); 
            var error = component.find('homePhoneerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        }

        
        if($A.util.isEmpty(officePhone) || isNaN(officePhone)){
            
            $A.util.addClass(component.find("officePhone"), 'slds-has-error');
            var error = component.find('officePhoneerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
        } else{
            $A.util.removeClass(component.find("officePhone"), 'slds-has-error'); 
            var error = component.find('officePhoneerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        }
        
        
        if(!$A.util.isEmpty(cardLostDescr)){
            $A.util.removeClass(component.find("cardLostDescr"), 'slds-has-error'); 
            var error = component.find('cardLostDescrerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        } else{
            $A.util.addClass(component.find("cardLostDescr"), 'slds-has-error');
            var error = component.find('cardLostDescrerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help'); 
            
        }
        
        if($A.util.isEmpty(siteCode) || isNaN(siteCode)){
            $A.util.addClass(component.find("siteCode"), 'slds-has-error');
            var error = component.find('siteCodeerror');
            $A.util.removeClass(error,'slds-hide');
            $A.util.addClass(error,'slds-form-element__help');
        } else{
            $A.util.removeClass(component.find("siteCode"), 'slds-has-error');       
            var error = component.find('siteCodeerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        }
        
        /***********************VALIDATIONS END********************************/
        
        
        var cardJsonString = {
            'reason' : stopCardReason,
            'plasticNbr' : plstCardNumber,
            
            'circumstances': circumstance,
            'cardLostPlace': placeOfStolen,
            'cardLostDate': lastUsedDate,
            'cardLostTime': timeOfLost,
            'cardLastUsedDate': lastUsedDate,
            'cardLastUsedPlace': lastPlace,
            
            'wasCardSigned': cardSigned,
            'didCardHaveSafePin': haveSafePin,
            'doNotUseCard': custComm,
            'sof1': primaryAccHolder,
            
            'homePhone': homePhone,
            'officePhone': officePhone,
            
            'cardLostDiscription': cardLostDescr,
            
            'agentSiteCode': siteCode,
            
            'replaceCard': replaceCard,
            'distReasCode' : deliveryMethod,
            'distSiteCode' : deliveryBranchCode
        }
        console.log('=========>'+JSON.stringify(cardJsonString));

        //var plstCardNumber = '324567';
        //helper.sendSuccessCards(component, event, helper, plstCardNumber);
        
        if(	!$A.util.isEmpty(circumstance) &&!$A.util.isEmpty(placeOfStolen) &&
            !$A.util.isEmpty(dateOfLost) && !$A.util.isEmpty(timeOfLost) &&
            !$A.util.isEmpty(lastUsedDate) && !$A.util.isEmpty(lastPlace) &&
            !$A.util.isEmpty(homePhone) && !$A.util.isEmpty(officePhone) &&
            !$A.util.isEmpty(cardLostDescr) && !$A.util.isEmpty(siteCode) &&
           	!isNaN(homePhone) && !isNaN(officePhone) && !isNaN(siteCode)
        ){
            console.log('SENDING CALLOUT');
            helper.callStopCardService(component, event, helper, cardJsonString);
        } else{
            console.log('PLEASE FILL REQUIRED DETAILS');
        }
        /*
        //Fire Event to Pass data to Main component
        var appEvent = $A.get("e.c:StopReplaceCardEvent");
        appEvent.setParams({
            evtplasticCardNumber : plstCardNumber,
            evtStopCardReason : stopCardReason,
            
            evtcircum : circumstance,
            evtplaceOfLost : placeOfStolen,
        
            evtdateOfLost : dateOfLost,
            evttimeOfLost : timeOfLost,
            evtlastUsedDate : lastUsedDate,
            evtlastPlace : lastPlace,
        
            evtcardSigned : cardSigned,
            evthaveSafePin : haveSafePin,
            evtcustComm : custComm,
            evtprimaryAccHolder : primaryAccHolder,
        
            evthomePhone : homePhone,
            evtofficePhone : officePhone,
        
            evtcardLostDescr : cardLostDescr,
            evtsiteCode : siteCode,
            
            evtReplaceCard : replaceCard,
            evtdeliverySiteCode : deliveryBranchCode
        });
        //appEvent.fire();
        */
    },
    showDeliverySiteCode : function(component, event, helper){
        console.log('CHEKC REPLACE CAR =========>'+component.find("replaceCard").get("v.checked"));
        var replaceCard = component.find("replaceCard").get("v.checked");
        if(replaceCard == true){
            $A.util.removeClass(component.find("deliverySiteCheck"), 'slds-hide');
        } else{
            $A.util.addClass(component.find("deliverySiteCheck"), 'slds-hide');
        }
    },
    handleDeliveryCodeEvent : function(component, event, helper){
        var selectedBranchSiteCode = event.getParam("selectedJob");
        component.set("v.deliverySiteCode",selectedBranchSiteCode);
    },
    onDeliveryMethodChange : function(component, event, helper){
        //var indexvar = event.target.getAttribute('data-record-id');
        /*
        component.set("v.cardNumber",component.get("v.cardNumber"));
        var transDivId = document.getElementById("delMethodCheck 5544351000291020");
        console.log('+++++++transDivId++++++++'+transDivId);
        $A.util.removeClass(transDivId, "slds-hide");
        */
        var cardNum = component.get("v.cardNumber");
        console.log('=IN==>'+cardNum);
        var selectedId = 'delMethod '+cardNum;
        console.log('====selectedId===>'+selectedId);
        console.log('&&&&&&&&&'+document.getElementById("delMethod").value);
        if(document.getElementById("delMethod").value == 'Delivery At Branch'){
            console.log('==IIFFF=>');
            $A.util.removeClass(component.find("delMethodCheck"), 'slds-hide');
            if(component.get("v.deliverySiteCode")!=null){
                $A.util.removeClass(component.find("delMethodCheck"), 'slds-has-error');       
                var error = component.find('branchsiteCodeerror');
                $A.util.removeClass(error,"slds-form-element__help");
                $A.util.addClass(error,'slds-hide');
            } else{
                $A.util.addClass(component.find("delMethodCheck"), 'slds-has-error');
                var error = component.find('branchsiteCodeerror');
                $A.util.removeClass(error,'slds-hide');
                $A.util.addClass(error,'slds-form-element__help'); 
            }
        }else{
            console.log('==EELSEE=>');
            $A.util.addClass(component.find("delMethodCheck"), 'slds-hide');
            $A.util.removeClass(component.find("delMethodCheck"), 'slds-has-error');       
            var error = component.find('branchsiteCodeerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');
        }
    },
    onchangeDM : function(component, event, helper){
        console.log('======NEW VALUE====>'+component.find("delMethod11").get("v.value"));
        var selectedDeliveryMethod = component.find("delMethod11").get("v.value");
        if(selectedDeliveryMethod == 'Delivery At Branch'){
            console.log('==IIFFF=>');
            $A.util.removeClass(component.find("delMethodCheck"), 'slds-hide');
            if(component.get("v.deliverySiteCode")!=null){
                $A.util.removeClass(component.find("delMethodCheck"), 'slds-has-error');       
                var error = component.find('branchsiteCodeerror');
                $A.util.removeClass(error,"slds-form-element__help");
                $A.util.addClass(error,'slds-hide');
            } else{
                $A.util.addClass(component.find("delMethodCheck"), 'slds-has-error');
                var error = component.find('branchsiteCodeerror');
                $A.util.removeClass(error,'slds-hide');
                $A.util.addClass(error,'slds-form-element__help'); 
            }
        } else{
            console.log('==EELSEE=>');
            $A.util.addClass(component.find("delMethodCheck"), 'slds-hide');
            $A.util.removeClass(component.find("delMethodCheck"), 'slds-has-error');       
            var error = component.find('branchsiteCodeerror');
            $A.util.removeClass(error,"slds-form-element__help");
            $A.util.addClass(error,'slds-hide');

        }
        
    }
})