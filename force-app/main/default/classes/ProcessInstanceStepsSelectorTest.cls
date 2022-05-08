/**
* @description Test class for ProcessInstanceStepsSelector
* @since 2019-04-29
**/
@isTest 
public class ProcessInstanceStepsSelectorTest {
    
    @isTest
    private static void testSelectById() {
        
        ProcessInstanceStepsSelector testProcessInstanceStepsSelector = new ProcessInstanceStepsSelector();
        Set<Id> testSet = new Set<Id>();
        List<ProcessInstanceStep> processInstanceStepList = testProcessInstanceStepsSelector.selectById(testSet);   
        
    }

}