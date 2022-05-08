/**
* Integration Response Bean for Switching Institutions
* @author André Pietersen
* @created 2020-09-25
*/
public class SwitchingInstitutions_Resp_IB_v1 extends Base_IB {
    public Embedded x_embedded; // in json: _embedded
    public InstitutionLinks x_links; // in json: _links
    public String status;
    public Integer statusCode;
    public String message;

    public class Embedded {
        public List<Item> items;
    }

    public class Item extends Base_IB {    
        public String createdBy;
        public String lastModifiedBy;
        public String creationDate;
        public String lastModifiedDate;
        public String name;
        public String contactPerson;
        public String contactEmail;
        public String contactDepartment;
        public String debitOrderAutomatedEmail;
        public String salaryAutomatedEmail;
        public List<Object> regexPatterns;
        public Long debitOrderAcknowledgeHoursSLA;
        public Long debitOrderResolveHoursSLA;
        public Long salaryAcknowledgeHoursSLA;
        public Long salaryResolveHoursSLA;
        public String route;
        public List<String> categories;
        public String batchFileType;
        public String batchFormatterType;
        public String batchIntegrationType;
        public String connectionPrefix;
        public String template;
        public ItemLinks x_links; // in json: _links
        public Exceptiondetails exceptiondetails;

        public override void setFieldNameSubstitutions() {
            fieldNameSubstitutionMap = new Map<String, String>();            
            fieldNameSubstitutionMap.put('"_links":', '"x_links":');    
        }
    }

    public class ItemLinks {
        public SwitchHRef self;
        public SwitchHRef institution;
        public SwitchHRef history;
    }

    public class SwitchHRef {
        public String href;
    }

    public class InstitutionLinks {
        public SwitchHRef self;
        public SwitchHRef profile;
        public SwitchHRef search;
    }

    public class Exceptiondetails {
        public string status;
        public string message;
    }

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"_embedded":', '"x_embedded":');
        fieldNameSubstitutionMap.put('"_links":', '"x_links":');    
    }
}