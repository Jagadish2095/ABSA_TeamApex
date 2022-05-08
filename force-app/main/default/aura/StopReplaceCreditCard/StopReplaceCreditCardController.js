({
	doInit : function(component, event, helper) {
        console.log('============>'+component.get("v.clientAccountId"));
        var clientAccountId = component.get("v.clientAccountId");
        //var clientAccountId = '0016E00000t7hWXQAY';
		helper.initGetCardDetails(component, event, helper, clientAccountId);
        helper.getStopReplaceCardWrapper(component, event, helper);
	},
    onChangeFilter : function(component, event, helper){
        console.log(component.find('filterCard').get('v.value'));
        
    },
    showReason : function(component, event, helper){
        
        helper.getStopCardReasons(component, event, helper);        
        var cardChecked = event.getSource().get('v.checked');
        var indexvar = event.getSource().get("v.value");
        var reasonDivId = document.getElementById("chooseReason "+indexvar);
       
        if(cardChecked == true){
            //Hiding Transactions Table
            var transDivId = document.getElementById("transDetailsTable "+indexvar);
            //var transDivId = document.getElementById("transDetailsTable 5544351000291012");
            $A.util.addClass(transDivId, "slds-hide");
            
            //Displaying Card Lost Form
            var cardLostDivId = document.getElementById("cardLostDetails "+indexvar);
            $A.util.removeClass(cardLostDivId, "slds-hide");
        } else{
            //Hiding Transactions Table
            var transDivId = document.getElementById("transDetailsTable "+indexvar);
            //var transDivId = document.getElementById("transDetailsTable 5544351000291012");
            $A.util.removeClass(transDivId, "slds-hide");
            
            //Displaying Card Lost Form
            var cardLostDivId = document.getElementById("cardLostDetails "+indexvar);
            $A.util.addClass(cardLostDivId, "slds-hide");
        }
    },
    onChangeStopReason : function(component, event, helper){
        
        helper.getStopCardCircumstances(component, event, helper);
        
        //var selectedReason = event.getSource().get("v.value");
        
        //var cardChecked = event.getSource().get('v.checked');
        var indexvar = event.target.getAttribute('data-record-id');
        //Hiding Transactions Table
        var transDivId = document.getElementById("transDetailsTable "+indexvar);
        //var transDivId = document.getElementById("transDetailsTable 5544351000291012");
        $A.util.addClass(transDivId, "slds-hide");
        
        //Displaying Card Lost Form
        var cardLostDivId = document.getElementById("cardLostDetails "+indexvar);
        $A.util.removeClass(cardLostDivId, "slds-hide");

        
    },
    showDeliverySiteCode : function(component, event, helper){
        var delSiteCodeChecked = component.find('delSiteCodeCheck').get('v.checked');
        if(delSiteCodeChecked === true){
            $A.util.removeClass(component.find("replaceCardId"), "slds-hide");
        } else{
            $A.util.addClass(component.find("replaceCardId"), "slds-hide");
        }
    	
	},
    handleClick : function(component, event, helper){
        var cardNum = event.currentTarget.getAttribute('data-cardrecord-id');
        var e = document.getElementById("circum 5544351000291012").value;
    },
    handleCardFormDetails : function(component, event, helper){
        var stopedplstnumbers = '';
        var excardNumbers = component.get("v.stopCardNumbersToFlow");
        if(excardNumbers==undefined){
            stopedplstnumbers = event.getParam("evtplasticCardNumber");
        } else{
            stopedplstnumbers = excardNumbers+','+event.getParam("evtplasticCardNumber");
        }
        component.set("v.stopCardNumbersToFlow",stopedplstnumbers);

    },
    submitInfo : function(component, event, helper){
        var finalJson = component.get("v.stopServiceWrapperList");
    },
    
})