/** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @return 
    
    */
global class CAF_SAPRefNo_For_BCMSCase_ScheduleBatch implements Schedulable {
    /** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @param sc 
    
    */
    global void execute(SchedulableContext sc) { 
        CAF_SAPRefNo_For_BCMSCase sapCaseSchedule = new CAF_SAPRefNo_For_BCMSCase(); 
        database.executebatch(sapCaseSchedule);
    }
}