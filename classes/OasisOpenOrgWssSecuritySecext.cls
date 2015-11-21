public class OasisOpenOrgWssSecuritySecext 
{
    // Timestamp class
    public class Timestamp
    {
    
        Public Timestamp()
        {
            this.Created = this.generatecreatedTimestamp();
            this.Expires = this.generateexpiredTimestamp();
        }
        Public String Created;
        Public String Expires;
        private String[] Created_type_info = new String[]{'wsu:Created','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','string','0','1','false'};
        private String[] Expires_type_info = new String[]{'wsu:Expires','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'Created','Expires'};
        // Generate created timestamp in GMT
        public String generatecreatedTimestamp()
        {
           /*Datetime now = Datetime.now();
           String createdDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
           return createdDate;*/
           
           String createdDate = DateTime.now().addminutes(-5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
           System.debug('Security - Created Date: ' + createdDate);
           return createdDate;
        }
        // Generate expires timestamp in GMT
        public String generateexpiredTimestamp()
        {
           /*Datetime now = Datetime.now().addminutes(5);
           String expiresDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
           return expiresDate;*/
           
           String expiresDate = DateTime.now().addMinutes(5).formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');          
           System.debug('Security - Expired Date: ' + expiresDate);           
           return expiresDate;
        }
    }  
  
    public class PasswordElement {
        public String Password;
        public String PasswordType = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText';
  
        private String[] Password_type_info = new String[]{'Password','http://www.w3.org/2001/XMLSchema','string','0','1','false'}; 
        private String[] PasswordType_att_info = new String[]{'Type'};

        
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','false','false'};
        private String[] field_order_type_info = new String[]{};
  
        public PasswordElement(String password) {
           this.Password = password;
        }                
    }  
  
  
           
    // UserToken Class
    public class UsernameToken 
    {
        // Constructor for UsernameToken used to pass in username and password parameters
        public UsernameToken(String username, String password)
        {
            this.Username = username;
            //this.Password = new OasisOpenOrgWssSecuritySecext.PasswordElement(password);
            this.Password = password;
            this.Nonce = generateNounce();
            this.Created = generateTimestamp();
            
            System.debug('User Token - UserName: ' + this.Username);
            System.debug('User Token - Password: ' + this.Password);
            System.debug('User Token - Nonce: '    + this.Nonce);
            System.debug('User Token - Created: '  + this.Created);            
        }

        public String Username;
        //public PasswordElement Password;
        public String Password;
        public String Nonce;
        public String Created;
      
            
        private String[] Username_type_info = new String[]{'Username','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','string','0','1','false'};
        private String[] Password_type_info = new String[]{'Password', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText','0','1','false'};
        private String[] Nonce_type_info = new String[]{'Nonce', 'http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','string','0','1','false'};
        private String[] Created_type_info = new String[]{'wsu:Created','http://www.wildblue.viasat.com/XMLSchema/PublicWebService/v1.0/PWSHeader','string','0','1','false'};        
        
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','true','false'};
        
        private String[] field_order_type_info = new String[]{'Username','Password','Nonce','Created'};

        // Generate Nounce, random number base64 encoded
        public String generateNounce()
        {
            Long randomLong = Crypto.getRandomLong();
            return EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(randomLong)));
        }

        // Generate timestamp in GMT
        public String generateTimestamp()
        {
           /*Datetime now = Datetime.now();
           String createdDate = ''+now.yearGmt()+'-'+now.monthGmt()+'-'+now.dayGmt()+'T'+now.hourGmt()+':'+now.minuteGmt()+':'+now.secondGmt()+'Z';
           return createdDate;*/
           
           String createdDate = DateTime.now().formatgmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
           System.debug('User Token - Created: ' + createdDate);           
           return createdDate;
        }
    }

    // SecurityHeaderType Class
    public class SecurityHeaderType 
    {       
        // Constructor for SecurityHeaderType used to pass in username and password parameters and instantiate the UsernameToken object     
        public SecurityHeaderType(String username, String password)
        {
            this.UsernameToken = new OasisOpenOrgWssSecuritySecext.UsernameToken(username, password);
            this.Timestamp = new OasisOpenOrgWssSecuritySecext.Timestamp();
        }
       

        public String wsuNamespace = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';              
        public OasisOpenOrgWssSecuritySecext.Timestamp Timestamp;
        public OasisOpenOrgWssSecuritySecext.UsernameToken UsernameToken;        
        private String[] UsernameToken_type_info = new String[]{'UsernameToken','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','UsernameToken','1','1','false'};
        private String[] Timestamp_type_info = new String[]{'wsu:Timestamp','http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','UsernameToken','1','1','false'};
        private String[] wsuNamespace_att_info = new String[]{'xmlns:wsu'};               
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'Timestamp','UsernameToken'};
    }
}