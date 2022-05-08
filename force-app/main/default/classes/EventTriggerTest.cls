@isTest
public class EventTriggerTest {
    
    public static testMethod void testEventTrigger(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        Event event = new Event();
        event.WhatId = testDataFactory.testOpportunity.id;
        event.StartDateTime = DateTime.now();
        event.DurationInMinutes = 30;
        insert event;

        Test.stopTest();
    }
    
}