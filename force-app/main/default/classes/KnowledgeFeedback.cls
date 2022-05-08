global class KnowledgeFeedback implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        List<KnowledgeArticle> articles =
            [
                SELECT
                Id
                FROM
                KnowledgeArticle
            ];
        
        Set<Id> articleIds = (new Map<Id,KnowledgeArticle>(articles)).keySet();
        
        /*
        List<Vote> votes = 
            [
                SELECT 
                Id,
                ParentId,
                Type
                FROM 
                Vote 
                WHERE 
				Type = 'Down'
                AND
                ParentId IN :articleIds
                
            ];
        */
        
        
        // Create a task for each opportunity in the list
        //TaskUtils.remindOwners(opptys);
    }
    
}