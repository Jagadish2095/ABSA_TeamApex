@isTest
public with sharing class ActionPlanTemplateVersionSelectorTest {
    
    static testMethod void testSelectById(){
        Set<Id> idSet = new Set<Id>();
        Set<String> nameSet = new Set<String>();
        
        Test.startTest();
        
        try {
            List<ActionPlanTemplateVersion> templateList = new ActionPlanTemplateVersionSelector().selectById(idSet);
            
        }catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage());
        }
        
         try {
            List<ActionPlanTemplateVersion> templateList2 = new ActionPlanTemplateVersionSelector().selectByActionPlanTemplateName('Test');
            
        }catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage());
        }
        
         try {
            List<ActionPlanTemplateVersion> templateList3 = new ActionPlanTemplateVersionSelector().selectByTemplateName(nameSet);
            
        }catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage());
        }
        
          try {
            List<ActionPlanTemplateVersion> templateList3 = new ActionPlanTemplateVersionSelector().selectByActionPlanTemplateId(idSet);
            
        }catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage());
        }
        Test.stopTest();
    }
}