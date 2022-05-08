({
	getStopCardReasons : function(component, event, helper){
        var action = component.get("c.getCardReasons"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.cardReasonsList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getStopCardCircumstances : function(component, event, helper){
        var action = component.get("c.getCardCircumstances"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.cardCircumstancesList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getDeliveryMethods : function(component, event, helper){
        var action = component.get("c.getDeliveryMethods"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.deliveryMethodsList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    callStopCardService : function(component, event, helper, cardJsonString){
        var action1 = component.get("c.makeStopCardsCallOut"); 
        action1.setParams({jsonStr:JSON.stringify(cardJsonString)});
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('============>'+response.getReturnValue());
                var respObj = JSON.parse(response.getReturnValue());
                //console.log('=^^^^^^^'+jsonObject.statusCode);
                console.log('PLASTIC CARD NUMBER'+respObj.plasticCardNum);
                //this.sendSuccessCards(component, event, helper, respObj.plasticCardNum);
                            
                if(respObj.statusCode != 200){
                    var errr = "We cannot complete the request now, please try again if error persist contact administrator";
                    component.set("v.errorMessage",errr);
                    component.set("v.isshowError",true);
                    
                    //component.set("v.responseWrapper",response.getReturnValue());
                    //var toastEvent = this.getToast("Error", "asdfghj", "error");
            		//toastEvent.fire();
                } else{
                    console.log('==CAstpLostStolenCardV2Response===>'+JSON.stringify(respObj.CAstpLostStolenCardV2Response));
                    if(respObj.CAstpLostStolenCardV2Response!=null){
                        var CAstpLostStolenCardV2Response = respObj.CAstpLostStolenCardV2Response;
                        var retResults = CAstpLostStolenCardV2Response.can912o;
                        console.log('=====retResults=====>'+retResults.returnMsg);
                        console.log('=====retResults=====>'+JSON.stringify(retResults.returnMsg));
                        var returnMessage = retResults.returnMsg;
                        if(returnMessage=='CHANGE SUCCESSFUL'){
                            console.log('SUCCESS');
                            component.set("v.isshowError",false);
                            component.set("v.isshowSuccess",true);
                            component.set("v.responseWrapper",respObj);
                            var button = event.getSource();
                            button.set('v.disabled',true);
                            
                            this.sendSuccessCards(component, event, helper, respObj.plasticCardNum);
                            
                        } else if(returnMessage=='STAT CHNG ITEM NOT FND -106024'){
                            console.log('ALREADY STOPPED');
                            //component.set("v.isshowError",false);
                            component.set("v.errorMessage",'This card was already stopped');
                    		component.set("v.isshowError",true);
                        } else if(returnMessage==null){
                            console.log('ERROR');
                            component.set("v.errorMessage",'FAILED');
                    		component.set("v.isshowError",true);
                        }else{
                            console.log('ERROR');
                            component.set("v.errorMessage",returnMessage);
                    		component.set("v.isshowError",true);
                        }
                    }
                    
                }
                
            }
        });
        $A.enqueueAction(action1);
        
    },
    
    sendSuccessCards : function(component, event, helper, plstCardNum){
        console.log('-----sendSuccessCards---'+plstCardNum);
		var appEvent = $A.get("e.c:StopReplaceCardEvent");
        appEvent.setParams({
            evtplasticCardNumber : plstCardNum
        })
        appEvent.fire();
    },
    //Lightning toastie
    getToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        return toastEvent;
    },
    
})