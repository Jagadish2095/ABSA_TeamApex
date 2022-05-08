/**
* @description Test class for ProcessInstancesSelector
* @since 2019-04-29
**/
@isTest
public class ProcessInstancesSelectorTest {

    @isTest
    private static void testSelectById() {

        ProcessInstancesSelector testProcessInstancesSelector = new ProcessInstancesSelector();
        Set<Id> testSet = new Set<Id>();
        List<ProcessInstance> processInstanceList = testProcessInstancesSelector.selectById(testSet);

    }

    @isTest
    private static void testSelectByIdWithProcessInstanceSteps() {

        ProcessInstancesSelector testProcessInstancesSelector = new ProcessInstancesSelector();
        Set<Id> testSet = new Set<Id>();
        List<ProcessInstance> processInstanceList = testProcessInstancesSelector.selectByIdWithProcessInstanceSteps(testSet);

    }

    // PJAIN: 20200710: W-005081
    @isTest
    private static void testSelectByTargetObjectId() {

        ProcessInstancesSelector testProcessInstancesSelector = new ProcessInstancesSelector();
        Set<Id> testSet = new Set<Id>();
        List<ProcessInstance> processInstanceList = testProcessInstancesSelector.selectByObjectIdAndProcessNames(testSet, new List<String>{'Test Process'});
    }
}