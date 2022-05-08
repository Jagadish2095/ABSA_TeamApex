/**
 * @description       : AccountEnquiry_Req_IB_V1
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
public with sharing class AccountEnquiry_Req_IB_V1 extends Base_IB {
  /**
   * @description MLB857I_INPUT_AREA
   */
  public class MLB857I_INPUT_AREA {
    @AuraEnabled
    public Long MLB857I_ACCT_NUMBER;
    @AuraEnabled
    public String MLB857I_USER_ID;
    @AuraEnabled
    public String MLB857I_SITE_CODE = 'CUSTOMR1';
  }

  @AuraEnabled
  public NBSAPDPI NBSAPDPI;
  @AuraEnabled
  public NBSMSGI_Z NBSMSGI;
  @AuraEnabled
  public MLB857I MLB857I;

  /**
   * @description NBSMSGI_Z
   */
  public class NBSMSGI_Z {
    @AuraEnabled
    public NBSMSGI NBSMSGI;
  }

  /**
   * @description NBSMSGI
   */
  public class NBSMSGI {
    @AuraEnabled
    public String NBNMSGI_MSG_LANGUAGE = 'E';
    @AuraEnabled
    public String NBNMSGI_MSG_TARGET = 'STD';
  }

  /**
   * @description NBSAPLI
   */
  public class NBSAPLI {
    @AuraEnabled
    public String NBNAPLI_CHANNEL = 'API';
    @AuraEnabled
    public String NBNAPLI_APPLICATION = 'Gateway';
    @AuraEnabled
    public String NBNAPLI_TRACE = '';
  }

  /**
   * @description NBSAPDPI
   */
  public class NBSAPDPI {
    @AuraEnabled
    public NBSAPLI NBSAPLI;
  }

  /**
   * @description MLB857I
   */
  public class MLB857I {
    @AuraEnabled
    public MLB857I_INPUT_AREA MLB857I_INPUT_AREA;
  }

  /**
   * @description
   * @author Mradul Maheshwari | 28-09-2021
   * @return AccountEnquiry_Req_IB_V1
   **/
  public static AccountEnquiry_Req_IB_V1 createDummyRequest() {
    AccountEnquiry_Req_IB_V1 requestBean = new AccountEnquiry_Req_IB_V1();
    NBSAPDPI NBSAPDPI = new NBSAPDPI();

    NBSAPLI NBSAPLI = new NBSAPLI();
    NBSAPLI.NBNAPLI_CHANNEL = 'API';
    NBSAPLI.NBNAPLI_APPLICATION = 'Gateway';
    NBSAPLI.NBNAPLI_TRACE = '';

    NBSAPDPI.NBSAPLI = NBSAPLI;
    requestBean.NBSAPDPI = NBSAPDPI;

    NBSMSGI_Z NBSMSGI_var = new NBSMSGI_Z();
    NBSMSGI NBSMSGI = new NBSMSGI();
    NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
    NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

    NBSMSGI_var.NBSMSGI = NBSMSGI;
    requestBean.NBSMSGI = NBSMSGI_var;

    MLB857I MLB857I = new MLB857I();
    MLB857I_INPUT_AREA MLB857I_INPUT_AREA = new MLB857I_INPUT_AREA();
    MLB857I_INPUT_AREA.MLB857I_ACCT_NUMBER = Long.valueOf('8053285542');
    MLB857I_INPUT_AREA.MLB857I_USER_ID = 'ABGE081';
    MLB857I_INPUT_AREA.MLB857I_SITE_CODE = 'CUSTOMR1';

    MLB857I.MLB857I_INPUT_AREA = MLB857I_INPUT_AREA;
    requestBean.MLB857I = MLB857I;

    return requestBean;
  }
}