@isTest
public class TaskOverdueEmailBatchTest {
    
    
    static testMethod void testMethod1()
    {
        List<user> userlst= new List<User>();
        userlst=[select id,firstname from user where isactive=true limit 200];
        
    List<task> lsttask= new List<task>();
        for(Integer i=0 ;i <10;i++)
        {
            task t = new task();
            t.Subject='call';
            t.ActivityDate=date.parse('2019/07/16');
            t.Status='open';
            t.OwnerId=userlst[i].id;
          //  t.Owner.email='test@gmail.com';
            lsttask.add(t);
        }
        
        insert lsttask;
        
    
    Test.startTest();

            TaskOverdueEmailBatch obj = new TaskOverdueEmailBatch();
            
       
            DataBase.executeBatch(obj); 
         
            
        Test.stopTest();
    }
    
    
    
    static testMethod void testMethodforScheduleable(){
        
        Test.startTest();
        TaskOverdueEmailSchedulable scheduletask =new TaskOverdueEmailSchedulable();
       
            
          String chron = '0 0 8 1/1 * ? *';        
         system.schedule('Test Sched', chron, scheduletask);
        
        Test.stopTest();
    }

}