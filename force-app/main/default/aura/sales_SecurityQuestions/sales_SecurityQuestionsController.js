({
   closeModal: function(component, event, helper) {
      component.set("v.isModalOpen", false);
      component.set("v.client.securityQuestionsResult", 'Failed');
   },
   passedSecurityQuestions: function(component, event, helper) {
      component.set("v.isModalOpen", false);
      component.set("v.client.securityQuestionsResult", 'Passed');
   },    
})