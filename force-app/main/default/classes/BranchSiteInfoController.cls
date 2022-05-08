/**
 * @description Branch Site Info Controller
 * @author  Clifford Willers
 * @created 2020-10-29
 */
public without sharing class BranchSiteInfoController {
    /**
    * @description searchNameLike
    * @return List<Map<String,Object>>
    * @param nameLike
    */
    @AuraEnabled
    public static List<Map<String,Object>> searchNameLike(String nameLike)
    {
        List<Map<String,Object>> returnList = new List<Map<String,Object>>();
        string searchName = '%'+nameLike.trim()+'%';
        Site__c[] siteInfo = [Select Name, Site_Code__c
                              From Site__c
                              Where (Name LIKE :searchName
                                     And Responsible_Area__c='Physical Channel - Branch'
                                     And RecordType.Name='Branch Site'
                                     And Active__c=true)
                              WITH SECURITY_ENFORCED];
        for(Site__c siteObj :siteInfo)
        {
            Map<String,Object> mapSite = new Map<String,Object>();
            mapSite.put('Name', siteObj.Name);
            mapSite.put('SiteCode', siteObj.Site_Code__c);
            returnList.add(mapSite);
        }

        return returnList;
    }
}