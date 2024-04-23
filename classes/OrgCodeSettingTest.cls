/**
 * Created by Brian.Armstrong on 2020-11-12.
 */

@IsTest
private class OrgCodeSettingTest {

    static List<String> DEBUG_FLAGS = new List<String>{'DoBool','DoInt','DoString','', null};
    static List<String> GENERAL_FLAGS = new List<String>{'DoBool','DoInt','DoString','', null};

    static string TEST_CLASSNAME = OrgCodeSetting.class.getName();
    static string CLASSNAME_TEST1 = TEST_CLASSNAME + 'Test1';
    static string CLASSNAME_TEST2 = TEST_CLASSNAME + 'Test2';
    static string CLASSNAME_BADNAME = 'BAD_NAME_ZZZ';

    static List<String> TESTING_CLASSNAMES = new List<String>{
            TEST_CLASSNAME, CLASSNAME_TEST1, CLASSNAME_TEST2,
                        CLASSNAME_BADNAME, '', null
    };

    static string CODE_IS_DISABLED = '*** Code is disabled! ***';

    private class DebugSetting extends OrgCodeSetting {
        boolean TestA {get; private set;}
        Integer TestB {get; private set;}
        String  TestC {get; private set;}

        DebugSetting() {
            LoadCodeSetting(OrgCodeSetting.class.getName());

            if (Test.isRunningTest())
                RunningTest(Test.isRunningTest());

            TestA = True;
            TestB = 0;
            TestC = '';
        }
    }
    static DebugSetting debugSetting;

    @IsTest
    static void testConstructors() {
        //System.Debug('testConstructors');

        OrgCodeSetting cs = new OrgCodeSetting();
        System.debug('cs = new OrgCodeSetting()');
        System.debug('cs.IsLoaded: ' + cs.IsLoaded);
        System.debug('cs.testThrowException: ' + cs.testThrowException);
        cs = null;

        for (string className : TESTING_CLASSNAMES) {
            System.debug('className: ' + className);
            cs = new OrgCodeSetting(className);
            if (null == cs) {
                System.debug('cs = null!');
            }
            cs = null;
            System.debug('');
        }

        debugSetting = new DebugSetting();
        System.debug('debugSetting: ' + debugSetting);
        System.debug('debugSetting.TestA: ' + debugSetting.TestA);
        System.debug('debugSetting.TestB: ' + debugSetting.TestB);
        System.debug('debugSetting.TestC: ' + debugSetting.TestC);
    }

    static void ShowMethodReturns(OrgCodeSetting cs){
        System.debug('cs: ' + cs);

        System.debug('cs.toString(): ' + cs.toString());
        System.debug('cs.ToStringShort(): ' + cs.ToStringShort());
        System.debug('cs.IsLoaded: ' + cs.IsLoaded);
        System.debug('cs.IsActive: ' + cs.IsActive);
        System.debug('cs.CheckIfLoadedAndActive(): ' + cs.CheckIfLoadedAndActive());
        if (cs.CheckIfLoadedAndActive()) { }
        System.debug('cs.IsDeactivateCode: ' + cs.IsDeactivateCode);
        System.debug('cs.CheckIfDeactivateCode(): ' + cs.CheckIfDeactivateCode());
        if (cs.CheckIfDeactivateCode()) { System.debug('*** Deactivate code ***'); }
        System.debug('cs.DeactivateCodeEmailAddress(): ' + cs.DeactivateCodeEmailAddress(Constants.statusEmailAddresses[0]));
        System.debug('cs.DebugEmailAddressOrDefault(): ' + cs.DebugEmailAddressOrDefault(Constants.debugEmailAddresses[0]));
        System.debug('cs.OverrideEmailAddressOrDefault(): ' + cs.OverrideEmailAddressOrDefault(Constants.exceptionEmailAddresses[0]));
    }

    @IsTest
    static void testMethods() {
        //System.Debug('testMethods');

        string className = TEST_CLASSNAME;

        OrgCodeSetting  cs = new OrgCodeSetting();
        System.debug('cs.DeactivateCodeEmailAddress(): ' + cs.DeactivateCodeEmailAddress(Constants.statusEmailAddresses[0]));
        System.debug('cs.DebugEmailAddressOrDefault(): ' + cs.DebugEmailAddressOrDefault(Constants.debugEmailAddresses[0]));
        System.debug('cs.OverrideEmailAddressOrDefault(): ' + cs.OverrideEmailAddressOrDefault(Constants.exceptionEmailAddresses[0]));
        cs.RunningTest(True);
        cs.RunningTest(false);
        cs = null;

        for (string cn : TESTING_CLASSNAMES) {
            System.debug('');
            System.debug('className: "' + cn + '"');
            cs = new OrgCodeSetting();
            cs.LoadCodeSetting(cn);
            ShowMethodReturns(cs);
        }

        for (string cn : TESTING_CLASSNAMES) {
            System.debug('');
            System.debug('className: "' + cn + '"');
            cs = new OrgCodeSetting(cn);
            ShowMethodReturns(cs);
        }

        cs = new OrgCodeSetting();
        System.debug('cs.testThrowException: ' + cs.testThrowException);
        cs.testThrowException = true;
        System.debug('cs.testThrowException: ' + cs.testThrowException);
        cs.LoadCodeSetting(className);
        cs = null;
    }

    static void ShowProperties(OrgCodeSetting cs){
        System.debug('cs: ' + cs);

        System.debug('IsLoaded: ' + cs.IsLoaded);
        System.debug('LoadedDatetime: ' + cs.LoadedDatetime);

        System.debug('MasterLabel: ' + cs.MasterLabel);
        System.debug('DeveloperName: ' + cs.DeveloperName);
        System.debug('Description: ' + cs.Description);
        System.debug('Version: ' + cs.Version);
        
        System.debug('IsActive: ' + cs.IsActive);
        System.debug('IsDeactivateCode: ' + cs.IsDeactivateCode);
        System.debug('DeactivateCodeEmail: ' + cs.DeactivateCodeEmail);
        System.debug('SandboxOnly: ' + cs.SandboxOnly);

        System.debug('Debug: ' + cs.Debug);
        System.debug('DebugFlags: ' + cs.DebugFlags);
        System.debug('DebugEmail: ' + cs.DebugEmail);
        System.debug('DebugEmailAddress: ' + cs.DebugEmailAddress);
        System.debug('DebugEmailAddresses: ' + cs.DebugEmailAddresses);
        System.debug('testDebugFlagsMap: ' + cs.testDebugFlagsMap);
        System.debug('DebugSystem: ' + cs.DebugSystem);

        System.debug('OverrideEmailAddress: ' +  cs.OverrideEmailAddress);
        System.debug('OverrideEmailAddresses: ' + cs.OverrideEmailAddresses);

        System.debug('General: ' + cs.General);
        System.debug('GeneralInt: ' + cs.GeneralInt);
        System.debug('GeneralBool: ' + cs.GeneralBool);
        System.debug('testGeneralFlagsMap: ' + cs.testGeneralFlagsMap);
    }

    static void testIfProperties(OrgCodeSetting cs){
        if (cs.IsLoaded == null) {}
        if (cs.LoadedDatetime == null) {}
        if (cs.IsActive){}

        if (cs.IsDeactivateCode){}
        if (cs.DeactivateCodeEmail == null) {}
        if (cs.SandboxOnly) {}

        if (cs.Debug){}
        if (cs.DebugEmail) {}
        if (cs.DebugEmailAddress == null){}
        if (cs.DebugEmailAddresses == null){}
        if (cs.DebugFlags == null) {}
        if (cs.DebugSystem) {}

        if (cs.OverrideEmailAddress == null){}
        if (cs.OverrideEmailAddresses == null){}
        if (cs.General == null){}
        if (cs.GeneralInt == null){}
        if (cs.GeneralBool == null){}

        for (String flag : DEBUG_FLAGS) {
            if (cs.IsDebugFlag(flag)) {
                System.debug('flag: ' + flag);
                System.debug('value: ' + cs.DebugFlagValue(flag));
            }
        }

        for (String flag : GENERAL_FLAGS) {
            if (cs.IsGeneralFlag(flag)) {
                System.debug('flag: ' + flag);
                System.debug('value: ' + cs.GeneralFlagValue(flag));
            }
        }

    }

    @IsTest
    static void testProperties() {
        //System.Debug('testProperties');

        string className = OrgCodeSetting.class.getName();
        OrgCodeSetting  cs = new OrgCodeSetting(className);

        ShowProperties(cs);

        if (null != cs && cs.IsLoaded) {
            testIfProperties(cs);
        }

        cs = null;
    }


    @IsTest
    static void testMockData() {
        //System.Debug('testMockData');

        List<Org_Code_Setting__mdt> codeSettings = new List<Org_Code_Setting__mdt>();

        codeSettings.Add(null);
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = false, DeveloperName = 'MockData'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = false, DeactivateCode__c = true, SandboxOnly__c = true));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, Debug__c = true, DebugFlags__c = 'DoBool=True; DoBool2=False; DoInt=2020; DoString = ABCD'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, Debug__c = true, DebugEmail__c = true, DebugEmailAddress__c = 'testA@company.com'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, General__c = '1000'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, General__c = 'true'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, General__c = 'DoBool=True; DoBool2=False; DoInt=2020; DoString = ABCD'));
        codeSettings.Add(new Org_Code_Setting__mdt(Active__c = true, DebugSystem__c = true, OverrideEmailAddress__c = 'testA@company.com', SandboxOnly__c = true));

        for(Org_Code_Setting__mdt csRecord : codeSettings) {
            System.debug('Org_Code_Setting__mdt: ' + csRecord);
            OrgCodeSetting cs = new OrgCodeSetting(csRecord);

            ShowProperties(cs);

            if (null != cs && cs.IsLoaded) {

                System.debug('cs.toString(): ' + cs.toString());
                System.debug('cs.ToStringShort(): ' + cs.ToStringShort());

                testIfProperties(cs);
            }

            cs = null;
        }
    }

    @IsTest
    static void testStaticMethods() {
        //System.Debug('testStaticMethods');

        for (string cn : TESTING_CLASSNAMES) {
            System.debug('');
            System.debug('className: "' + cn + '"');

            //OrgCodeSetting.testThrowExceptionStatic = false;
            boolean isDeactivatedCode = OrgCodeSetting.CheckIsDeactivateCode(cn);
            System.debug('isDeactivatedCode: ' + isDeactivatedCode);
            if (isDeactivatedCode) {
                System.debug(CODE_IS_DISABLED);
            }
        }
    }

    // Setup any test data needed by the test methods.
    @testSetup static void testSetupData() {
        System.Debug('testSetupData');

        // Create any data needed.

        // Add a custom metadata entry?
    }
}