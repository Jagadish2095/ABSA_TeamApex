@isTest
public class InvocableAddBusinessHoursTest {
    
    @isTest
    static void runTest(){
        

        Test.startTest();
        List<InvocableAddBusinessHours.Request> requestList = new List<InvocableAddBusinessHours.Request>();

        InvocableAddBusinessHours.Request request = new InvocableAddBusinessHours.Request();
        List <BusinessHours> businessHour = [Select Id from BusinessHours];
        request.businessHoursId = businessHour[0].Id;
        request.intervalMS = 10000;
        request.startDate = System.today();
        requestList.add(request);
         
        List<InvocableAddBusinessHours.Result> times = InvocableAddBusinessHours.calculateBusinessHours(requestList);
       
        Test.stopTest();
    } 
   
}