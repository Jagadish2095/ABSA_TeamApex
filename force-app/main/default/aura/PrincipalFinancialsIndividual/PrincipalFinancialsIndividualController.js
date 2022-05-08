({
	doInit : function(component, event, helper) {
        helper.handleInit(component);
	},
    onSubmit : function(component, event, helper) {
        helper.handleSubmit(component);
    },
    handleAssetsOwnerTotalChange : function(component, event, helper){
        helper.updateAssetsOwnerTotal(component);
	},
    handleAssetsBranchTotalChange : function(component, event, helper){
    	helper.updateAssetsBranchTotal(component);
	},
    handleLiabilitiesOwnerTotalChange : function(component, event, helper){
    	helper.updateLiabilitiesOwnerTotal(component);
	},
    handleLiabilitiesBranchTotalChange : function(component, event, helper){
    	helper.updateLiabilitiesBranchTotal(component);
	},
    handleFixedPropertyOwnerTotal : function(component, event, helper){
    	helper.updateFixedPropertyOwnerTotal(component);
	},
    handleFixedPropertyBranchTotal : function(component, event, helper){
    	helper.updateFixedPropertyBranchTotal(component);
	},
    onDeedsOfficeDetailsChange : function(component, event, helper){
        helper.handleDeedsOfficeDetailsChange(component);
    }
})