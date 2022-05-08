/*
* Response Integration Bean for CIgetPostalCodeV1 Service
* @author Prudence Shirindzi & Updated by Satya Boyenepalli
* @created 2020-10-05 Updated on 2020-10-23
*/

public class CIgetPostalCodeV1_Resp_IB_v1 Extends Base_IB {
    
    public class TableEntry {
        public String noStreetDelivery;
        public String streetPostCode;
        public String postBoxCode;
        public String suburbName;
        public String townOrCityName;
        public String provinceName;
        public String uniqueName;
    }
    
    public class Nbsaplo {
        public String version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
        public String echoKey;
    }
    
    public class Version {
    }
    
    public class Nbsmsgo3 {
        public String version;
        public String sysErrTxt;
        public String nbrUserMsgs;
        public String nbrUserErrs;
    }
    
    public CIgetPostalCodeV1Response CIgetPostalCodeV1Response;
    
    public class CIgetPostalCodeV1Response {
        public Nbsaplo nbsaplo;
        public Nbsmsgo3 nbsmsgo3;
        public Cib603do cib603do;
    }
    
    public class Cib603do {
        public String lastSearchPos;
        public String nbrEntsRetrieved;
        public List<TableEntry> tableEntry;
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
    }
}