({
    /****************@ Author: Chandra*******************************
 	****************@ Date: 07/04/2022*******************************
 	****************@ Work Id: W-015288******************************
 	****************@ Description: Method to handle init event******/
    init: function (component, event, helper) {
        var options = [
            { value: "", label: "--None--" },
            { value: "Yes", label: "Yes" },
            { value: "No", label: "No" }
        ];
        component.set("v.options", options);
        component.set('v.activeSections', 'ABSA Credit Protection Plan');
    },
    
    /****************@ Author: Chandra*******************************
 	****************@ Date: 08/04/2022*******************************
 	****************@ Work Id: W-015288******************************
 	****************@ Description: Method to handle toggle event****/
    handleSectionToggle: function (component, event) {
        var openSections = event.getParam('openSections');
    },
    
    /****************@ Author: Chandra*********************************
 	****************@ Date: 08/04/2022*********************************
 	****************@ Work Id: W-015288********************************
 	****************@ Description: Method to handle show modal event**/
    showModal : function(component,event, helper) {
        component.set('v.showPPBenefitsModal', true);
    },
    
    /****************@ Author: Chandra*********************************
 	****************@ Date: 11/04/2022*********************************
 	****************@ Work Id: W-015288********************************
 	****************@ Description: Method to handle modal close event**/
    closeModal : function(component,event, helper) {
        component.set('v.showPPBenefitsModal', false);
    },
    
    /****************@ Author: Chandra*******************************
 	****************@ Date: 11/04/2022*******************************
 	****************@ Work Id: W-015288******************************
 	****************@ Description: Method to handle Accept event****/
    handleAccept : function(component,event, helper) {
        component.set('v.showPPBenefitsModal', false);
        component.set('v.isPPConfirmationCheck', true);
        component.set('v.selectedValue', 'Yes');
    },
    
    /****************@ Author: Chandra*******************************
 	****************@ Date: 12/04/2022*******************************
 	****************@ Work Id: W-015288******************************
 	****************@ Description: Method to handle cancel event****/
    handleCancel : function(component,event, helper) {
        component.set('v.showPPBenefitsModal', false);
        component.set('v.isPPConfirmationCheck', false);
        component.set('v.selectedValue', '');
    },
    
    /****************@ Author: Chandra***********************************************
 	****************@ Date: 12/04/2022***********************************************
 	****************@ Work Id: W-015288**********************************************
 	****************@ Description: Method to handle Confirmation check change event**/
    handleChange : function(component,event, helper) {
        if(component.get('v.isPPConfirmationCheck')){
            component.set('v.selectedValue', 'Yes');
        }else{
            component.set('v.selectedValue', '');
        }
    },
    
    /****************@ Author: Chandra**************************************************
 	****************@ Date: 12/04/2022**************************************************
 	****************@ Work Id: W-015288*************************************************
 	****************@ Description: Method to handle Protection Plan check change event*/
    handlePPCheck : function(component,event, helper) {
        console.log('ABSA Protection Plan Checkbox checked');
    },
})