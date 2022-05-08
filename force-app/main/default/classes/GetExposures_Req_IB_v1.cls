/**
 * @description       : Integration Request Bean for getExposures service
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-10   Himani Joshi   Initial Version
**/

public class GetExposures_Req_IB_v1 extends Base_IB{
    public NBSAPDPI NBSAPDPI;
    public MSGI MSGI;
    public GSB001I_Z GSB001I;
    /**
  * @author            : Himani Joshi
  * @description       : Property GSB001I
 **/
    public class GSB001I_Z {
        public GSB001I GSB001I;
    }
   /**
 * @author            : Himani Joshi
 * * @description       : Property GSB001I_INPUT_FIELDS
 **/
    public class GSB001I {
        public GSB001I_INPUT_FIELDS GSB001I_INPUT_FIELDS;
    }
    /**
* @author            : Himani Joshi
* @description       : Property clientCode
 **/
    public class GSB001I_INPUT_FIELDS {
        public String clientCode;
    }
    /**
  * @author            : Himani Joshi
  * @description       : Property NBSMSGI
 **/
    public class MSGI {
        public NBSMSGI NBSMSGI;
    }
    /**
  * @author            : Himani Joshi
  * @description       : Property NBNMSGI_MSG_LANGUAGE
 **/
    public class NBSMSGI {
        public String NBNMSGI_MSG_LANGUAGE;
        public String NBNMSGI_MSG_TARGET;
    }
    /**
 * @author            : Himani Joshi
 * * @description       : Property NBSAPLI
 **/
    public class NBSAPDPI {
        public NBSAPLI NBSAPLI;
    }
    /**
* @author            : Himani Joshi
* @description       : Property NBSAPLI
 **/
    public class NBSAPLI {
        public String NBNAPLI_CHANNEL;
        public String NBNAPLI_APPLICATION;
        public String NBNAPLI_TRACE;
    }
}