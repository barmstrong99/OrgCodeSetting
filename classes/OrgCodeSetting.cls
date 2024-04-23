/**
 * This class provides the ablility to dynamically change the settings used in apex code. 
 * 
 * Created by Brian.Armstrong on 2020-11-09.
 * 
 */

global virtual class OrgCodeSetting {

    private final Boolean ONLY_ACTIVE_SETTING = True;
    private final String FORMAT_DT_LOCAL = 'yyyy-MM-dd HH:mm:ss z';

    public boolean CheckIfLoadedAndActive() { return (IsLoaded && IsActive); }
    public boolean CheckIfDeactivateCode() { return (CheckIfLoadedAndActive() && IsDeactivateCode); }
    //public boolean CheckIfActivateCode() { return !CheckDeactivateCode; }

    public boolean IsLoaded {get; private set;}  // is the code setting record loaded into the object. 
    public Datetime LoadedDatetime {get; private set;}
    //public Datetime LastModifiedDate {get; private set;}

    public string MasterLabel {get; private set;}
    public string DeveloperName {get; private set;}
    public string Description {get; private set;}
    public string Version {get; private set;}

    public boolean IsActive {get; private set;} // Is the code setting record active?

    public boolean IsDeactivateCode {get; private set;}
    public boolean DeactivateCodeEmail {get; private set;}
    public boolean SandboxOnly {get; private set;}

    public boolean Debug    {get; private set;}

    public boolean DebugEmail    {get; private set;}
    public string DebugEmailAddress    {get; private set;}
    public List<String> DebugEmailAddresses {get; private set;}

    public string DebugFlags       {get; private set;}
    public boolean IsDebugFlag(string key) { return (null != DebugFlagsMap && null != key && DebugFlagsMap.containsKey(key.toLowerCase())); }
    public string DebugFlagValue(string key) { return (null != DebugFlagsMap && null != key ? DebugFlagsMap.get(key.toLowerCase()) : null); }
    private Map<String, String> DebugFlagsMap {get; private set;}

    public boolean DebugSystem {get; private set;}

    public string OverrideEmailAddress    {get; private set;}
    public List<String> OverrideEmailAddresses {get; private set;}

    public string General {get; private set;}
    public Integer GeneralInt {get; private set;}
    public Boolean GeneralBool {get; private set;}
    public boolean IsGeneralFlag(string key) { return (null != GeneralFlagsMap && null != key && GeneralFlagsMap.containsKey(key.toLowerCase())); }
    public string GeneralFlagValue(string key) { return (null != GeneralFlagsMap && null != key ? GeneralFlagsMap.get(key.toLowerCase()) : null); }
    private Map<String, String> GeneralFlagsMap {get; private set;}

    // Properties exposed only to the apex test class.
    @TestVisible string testDebugFlagsMap;
    @TestVisible string testGeneralFlagsMap;
    @TestVisible boolean testThrowException = false;
    //@TestVisible static boolean testThrowExceptionStatic = false;    

    public OrgCodeSetting() {
        //System.Debug('OrgCodeSetting()');
        IsLoaded = False;
        DeveloperName = '';
        MasterLabel = '';
        IsActive = False;
        IsDeactivateCode = False;
        //SandboxOnly = False;
        Debug = False;
        //DebugSystem = False;
        DebugEmail = False;
        //DebugEmailAddress = null;
        //DebugEmailAddresses = null;
        //DebugFlags = null;
        //DebugFlagsMap = null;
        //OverrideEmailAddress = null;
        //OverrideEmailAddresses = null;
        //General = null;
        //GeneralInt = null;
    }

    public OrgCodeSetting(Org_Code_Setting__mdt org_Code_Setting) {
        IsLoaded = False;

        //System.debug('OrgCodeSetting(Org_Code_Setting__mdt org_Code_Setting), org_Code_Setting: ' + org_Code_Setting);
        LoadCodeSetting(org_Code_Setting);
    }

    public OrgCodeSetting(string className) {
        IsLoaded = False;

        //System.debug('OrgCodeSetting(string className), className: ' + className);
        LoadCodeSetting(className);
    }
   
    static public boolean CheckIsDeactivateCode(string className) {
        //System.debug('OrgCodeSetting.CheckIsDeactivateCode(className: ' + className + ')');
 
        OrgCodeSetting  cs = new OrgCodeSetting();

        Org_Code_Setting__mdt org_Code_Setting = cs.GetCodeSetting(className);
 
        if (null == org_Code_Setting || null == org_Code_Setting.DeactivateCode__c)
            return false;
        
        //System.Debug('DeactivateCode__c: ' + org_Code_Setting.DeactivateCode__c);
        return (org_Code_Setting.DeactivateCode__c);
    }

    public void RunningTest (boolean runningTest) {
        DeveloperName = DeveloperName + '<Test.isRunningTest()=' + runningTest +'>';
        Debug = runningTest ? True : False;
        DebugSystem = runningTest ? True : False;
        DebugEmail = runningTest ? True : False;
    }

    public string ToStringShort() {
        return 'IsLoaded=' + this.IsLoaded + ', ' +
               'LoadedDatetime=' + (null != this.LoadedDatetime ? this.LoadedDatetime.format(FORMAT_DT_LOCAL, UserInfo.getTimeZone().toString()) : 'null') + ', ' +

               'MasterLabel=' + this.MasterLabel + ', ' +
               'DeveloperName=' + this.DeveloperName + ', ' +
               'Description=' + this.Description + ', ' +
               'Version=' + this.Version + ', ' +

               'IsActive=' + this.IsActive  + ', ' +

               'IsDeactivateCode=' + this.IsDeactivateCode + ', ' +
               'DeactivateCodeEmail=' + this.DeactivateCodeEmail + ', ' +
               'SandboxOnly=' + this.SandboxOnly + ', ' +

               'Debug=' + this.Debug  + ', ' +
               'DebugFlags=' + this.DebugFlags + ', ' +
               'DebugEmail=' + this.DebugEmail + ', ' +
               'DebugEmailAddress=' + this.DebugEmailAddress + ', ' +

               'OverrideEmailAddress=' + this.OverrideEmailAddress + ', ' +
               'General=' + this.General; 
    }

    private Org_Code_Setting__mdt GetCodeSetting(string className) {
        //System.Debug('OrgCodeSetting.GetCodeSetting(className: ' + className+')');

        try {
            // test class logic to test the exception logic.
            if (null != testThrowException && testThrowException) {
                System.debug('Test class logic to throw exception');
                throw new MathException();
            }

            if (String.isBlank(className))
                return null;

            List<Org_Code_Setting__mdt> org_Code_Settings = [
                SELECT  Id, MasterLabel, DeveloperName, 
                        Description__c, Version__c,
                        Active__c, 
                        DeactivateCode__c, DeactivateCodeEmail__c, SandboxOnly__c,
                        Debug__c, DebugEmail__c, DebugEmailAddress__c, DebugFlags__c, DebugSystem__c,
                        OverrideEmailAddress__c, General__c //LastModified
                FROM Org_Code_Setting__mdt
                //WHERE DeveloperName = :className and Active__c = :ONLY_ACTIVE_SETTING Limit 1
                WHERE MasterLabel = :className and Active__c = :ONLY_ACTIVE_SETTING Limit 1
            ];
            System.Debug('org_Code_Settings: ' + org_Code_Settings);
            System.Debug('org_Code_Settings.size(): ' + org_Code_Settings.size());

            if (null != org_Code_Settings && 1 == org_Code_Settings.size()) {
                return org_Code_Settings[0];
            }

            return null;
        }
        catch(Exception e){
            return null;
        }
    }

    public void LoadCodeSetting(Org_Code_Setting__mdt org_Code_Setting) {
        //System.debug('OrgCodeSetting.LoadCodeSetting(org_Code_Setting: ' + org_Code_Setting + ')');

        if (null != org_Code_Setting) {
            IsLoaded = true;
            LoadedDatetime = System.now();

            MasterLabel = org_Code_Setting.MasterLabel;
            DeveloperName = org_Code_Setting.DeveloperName;
            Description = org_Code_Setting.Description__c;
            Version = org_Code_Setting.Version__c;

            IsActive = org_Code_Setting.Active__c;
            IsDeactivateCode = org_Code_Setting.DeactivateCode__c;
            DeactivateCodeEmail = org_Code_Setting.DeactivateCodeEmail__c;
            SandboxOnly = org_Code_Setting.SandboxOnly__c;

            Debug = org_Code_Setting.Debug__c;
            DebugSystem = org_Code_Setting.DebugSystem__c;

            DebugEmail = org_Code_Setting.DebugEmail__c;
            if (String.isNotBlank(org_Code_Setting.DebugEmailAddress__c)) {
                DebugEmailAddress = org_Code_Setting.DebugEmailAddress__c;
                DebugEmailAddresses = new List<String>{org_Code_Setting.DebugEmailAddress__c};
            }

            if (String.isNotBlank(org_Code_Setting.DebugFlags__c)) {
                DebugFlags = org_Code_Setting.DebugFlags__c;
                DebugFlagsMap = new Map<String, String>();
                List<String> flags = DebugFlags.split(';');
                if (null != flags && flags.Size() > 0) {
                    for(String flag : flags) {
                        List<String> parts = flag.split('=');
                        if (null != parts && parts.Size() == 2) {
                            DebugFlagsMap.put(parts[0].trim().toLowerCase(), parts[1].trim());
                        }
                    }
                    testDebugFlagsMap = DebugFlagsMap.toString();
                }
            }

            if (String.isNotBlank(org_Code_Setting.OverrideEmailAddress__c)) {
                OverrideEmailAddress = org_Code_Setting.OverrideEmailAddress__c;
                OverrideEmailAddresses = new List<String>{org_Code_Setting.OverrideEmailAddress__c};
            }

            if (String.isNotBlank(org_Code_Setting.General__c)) {
                General = org_Code_Setting.General__c;
                GeneralFlagsMap = new Map<String, String>();
                List<String> flags = General.split(';');
                if (null != flags && flags.Size() > 0) {
                    for(String flag : flags) {
                        List<String> parts = flag.split('=');
                        if (null != parts && parts.Size() == 2) {
                            GeneralFlagsMap.put(parts[0].trim().toLowerCase(), parts[1].trim());
                        }
                    }
                    testGeneralFlagsMap = GeneralFlagsMap.toString();
                }

            }

            if (String.isNotBlank(org_Code_Setting.General__c) && org_Code_Setting.General__c.isNumeric()) {
                Integer i = Integer.valueOf(org_Code_Setting.General__c);
                if (null != i) {
                    GeneralInt = i;
                }
            }

            if (String.isNotBlank(org_Code_Setting.General__c) && org_Code_Setting.General__c.isAlpha()) {
                boolean b = Boolean.valueOf(org_Code_Setting.General__c);
                if (null != b) {
                    GeneralBool = b;
                }
            }

            //LastModifiedDate = org_Code_Setting.LastModified;
        }
        else {
            IsLoaded = false;
            IsActive = false;
            Debug = false;
        }

    }

    public void LoadCodeSetting(string className) {
        //System.debug('OrgCodeSetting.LoadCodeSetting(className: ' + className + ')');

        Org_Code_Setting__mdt org_Code_Setting = GetCodeSetting(className);

        if (null != org_Code_Setting) {
            LoadCodeSetting(org_Code_Setting);
        }
    }

    public string DeactivateCodeEmailAddress(string defaultEmail) {
        if (IsLoaded && IsActive) {
            if (null != OverrideEmailAddresses && 0 < OverrideEmailAddresses.size())
                return OverrideEmailAddresses[0];
        }
        return defaultEmail;
    }

    public string DebugEmailAddressOrDefault(string defaultEmail) {
        if (IsLoaded && IsActive && Debug && DebugEmail) {
            if (null != debugEmailAddresses && 0 < debugEmailAddresses.size())
                return debugEmailAddresses[0];
        }
        return defaultEmail;
    }

    public string OverrideEmailAddressOrDefault(string defaultEmail) {
        if (IsLoaded && IsActive) {
            if (null != OverrideEmailAddresses && 0 < OverrideEmailAddresses.size())
                return OverrideEmailAddresses[0];
        }
        return defaultEmail;
    }

}