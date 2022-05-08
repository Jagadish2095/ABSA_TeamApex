/**@comment : ContentVersionQueueableHandler
* @description ContentVersionQueueableHandler
* @author  Hari
* @since 2021-07-12
* **/
public class ContentVersionQueueableHandler implements Queueable {
    /***
    * @comment : docIdContentVersionMap
    * @description docIdContentVersionMap    
    * **/ 
    public map<id,ContentVersion> docIdContentVersionMap;
    
    /***
    * @comment : ContentVersionQueueableHandler
    * @description contructor
    * @param docIdContentVersionMap
    * **/
    public ContentVersionQueueableHandler(map<id,ContentVersion> docIdContentVersionMap){
        this.docIdContentVersionMap = docIdContentVersionMap ;  
    }
    
     /***
    * @comment : execute 
    * @description Queueable execute method
    * @param context           
    * **/ 
    public void execute(QueueableContext context) {
        try{
			ContentVersionTriggerHandler.getContentDocumentLink(docIdContentVersionMap);
		}catch(exception ex){
			system.debug('exception....'+ex);
		}
		
    }
}