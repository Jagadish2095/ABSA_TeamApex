({
	init : function(cmp, event, helper) {
        
        cmp.set("v.isDisabled",true);
      var availableActions = cmp.get('v.availableActions');
       for (var i = 0; i < availableActions.length; i++) {
         if (availableActions[i] == "NEXT") {
            cmp.set("v.canNext", true);
         } else if (availableActions[i] == "BACK") {
            cmp.set("v.canBack", true);
         } 
           else if (availableActions[i] == "FINISH") {
            cmp.set("v.canFinish", true);
         } 
        
      }
   },
    onButtonPressed: function(cmp, event, helper) {
      var actionClicked = event.getSource().getLocalId();
        if(actionClicked === "BACK"){
            console.log("this is back button");
            var evt = $A.get("e.c:PreviousButtonNotification");
            evt.fire();
            
            var navigate = cmp.get('v.navigateFlow');
            navigate(actionClicked);
        } else  if(actionClicked === "NEXT"){
            console.log("this is next button");
            var evt = $A.get("e.c:NextButtonNotification");
            evt.fire();
            
            var navigate = cmp.get('v.navigateFlow');
            navigate(actionClicked);
            
        } else  if(actionClicked === "FINISH"){
            var va = cmp.get("v.isVACall"); 
            if(va){
                console.log("Inside finish button VA");
                helper.sendEmailToadvisor(cmp, event, helper, actionClicked);    
            }
            else{
                console.log("this is Finish button");
                var evt = $A.get("e.c:FinishButtonNotification");
                evt.fire();
                
                var navigate = cmp.get('v.navigateFlow');
                navigate(actionClicked);
            }
            
        }
       
   },
    
    handleTypeChangeEvent: function(cmp, event, helper) {
        var type = event.getParam("advisorType");
        cmp.set("v.isDisabled",type);
        
   },
    handleNextButton: function(cmp, event, helper) {
        var type = event.getParam("EnableNext");
        cmp.set("v.isDisabled",type);
        
   },
    
    handleNotificationEvent : function(cmp, event, helper) {
        cmp.set("v.isDisabled",false)
    },
    
    handleConfirmationEvent: function(cmp, event, helper) {
        var type = event.getParam("check");
        cmp.set("v.isDisabled",type)
    },
    handlePolicySelectionEvent: function(cmp, event, helper) {
        var type = event.getParam("check");
        cmp.set("v.isDisabled",type)
    },
    handleBNGenerationNCrossSellEvent: function(cmp, event, helper) {
       /* var myCaseId = event.getParam("CurrentCaseId");
        cmp.set("v.recordId2",myCaseId);
        console.log("myCaseId: "+myCaseId);  VK*/
        var type = event.getParam("check");
        var vacall = event.getParam("VA");
        cmp.set("v.isDisabled",type);
        cmp.set("v.isVACall",vacall);
        console.log("isVAcall flag value"+cmp.get("v.isVACall"));
        //cmp.set("v.isDisabled",true)
    },
    handleF2FSearchEvent: function(cmp, event, helper) {
        var type = event.getParam("check");
        cmp.set("v.isDisabled",type)
    },
    handleF2FFinishevent: function(cmp, event, helper) {
        var type = event.getParam("check");
        cmp.set("v.isDisabled",type)
    },
})