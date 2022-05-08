({
    doInit: function (component, event, helper) {
        component.set("v.currencyCode", $A.get('$locale.currency'));
        helper.setTableColumns(component);    
        helper.getClientChallengeData(component);
    },
    
    handleCancelClick: function (component) {
        component.set("v.showConfirmation", false);
    },
    
    //maps voucher fields for record creation & modal view
    handleVoucherHistoryRowAction :function(component, event, helper){
        var selectedRows = event.getParam("selectedRows");
        component.set("v.showChallengeDetails", false);
        component.set("v.showVoucherDetails", true);
        component.set("v.showConfirmation", true);
        
        helper.mapRewardModalView(component, selectedRows);        
        helper.mapRewardRecordCreate(component, selectedRows);
    },
    
    handleRowAction: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        component.set("v.showChallengeDetails", true);
        helper.mapCampaigneChallengeModalView(component, selectedRows);
        component.set("v.showConfirmation", true);
        
        if(selectedRows[0].hasVoucher){
            
            helper.mapCampaigneRewardModalView(component, selectedRows);
            helper.mapCampaigneRewardCreate(component, selectedRows);
            component.set("v.showVoucherDetails", true); 
        }
        
    },
    
    handleSuccess: function (component, event, helper) {
        helper.fireToastEvent("Voucher Attachment", "Voucher attached successfully", "Success");
        component.set("v.showConfirmation", false);
    },
    
    handleOkClick: function (component, event, helper) {
        component.find("recordEditForm").submit();
    },
    
    handleErrors: function (component, event, helper){
        var errorMessage = event.getParams();
        alert(JSON.stringify(errorMessage));
    }
});