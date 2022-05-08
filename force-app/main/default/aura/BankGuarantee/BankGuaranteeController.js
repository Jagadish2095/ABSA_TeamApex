({
	doInit : function (component, event, helper) {
        helper.handleInit(component, event,helper);
        helper.getNewAccounts(component);
        //helper.getContracts(component,event,helper);
    },
    onCheckManageAcc : function (component, event, helper){
        helper.handleOnCheckManageAcc(component,event,helper);
         
    },
    manageSelectedAccounts : function(component, event, helper){
        helper.hanldeSelectedAccounts(component,event,helper);
    },
    addNewAccount : function(component, event, helper){
        //component.set('v.isNewAccountCreate',true);
        var newCreditCards = component.get("v.newCreditCards");
        if(newCreditCards<5){
        helper.addNewBankAccount(component);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "The maximum number of accounts that can be done in a single application is 5"
            });
             toastEvent.fire();
        }
    },
    saveAndValidate : function (component, event, helper){
        helper.handleSaveAndValidate(component,event,helper)
    },
    handleShowModal: function (component, event, helper) {
        component.set("v.modRecordId", event.target.id);
        console.log('event.target.id'+event.target.id);
        component.set("v.isModalVisble", true);
        var childCmp = component.find("chqDetails");
        childCmp.reInit(component, event, helper);
        childCmp.toggleModal(component, event, helper);
        
    },
    updateContract: function(component, event, helper)
    {
        helper.saveupdateContract(component, event, helper);
    },
    handleApplicationEvent : function(component, event, helper) {
        var message = event.getParam("checkError");
        console.log('message'+message);
        // set the handler attributes based on event data
        component.set("v.errorMessage", message);
        
       
    },
    dateController : function (component, event, helper) {
    var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    var target = event.getSource();
    var fieldName = target.get("v.fieldName");
    var fieldVal = target.get("v.value");
    var startDate = new Date(fieldVal);
    var endDate = new Date(today);
    var days = (startDate-endDate)/8.64e7;
    if(days>365){
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Requested Review Date cannot be greater than 1 year from current date"
            });
             toastEvent.fire();
    }
        if(days<0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Requested Review Date cannot be a past date"
            });
             toastEvent.fire();
        }
            
    },
})