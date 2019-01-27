//com.company.assembleegameclient.parameters.Parameters

package com.company.assembleegameclient.parameters {
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.ui.options.Options;
import com.company.util.KeyCodes;
import com.company.util.MoreDateUtil;

import flash.display.DisplayObject;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.utils.Dictionary;

import kabam.rotmg.text.model.TextKey;

public class Parameters {
    public static const PORT:int = 2050;
    public static const ALLOW_SCREENSHOT_MODE:Boolean = false;
    public static const FELLOW_GUILD_COLOR:uint = 10944349;
    public static const NAME_CHOSEN_COLOR:uint = 0xFCDF00;
    public static var root:DisplayObject;
    public static const PLAYER_ROTATE_SPEED:Number = 0.003;
    public static const BREATH_THRESH:int = 20;
    public static const SERVER_CHAT_NAME:String = "";
    public static const CLIENT_CHAT_NAME:String = "*Client*";
    public static var suicideMode:Boolean = false;
    public static var suicideAT:int = -1;
    public static const ERROR_CHAT_NAME:String = "*Error*";
    public static const HELP_CHAT_NAME:String = "*Help*";
    public static const GUILD_CHAT_NAME:String = "*Guild*";
    public static const SYNC_CHAT_NAME:String = "*Sync*";
    public static const ASTRAL_CHAT_NAME:String = "*Astral*";
    public static const NEWS_TIMESTAMP_DEFAULT:Number = 1.1;
    public static const NAME_CHANGE_PRICE:int = 1000;
    public static const GUILD_CREATION_PRICE:int = 1000;
    public static var data_:Object = null;
    public static var GPURenderError:Boolean = false;
    public static var blendType_:int = 1;
    public static var projColorType_:int = 0;
    public static var drawProj_:Boolean = true;
    public static var screenShotMode_:Boolean = false;
    public static var screenShotSlimMode_:Boolean = false;
    public static var sendLogin_:Boolean = true;
    public static const REALM_GAMEID:int = 0;
    public static const TUTORIAL_GAMEID:int = -1;
    public static const NEXUS_GAMEID:int = -2;
    public static const RANDOM_REALM_GAMEID:int = -3;
    public static const VAULT_GAMEID:int = -5;
    public static const MAPTEST_GAMEID:int = -6;
    public static const ENABLE_ENCRYPTION:Boolean = true;
    public static const DAILYQUESTROOM_GAMEID:int = -11;
    public static const MAX_SINK_LEVEL:Number = 18;
    public static const TERMS_OF_USE_URL:String = "http://legal.decagames.com/tos/";
    public static const PRIVACY_POLICY_URL:String = "http://legal.decagames.com/privacy/";
    public static const USER_GENERATED_CONTENT_TERMS:String = "/UGDTermsofUse.html";
    public static const RANDOM1:String = "311f80691451c71b09a13a2a6e";
    public static const RANDOM2:String = "72c5583cafb6818995cbd74b80";
    public static const RSA_PUBLIC_KEY:String = ("-----BEGIN PUBLIC KEY-----\n" + "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCKFctVrhfF3m2Kes0FBL/JFeO" + "cmNg9eJz8k/hQy1kadD+XFUpluRqa//Uxp2s9W2qE0EoUCu59ugcf/p7lGuL99Uo" + "SGmQEynkBvZct+/M40L0E0rZ4BVgzLOJmIbXMp0J4PnPcb6VLZvxazGcmSfjauC7" + "F3yWYqUbZd/HCBtawwIDAQAB\n" + "-----END PUBLIC KEY-----");
    private static var savedOptions_:SharedObject = null;
    public static const skinTypes16:Vector.<int> = new <int>[1027, 0x0404, 1029, 1030, 10973, 19494, 19531, 6346, 30056, 5505];
    public static const itemTypes16:Vector.<int> = new <int>[5473, 5474, 5475, 5476, 10939, 19494, 19531, 6347, 5506];
    private static var keyNames_:Dictionary = new Dictionary();

    private static var ctrlrInputNames_:Dictionary = new Dictionary();
    public static var fameBotPortalId:int;
    public static var fameBotPortal:Portal;
    public static var fameBotPortalPoint:Point;
    public static var ssmode:Boolean = false; // TODO
    public static var ignoringSecurityQuestions:Boolean = false;
    public static var Cache_CHARLIST_valid:Boolean = false;
    public static var Cache_CHARLIST_data:String;
    public static var lowCPUMode:Boolean = false;
    public static var dailyCalendar1RunOnce:Boolean = false;
    public static var dailyCalendar2RunOnce:Boolean = false;
    public static var announcedBags:Vector.<int> = new Vector.<int>(0);
    public static var preload:Boolean = false;
    public static var constructToggle:Boolean = false;
    public static var worldMessage:String = "";
    public static var autoAcceptTrades:Boolean;
    public static var autoDrink:Boolean;
    public static var mystics:Vector.<String> = new Vector.<String>(0);
    public static var fameBot:Boolean = false;
    public static var fameBotWatchingPortal:Boolean = false;
    public static var fpmStart:int = -1;
    public static var fpmGain:int = 0;
    public static var VHS:int = 0;
    public static var VHSRecord:Vector.<Point> = new Vector.<Point>();
    public static var VHSRecordLength:int = -1;
    public static var VHSIndex:int = -1;
    public static var VHSNext:Point = new Point();
    public static var followName:String;
    public static var followPlayer:GameObject;
    public static var followingName:Boolean = false;
    public static var timerActive:Boolean;
    public static var phaseChangeAt:int;
    public static var phaseName:String;
    public static const DefaultAAIgnore:Vector.<int> = new <int>[2312, 0x0909, 2370, 2392, 2393, 2400, 2401, 3413, 3418, 3419, 3420, 3421, 3427, 3454, 3638, 3645, 29594, 29597, 29710, 29711, 29742, 29743, 29746, 29748, 29781, 30001];
    public static const DefaultAAException:Vector.<int> = new <int>[2309, 2310, 2311, 3448, 3449, 3472, 3334, 5952, 2354, 2369, 3368, 3366, 3367, 3391, 3389, 3390, 5920, 2314, 3412, 3639, 3634, 2327, 2335, 2336, 1755, 24582, 24351, 24363, 24135, 24133, 24134, 24132, 24136, 3356, 3357, 3358, 3359, 3360, 3361, 3362, 3363, 3364, 2352, 2330, 28780, 28781, 28795, 28942, 28957, 28988, 28938, 29291, 29018, 29517, 24338, 29580, 29712];
    public static const defaultInclusions:Vector.<int> = new <int>[600, 601, 602, 603, 2295, 2296, 2297, 2298, 2524, 2525, 2526, 2527, 8608, 8609, 8610, 8611, 8615, 8617, 8616, 8618, 8962, 9017, 9015, 9016, 9055, 9054, 9052, 9053, 9059, 9058, 9056, 9057, 9063, 9062, 9060, 9061, 32697, 32698, 32699, 32700, 3004, 3005, 3006, 3007, 3088, 3100, 3096, 3091, 3113, 3114, 3112, 3111, 3032, 3033, 3034, 3035, 3177, 3266];
    public static const defaultExclusions:Vector.<int> = new Vector.<int>(0);
    public static const hpPotions:Vector.<int> = new <int>[0x0707, 2594, 2623, 2632, 2633, 2689, 2836, 2837, 2838, 2839, 2795, 2868, 2870, 2872, 2874, 2876];
    public static const mpPotions:Vector.<int> = new <int>[2595, 2634, 2797, 2798, 2840, 2841, 2842, 2843, 2796, 2869, 2871, 2873, 2875, 2877, 3098];
    public static const lmPotions:Vector.<int> = new <int>[2793, 9070, 5471, 9730, 2794, 9071, 5472, 9731];
    public static const raPotions:Vector.<int> = new <int>[2591, 5465, 9064, 9729, 2592, 5466, 9065, 9727, 2593, 5467, 9066, 9726, 2612, 5468, 9067, 9724, 2613, 5469, 9068, 9725, 2636, 5470, 9069, 0x2600];
    public static var abi:Boolean = true;
    public static var syncFollowing:Boolean = false;
    public static var questFollow:Boolean = false;
    public static var famePoint:Point = new Point(0, 0);
    public static var SPOOKYBOINEAR:Boolean; // TODO
    public static var DrownAmount:int = 94;
    public static var reconRealm:ReconnectEvent = null;
    public static var reconDung:ReconnectEvent = null;
    public static var reconVault:ReconnectEvent = null;
    public static var reconNexus:ReconnectEvent = null;
    public static var reconTutor:ReconnectEvent = null;
    public static var reconDaily:ReconnectEvent = null;
    public static var givingPotions:Boolean;
    public static var receivingPots:Boolean;
    public static var potionsToTrade:Vector.<Boolean> = new <Boolean>[false, false, false, false, false, false, false, false, false, false, false, false];
    public static var emptyOffer:Vector.<Boolean> = new <Boolean>[false, false, false, false, false, false, false, false, false, false, false, false];
    public static var recvrName:String;
    public static var dmgCounter:Array = [];
    public static const spamFilter:Vector.<String> = new <String>["oryxsh0p.net", "wh!tebag,net", "wh!tebag.net", "realmshop.info", "rotmgmarket.c", "rotmg.sh0p", "rotmg.shop", "rpgstash,com", "rpgstash.com", "rpgstash com", "realmitems", "reaimitems", "reaimltems", "realmltems", "realmpower,net", "reaimpower.net", "realmpower.net", "reaimpower,net", "rea!mkings.xyz", "buyrotmg.c", "lifepot. org", "-----|", "rotmg,org", "rotmgmax.me", "rotmgmax,me", "rotmgmax_me", "bert"];
    public static var lockRecon:Boolean = false;
    public static var usingPortal:Boolean;
    public static var portalID:int;
    public static var portalSpamRate:int = 80;
    public static var watchInv:Boolean;
    public static var famePointOffset:Number = 0;
    public static var needsMapCheck:int = 0;
    public static var needToRecalcDesireables:Boolean = false;
    public static var fameWaitStartTime:int = 0;
    public static var fameWaitNTTime:int = 0;
    public static var fameWalkSleep_toFountainOrHall:int = 0;
    public static var fameWalkSleep_toRealms:int = 0;
    public static var fameWalkSleep2:int = 0;
    public static var fameWalkSleepStart:int = 0;
    public static var realmJoining:Boolean;
    public static var forceCharId:int = -1;
    public static var ignoredShotCount:int = 0;
    public static var statsChar:String = "◘";
    public static var timerPhaseTimes:Dictionary = new Dictionary();
    public static var timerPhaseNames:Dictionary = new Dictionary();
    public static var oldFSmode:String = StageScaleMode.EXACT_FIT;
    public static var realmName:String;
    public static var warnDensity:Boolean = false;
    public static var playerSkin:int = -1;
    public static var PlayerTex1:int = -1;
    public static var PlayerTex2:int = -1;
    public static var vialHolders:Array = [];

    public static function setTimerPhases():void {
        timerPhaseTimes['{"key":"server.oryx_closed_realm"}'] = 120000;
        timerPhaseTimes['{"key":"server.oryx_minions_failed"}'] = 12000;
        timerPhaseTimes["DIE! DIE! DIE!!!"] = 23000;
        timerPhaseNames['{"key":"server.oryx_closed_realm"}'] = "Realm Closed";
        timerPhaseNames['{"key":"server.oryx_minions_failed"}'] = "Oryx Shake";
        timerPhaseNames["DIE! DIE! DIE!!!"] = "Vulnerable";
    }

    public static function setAutolootDesireables():void {
        var excInc:int;
        var itemType:int;
        for each (var xml:XML in ObjectLibrary.xmlLibrary_) {
            itemType = int(xml.@type);
            var objProps:ObjectProperties = ObjectLibrary.propsLibrary_[itemType];
            if (objProps != null && objProps.isItem_) {
                objProps.desiredLoot_ = false;
                if (objProps.isPotion_ && desiredPotion(itemType)) {
                    objProps.desiredLoot_ = true;
                }
                else {
                    if (Parameters.data_.autoLootWeaponTier != 999 && desiredWeapon(xml, itemType, Parameters.data_.autoLootWeaponTier)) {
                        objProps.desiredLoot_ = true;
                    }
                    else {
                        if (Parameters.data_.autoLootAbilityTier != 999 && desiredAbility(xml, itemType, Parameters.data_.autoLootAbilityTier)) {
                            objProps.desiredLoot_ = true;
                        }
                        else {
                            if (Parameters.data_.autoLootArmorTier != 999 && desiredArmor(xml, itemType, Parameters.data_.autoLootArmorTier)) {
                                objProps.desiredLoot_ = true;
                            }
                            else {
                                if (Parameters.data_.autoLootRingTier != 999 && desiredRing(xml, itemType, Parameters.data_.autoLootRingTier)) {
                                    objProps.desiredLoot_ = true;
                                }
                                else {
                                    if (Parameters.data_.autoLootUTs && desiredUT(xml)) {
                                        objProps.desiredLoot_ = true;
                                    }
                                    else {
                                        if (Parameters.data_.autoLootSkins && desiredSkin(xml, xml.@id)) {
                                            objProps.desiredLoot_ = true;
                                        }
                                        else {
                                            if (Parameters.data_.autoLootPetSkins && desiredPetSkin(xml, xml.@id, int(xml.@type))) {
                                                objProps.desiredLoot_ = true;
                                            }
                                            else {
                                                if (Parameters.data_.autoLootKeys && desiredKey(xml, xml.@id)) {
                                                    objProps.desiredLoot_ = true;
                                                }
                                                else {
                                                    if (Parameters.data_.autoLootMarks && String(xml.@id).indexOf("Mark of ") != -1) {
                                                        objProps.desiredLoot_ = true;
                                                    }
                                                    else {
                                                        if (Parameters.data_.autoLootConsumables && xml.hasOwnProperty("Consumable")) {
                                                            objProps.desiredLoot_ = true;
                                                        }
                                                        else {
                                                            if (Parameters.data_.autoLootSoulbound && xml.hasOwnProperty("Soulbound")) {
                                                                objProps.desiredLoot_ = true;
                                                            }
                                                            else {
                                                                if (Parameters.data_.autoLootEggs != -1 && desiredEgg(xml, Parameters.data_.autoLootEggs)) {
                                                                    objProps.desiredLoot_ = true;
                                                                }
                                                                else {
                                                                    if (Parameters.data_.autoLootFeedPower != -1 && desiredFeedPower(xml, Parameters.data_.autoLootFeedPower)) {
                                                                        objProps.desiredLoot_ = true;
                                                                    }
                                                                    else {
                                                                        if (Parameters.data_.autoLootFameBonus != -1 && desiredFameBonus(xml, Parameters.data_.autoLootFameBonus)) {
                                                                            objProps.desiredLoot_ = true;
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        for each (excInc in Parameters.data_.autoLootExcludes) {
            objProps = ObjectLibrary.propsLibrary_[excInc];
            if (objProps) {
                objProps.desiredLoot_ = false;
            }
        }
        for each (excInc in Parameters.data_.autoLootIncludes) {
            objProps = ObjectLibrary.propsLibrary_[excInc];
            if (objProps) {
                objProps.desiredLoot_ = true;
            }
        }
    }

    public static function handleLootInListCommand():String {
        var includeStr:String = "AutoLoot Inclusion List: \n";
        for each (var inclusionList:int in Parameters.data_.autoLootIncludes) {
            var xml:XML = ObjectLibrary.xmlLibrary_[inclusionList];
            if (xml) {
                var dpId:String;
                if (xml.hasOwnProperty("DisplayId")) {
                    dpId = xml.DisplayId;
                }
                else {
                    dpId = xml.@id;
                }
                includeStr = (includeStr + "(" + inclusionList + ") " + dpId + ", ");
            }
            else {
                includeStr = (includeStr + "(" + inclusionList + "), ");
            }
        }
        return (includeStr);
    }

    public static function handleLootInAddCommand(_arg_1:String):String {
        var itemId:int = int(_arg_1);
        var xml:XML = ObjectLibrary.xmlLibrary_[itemId];
        var dpId:String;
        if (xml.hasOwnProperty("DisplayId")) {
            dpId = xml.DisplayId;
        }
        else {
            dpId = xml.@id;
        }
        if ((Parameters.data_.autoLootIncludes as Vector.<int>).indexOf(itemId) >= 0) {
            return (dpId + " already in inclusions list");
        }
        (Parameters.data_.autoLootIncludes as Vector.<int>).push(itemId);
        Parameters.setAutolootDesireables();
        Parameters.save();
        return ("Added " + dpId + " to inclusions list");
    }

    public static function handleLootInRemCommand(_arg_1:String):String {
        var itemId:int = int(_arg_1);
        var xml:XML = ObjectLibrary.xmlLibrary_[itemId];
        var dpId:String;
        if (xml.hasOwnProperty("DisplayId")) {
            dpId = xml.DisplayId;
        }
        else {
            dpId = xml.@id;
        }
        var _local_4:int = Parameters.data_.autoLootIncludes.indexOf(itemId);
        if (_local_4 >= 0) {
            Parameters.data_.autoLootIncludes.splice(_local_4, 1);
            Parameters.setAutolootDesireables();
            Parameters.save();
            return (("Removed " + dpId) + " from inclusions list");
        }
        return (dpId + " not in inclusions list");
    }

    public static function handleLootExListCommand():String {
        var _local_4:String = "AutoLoot Exclusion List: \n";
        for each (var excId:int in Parameters.data_.autoLootExcludes) {
            var xml:XML = ObjectLibrary.xmlLibrary_[excId];
            if (xml) {
                var _local_2:String;
                if (xml.hasOwnProperty("DisplayId")) {
                    _local_2 = xml.DisplayId;
                }
                else {
                    _local_2 = xml.@id;
                }
                _local_4 = (_local_4 + "(" + excId + ") " + _local_2 + ", ");
            }
            else {
                _local_4 = (_local_4 + "(" + excId + "), ");
            }
        }
        return (_local_4);
    }

    public static function handleLootExAddCommand(_arg_1:String):String {
        var itemId:int = int(_arg_1);
        var xml:XML = ObjectLibrary.xmlLibrary_[itemId];
        var dpId:String;
        if (xml.hasOwnProperty("DisplayId")) {
            dpId = xml.DisplayId;
        }
        else {
            dpId = xml.@id;
        }
        if (Parameters.data_.autoLootExcludes.indexOf(itemId) >= 0) {
            return (dpId + " already in exclusions list");
        }
        Parameters.data_.autoLootExcludes.push(itemId);
        Parameters.setAutolootDesireables();
        Parameters.save();
        return ("Added " + dpId + " to exclusions list");
    }

    public static function handleLootExRemCommand(_arg_1:String):String {
        var itemId:int = int(_arg_1);
        var xml:XML = ObjectLibrary.xmlLibrary_[itemId];
        var dpId:String;
        if (xml.hasOwnProperty("DisplayId")) {
            dpId = xml.DisplayId;
        }
        else {
            dpId = xml.@id;
        }
        var _local_4:int = Parameters.data_.autoLootExcludes.indexOf(itemId);
        if (_local_4 >= 0) {
            Parameters.data_.autoLootExcludes.splice(_local_4, 1);
            Parameters.setAutolootDesireables();
            Parameters.save();
            return ("Removed " + dpId + " from exclusions list");
        }
        return (dpId + " not in exclusions list");
    }

    public static function desiredPotion(_arg_1:int):Boolean {
        if (Parameters.data_.autoLootHPPots) {
            if (hpPotions.indexOf(_arg_1) >= 0) {
                return (true);
            }
        }
        if (Parameters.data_.autoLootMPPots) {
            if (mpPotions.indexOf(_arg_1) >= 0) {
                return (true);
            }
        }
        if (Parameters.data_.autoLootLifeManaPots) {
            if (lmPotions.indexOf(_arg_1) >= 0) {
                return (true);
            }
        }
        if (Parameters.data_.autoLootRainbowPots) {
            if (raPotions.indexOf(_arg_1) >= 0) {
                return (true);
            }
        }
        return (false);
    }

    public static function desiredWeapon(xml:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!(xml.hasOwnProperty("SlotType") && xml.hasOwnProperty("Tier"))) {
            return (false);
        }
        var _local_4:Vector.<int> = new <int>[3, 2, 24, 17, 1, 8];
        return (xml.Tier >= _arg_3 && _local_4.indexOf(xml.SlotType) != -1);
    }

    public static function desiredAbility(xml:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!(("SlotType" in xml) && ("Tier" in xml))) {
            return (false);
        }
        var _local_4:Vector.<int> = new <int>[13, 16, 21, 18, 22, 15, 23, 12, 5, 25, 19, 11, 4, 20];
        return ((xml.Tier >= _arg_3) && (_local_4.indexOf(xml.SlotType) >= 0));
    }

    public static function desiredArmor(xml:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!(xml.hasOwnProperty("SlotType") && xml.hasOwnProperty("Tier"))) {
            return (false);
        }
        var _local_4:Vector.<int> = new <int>[6, 7, 14];
        return (xml.Tier >= _arg_3 && _local_4.indexOf(xml.SlotType) != -1);
    }

    public static function desiredRing(xml:XML, _arg_2:int, _arg_3:int):Boolean {
        if (!(xml.hasOwnProperty("SlotType") && xml.hasOwnProperty("Tier"))) {
            return (false);
        }
        return (xml.Tier >= _arg_3 && xml.SlotType == 9);
    }

    public static function desiredUT(xml:XML):Boolean {
        var _local_2:int;
        if (!xml.hasOwnProperty("SlotType")) {
            return (false);
        }
        if (xml.hasOwnProperty("BagType")) {
            _local_2 = xml.BagType;
        }
        else {
            return (false);
        }
        return (_local_2 == 6 || _local_2 == 9);
    }

    public static function desiredSkin(xml:XML, _arg_2:String):Boolean {
        if (xml.Activate == "UnlockSkin") {
            return (true);
        }
        if (_arg_2.lastIndexOf("Mystery Skin") >= 0) {
            return (true);
        }
        return (false);
    }

    public static function desiredPetSkin(xml:XML, _arg_2:String, _arg_3:int):Boolean {
        var _local_4:Vector.<int> = new <int>[8973, 8974, 8975];
        if (_arg_2.lastIndexOf("Pet Stone") >= 0) {
            return (true);
        }
        if (_local_4.indexOf(_arg_3) >= 0) {
            return (true);
        }
        return (false);
    }

    public static function desiredKey(xml:XML, _arg_2:String):Boolean {
        if (xml.Activate == "CreatePortal") {
            return (true);
        }
        if (_arg_2.indexOf("Mystery Key") >= 0) {
            return (true);
        }
        return (false);
    }

    public static function desiredEgg(xml:XML, _arg_2:int):Boolean {
        var rareTypes:int;
        if (xml.hasOwnProperty("Rarity")) {
            if (xml.Rarity == "Common") {
                rareTypes = 0;
            }
            else {
                if (xml.Rarity == "Uncommon") {
                    rareTypes = 1;
                }
                else {
                    if (xml.Rarity == "Rare") {
                        rareTypes = 2;
                    }
                    else {
                        if (xml.Rarity == "Legendary") {
                            rareTypes = 3;
                        }
                    }
                }
            }
            return (rareTypes >= _arg_2);
        }
        return (false);
    }

    public static function desiredFeedPower(xml:XML, fpThresh:int):Boolean {
        return (xml.hasOwnProperty("feedPower") && xml.feedPower >= fpThresh);
    }

    public static function desiredFameBonus(xml:XML, fameThresh:int):Boolean {
        return (xml.hasOwnProperty("FameBonus") && xml.FameBonus >= fameThresh);
    }


    public static function load():void {
        try {
            savedOptions_ = SharedObject.getLocal("AssembleeGameClientOptions", "/");
            data_ = savedOptions_.data;
        }
        catch (error:Error) {
            data_ = {};
        }
        setDefaults();
        setIgnores();
        Options.calculateIgnoreBitmask();
        setTimerPhases();
        setAutolootDesireables();
        save();
    }

    public static function setIgnores():void {
        var _local_3:ObjectProperties;
        for each (var _local_1:int in Parameters.data_.AAIgnore) {
            if (_local_1 in ObjectLibrary.propsLibrary_) {
                _local_3 = ObjectLibrary.propsLibrary_[_local_1];
                _local_3.ignored = true;
            }
            if (_local_1 in ObjectLibrary.xmlLibrary_) {
                ObjectLibrary.xmlLibrary_[_local_1].props_.ignored = true;
            }
        }
        for each (var _local_2:int in Parameters.data_.AAException) {
            if (_local_2 in ObjectLibrary.propsLibrary_) {
                _local_3 = ObjectLibrary.propsLibrary_[_local_2];
                _local_3.excepted = true;
            }
            if (_local_2 in ObjectLibrary.xmlLibrary_) {
                ObjectLibrary.xmlLibrary_[_local_2].props_.excepted = true;
            }
        }
    }

    public static function save():void {
        try {
            if (savedOptions_ != null) {
                savedOptions_.flush();
            }
        }
        catch (error:Error) {
        }
    }

    private static function setDefaultKey(_arg_1:String, _arg_2:uint):void {
        if (!data_.hasOwnProperty(_arg_1)) {
            data_[_arg_1] = _arg_2;
        }
        keyNames_[_arg_1] = true;
    }

    public static function setKey(_arg_1:String, _arg_2:uint):void {
        var _local_3:String;
        for (_local_3 in keyNames_) {
            if (data_[_local_3] == _arg_2) {
                data_[_local_3] = KeyCodes.UNSET;
            }
        }
        data_[_arg_1] = _arg_2;
    }

    private static function setDefault(_arg_1:String, _arg_2:*):void {
        if (!data_.hasOwnProperty(_arg_1)) {
            data_[_arg_1] = _arg_2;
        }
    }

    public static function isGpuRender():Boolean {
        return (!GPURenderError && data_.GPURender && !Map.forceSoftwareRender);
    }

    public static function clearGpuRenderEvent(_arg_1:Event):void {
        clearGpuRender();
    }

    public static function clearGpuRender():void {
        GPURenderError = true;
    }

    public static function setDefaults():void {

        setDefault("gameVersion", "X31.2.0");
        /* Experimental*/
        setDefault("disableEnemyParticles", true);
        setDefault("disableAllyShoot", 1);
        setDefault("disablePlayersHitParticles", true);
        setDefault("toggleToMaxText", true);
        setDefault("newMiniMapColors", true);
        setDefault("noParticlesMaster", true);
        setDefault("noAllyNotifications", true);
        setDefault("noAllyDamage", true);
        setDefault("noEnemyDamage", true);
        setDefault("forceEXP", 2);
        setDefault("showFameGain", true);
        setDefault("curseIndication", true);

        /*Graphic*/
        setDefaultKey("toggleFullscreen", KeyCodes.UNSET);
        setDefaultKey("toggleHPBar", KeyCodes.H);
        setDefaultKey("particleEffect", KeyCodes.P);
        setDefaultKey("toggleProjectiles", KeyCodes.N);
        setDefaultKey("toggleMasterParticles", KeyCodes.M);
        setDefault("showHPBarOnAlly", false);
        setDefault("showEXPFameOnAlly", false);
        setDefault("showTierTag", true);
        setDefault("uiQuality", false);
        setDefault("particleEffect", false);
        setDefaultKey("GPURenderToggle", KeyCodes.UNSET);
        if (Capabilities.playerType == "Desktop") {
            setDefault("GPURender", false);
        }
        else {
            setDefault("GPURender", true);
        }
        setDefault("toggleBarText", 1);
        setDefault("cursorSelect", "0");
        setDefault("drawShadows", false);
        setDefault("textBubbles", true);
        setDefault("fullscreenMode", false);
        setDefault("showProtips", false);
        setDefault("showQuestPortraits", true);
        setDefault("protipIndex", 0);
        setDefault("cameraAngle", 0);
        setDefault("defaultCameraAngle", 0);
        setDefault("showGuildInvitePopup", true);
        setDefault("showBeginnersOffer", false);
        setDefault("beginnersOfferTimeLeft", 0);
        setDefault("beginnersOfferShowNow", false);
        setDefault("beginnersOfferShowNowTime", 0);
        setDefault("autoMana", 0);

        /*Controls*/
        setDefaultKey("moveLeft", KeyCodes.A);
        setDefaultKey("moveRight", KeyCodes.D);
        setDefaultKey("moveUp", KeyCodes.W);
        setDefaultKey("moveDown", KeyCodes.S);
        setDefaultKey("rotateLeft", KeyCodes.Q);
        setDefaultKey("rotateRight", KeyCodes.E);
        setDefaultKey("useSpecial", KeyCodes.SPACE);
        setDefaultKey("interact", KeyCodes.NUMBER_0);
        setDefaultKey("useInvSlot1", KeyCodes.NUMBER_1);
        setDefaultKey("useInvSlot2", KeyCodes.NUMBER_2);
        setDefaultKey("useInvSlot3", KeyCodes.NUMBER_3);
        setDefaultKey("useInvSlot4", KeyCodes.NUMBER_4);
        setDefaultKey("useInvSlot5", KeyCodes.NUMBER_5);
        setDefaultKey("useInvSlot6", KeyCodes.NUMBER_6);
        setDefaultKey("useInvSlot7", KeyCodes.NUMBER_7);
        setDefaultKey("useInvSlot8", KeyCodes.NUMBER_8);
        setDefaultKey("escapeToNexus2", KeyCodes.F5);
        setDefaultKey("escapeToNexus", KeyCodes.R);
        setDefaultKey("autofireToggle", KeyCodes.I);
        setDefaultKey("scrollChatUp", KeyCodes.PAGE_UP);
        setDefaultKey("scrollChatDown", KeyCodes.PAGE_DOWN);
        setDefaultKey("miniMapZoomOut", KeyCodes.MINUS);
        setDefaultKey("miniMapZoomIn", KeyCodes.EQUAL);
        setDefaultKey("resetToDefaultCameraAngle", KeyCodes.Z);
        setDefaultKey("togglePerformanceStats", KeyCodes.UNSET);
        setDefaultKey("options", KeyCodes.O);
        setDefaultKey("toggleCentering", KeyCodes.X);
        setDefaultKey("chat", KeyCodes.ENTER);
        setDefaultKey("chatCommand", KeyCodes.SLASH);
        setDefaultKey("tell", KeyCodes.TAB);
        setDefaultKey("guildChat", KeyCodes.G);
        setDefaultKey("testOne", KeyCodes.PERIOD);
        setDefaultKey("useHealthPotion", KeyCodes.F);
        setDefaultKey("friendList", KeyCodes.UNSET);
        setDefaultKey("useMagicPotion", KeyCodes.V);
        setDefaultKey("switchTabs", KeyCodes.B);

        /*Autoloot*/
        setDefaultKey("AutoLootHotkey", KeyCodes.COMMA);
        setDefault("AutoLootOn", true);
        setDefault("autoLootExcludes", Parameters.defaultExclusions);
        setDefault("autoLootIncludes", Parameters.defaultInclusions);
        setDefault("autoLootUpgrades", false);
        setDefault("autoLootWeaponTier", 13);
        setDefault("autoLootAbilityTier", 6);
        setDefault("autoLootArmorTier", 14);
        setDefault("autoLootRingTier", 6);
        setDefault("autoLootSkins", true);
        setDefault("autoLootPetSkins", true);
        setDefault("autoLootKeys", true);
        setDefault("autoLootHPPots", true);
        setDefault("autoLootMPPots", true);
        setDefault("autoLootHPPotsInv", true);
        setDefault("autoLootMPPotsInv", false);
        setDefault("autoLootLifeManaPots", true);
        setDefault("autoLootRainbowPots", true);
        setDefault("autoLootUTs", true);
        setDefault("autoLootFameBonus", 5);
        setDefault("autoLootFeedPower", -1);
        setDefault("autoLootMarks", false);
        setDefault("autoLootConsumables", false);
        setDefault("autoLootSoulbound", false);
        setDefault("autoLootEggs", 1);
        setDefault("autoDrinkFromBags", false);

        /*Auto Aim/Ability*/
        setDefaultKey("pbToggle", KeyCodes.UNSET);
        setDefaultKey("PassesCoverHotkey", KeyCodes.UNSET);
        setDefaultKey("AAHotkey", KeyCodes.N);
        setDefaultKey("AAModeHotkey", KeyCodes.M);
        setDefaultKey("AutoAbilityHotkey", KeyCodes.PERIOD);
        setDefault("AutoHealPercentage", 99);
        setDefault("BossPriority", true);
        setDefault("autohpPotDelay", 400);
        setDefault("spamPrism", false);
        setDefault("AAOn", true);
        setDefault("AATargetLead", true);
        setDefault("AABoundingDist", 4);
        setDefault("aimMode", 2);
        setDefault("AutoAbilityOn", false);
        setDefault("AutoNexus", 25);
        setDefault("AutoHeal", 65);
        setDefault("autoHPPercent", 40);
        setDefault("abilTimer", true);
        setDefault("perfectBomb", true);
        setDefault("AntiSpookiBoiDecoi", false);
        setDefault("AAException", DefaultAAException);
        setDefault("AAIgnore", DefaultAAIgnore);
        setDefault("passThroughInvuln", true);
        setDefault("autoaimAtInvulnerable", false);
        setDefault("spellbombHPThreshold", 3000);
        setDefault("skullHPThreshold", 800);
        setDefault("skullTargets", 5);
        setDefault("aaDistance", 1);
        setDefault("onlyAimAtExcepted", false);
        setDefault("PassesCover", true);
        setDefault("AutoResponder", true);
        setDefault("requestHealPercent", 55);
        setDefault("followIntoPortals", true);
        setDefault("disableNexus", false);
        setDefault("dynamicHPcolor", true);
        setDefault("fixTabHotkeys", true);
        setDefault("damageIgnored", false);
        setDefault("shootAtWalls", false);

        /*Fame Stuff*/
        setDefaultKey("syncLeadHotkey", KeyCodes.UNSET);
        setDefaultKey("syncFollowHotkey", KeyCodes.UNSET);
        setDefaultKey("famebotToggleHotkey", KeyCodes.LEFT);
        setDefault("fameOryx", false);
        setDefault("fameBlockTP", false);
        setDefault("fameBlockAbility", false);
        setDefault("fameBlockCubes", false);
        setDefault("fameBlockGodsOnly", false);
        setDefault("fameBlockThirsty", false);
        setDefault("addMoveRecPoint", false);
        setDefault("trainOffset", 500);
        setDefault("densityThreshold", 625);
        setDefault("teleDistance", 64);
        setDefault("famebotContinue", 0);
        setDefault("fameTpCdTime", 5000);
        setDefault("famePointOffset", 0.1);
        setDefaultKey("TogglePlayerFollow", KeyCodes.F9);
        setDefault("multiLeader", "");
        setDefault("multiBox", false);
		
		/**/
        setDefault("ignoreGroundDmg", false); // removed for public release ✓
        setDefault("gapZero", false); // removed for public release ✓
        setDefault("dmg", false); // removed for public release ✓
        setDefault("delayBetweenGroundDmg", 10000); // removed for public release ✓
        setDefault("noclipV2", false); // removed for public release ✓
        setDefault("noclipOld", false); // removed for public release ✓
        setDefault("halfClip", false); // removed for public release ✓
        setDefault("dungeonCompleteExploit", false); // removed for public release ✓
        setDefaultKey("dungeonReconnectBypassHotkey", KeyCodes.UNSET); // removed for public release ✓
        setDefault("predictMovement", false); // removed for public release ✓
        setDefault("fameLockNearbyClusters", false); // removed for public release ✓
        setDefault("lockRange", 5); // removed for public release ✓
        setDefault("avoidWalls", true); // removed for public release ✓
        setDefault("avoidRange", 0.2); // removed for public release ✓
        setDefault("autoDodge", false); // removed for public release ✓
        setDefaultKey("autoDodgeHotkey", KeyCodes.UNSET); // removed for public release ✓
        setDefault("stopHooks", false); // removed for public release ✓
        setDefault("bulletTracers", false); // removed for public release ✓
        setDefault("bulletTracersAlpha", 0.5); // removed for public release ✓

        /*Debuffs*/
        setDefault("ignoreStatusText", false);
        setDefault("ignoreQuiet", false);
        setDefault("ignoreWeak", false);
        setDefault("ignoreSlowed", false);
        setDefault("ignoreSick", false);
        setDefault("ignoreDazed", false);
        setDefault("ignoreStunned", false);
        setDefault("ignoreParalyzed", false);
        setDefault("ignoreBleeding", false);
        setDefault("ignoreArmorBroken", false);
        setDefault("ignorePetStasis", false);
        setDefault("ignorePetrified", false);
        setDefault("ignoreSilenced", false);
        setDefault("ignoreBlind", true);
        setDefault("ignoreHallucinating", true);
        setDefault("ignoreDrunk", true);
        setDefault("ignoreConfused", true);
        setDefault("ignoreUnstable", true);
        setDefault("ignoreDarkness", true);
        setDefault("ssdebuffBitmask", 0);
        setDefault("ssdebuffBitmask2", 0);
        setDefault("ccdebuffBitmask", 0);
        setDefaultKey("kdbAll", KeyCodes.UNSET);
        setDefaultKey("kdbArmorBroken", KeyCodes.UNSET);
        setDefaultKey("kdbBleeding", KeyCodes.UNSET);
        setDefaultKey("kdbSilenced", KeyCodes.UNSET);
        setDefaultKey("kdbDazed", KeyCodes.UNSET);
        setDefaultKey("kdbParalyzed", KeyCodes.UNSET);
        setDefaultKey("kdbSick", KeyCodes.UNSET);
        setDefaultKey("kdbSlowed", KeyCodes.UNSET);
        setDefaultKey("kdbStunned", KeyCodes.UNSET);
        setDefaultKey("kdbWeak", KeyCodes.UNSET);
        setDefaultKey("kdbQuiet", KeyCodes.UNSET);
        setDefaultKey("kdbPetStasis", KeyCodes.UNSET);
        setDefaultKey("kdbPetrify", KeyCodes.UNSET);
        setDefaultKey("kdbPre1", KeyCodes.UNSET);
        setDefaultKey("kdbPre2", KeyCodes.UNSET);
        setDefaultKey("kdbPre3", KeyCodes.UNSET);
        setDefaultKey("kdbSilenced", KeyCodes.UNSET);
        setDefault("dbPre1", ["Preset 1", 0, false]);
        setDefault("dbPre2", ["Preset 2", 0, false]);
        setDefault("dbPre3", ["Preset 3", 0, false]);

        /*Chat*/
        setDefault("forceChatQuality", false);
        setDefault("hidePlayerChat", false);
        setDefault("chatStarRequirement", 2);
        setDefault("chatAll", true);
        setDefault("chatWhisper", true);
        setDefault("chatGuild", true);
        setDefault("chatTrade", true);
        setDefault("filterLanguage", true);
        setDefault("chatFriend", false);
        setDefault("friendStarRequirement", 0);
        setDefault("chatNameColor", 0);
        setDefault("chatLength", 10);
        setDefault("spamFilter", spamFilter);

        /*Notifier*/
        setDefault("eventNotifier", false);
        setDefault("eventNotifierVolume", 1);
        setDefault("notifySkull", true);
        setDefault("notifyCube", true);
        setDefault("notifyPentaract", true);
        setDefault("notifySphinx", true);
        setDefault("notifyHermit", true);
        setDefault("notifyLotLL", true);
        setDefault("replaceCon", false);
        setDefault("notifyGhostShip", false);
        setDefault("notifyAvatar", false);
        setDefault("notifyStatues", false);
        setDefault("notifyRockDragon", false);
        setDefault("notifyNest", false);
        setDefault("notifyLostSentry", false);
        setDefault("notifyPumpkinShrine", false);
        setDefault("notifyZombieHorde", false);
        setDefault("notifyTurkeyGod", false);
        setDefault("notifyBeachBum", true);
        setDefault("earrapeNotifier", false);

        /*Sound Shit*/
        setDefault("playMusic", false);
        setDefault("playSFX", false);
        setDefault("playPewPew", false);
        if (data_.hasOwnProperty("playMusic") && data_.playMusic == true) {
            setDefault("musicVolume", 1);
        }
        else {
            setDefault("musicVolume", 0);
        }
        if (data_.hasOwnProperty("playSFX") && data_.playMusic == true) {
            setDefault("SFXVolume", 1);
        }
        else {
            setDefault("SFXVolume", 0);
        }

        /*Other shit*/
        setDefault("friendList", KeyCodes.UNSET);
        setDefault("clickForGold", false);
        setDefaultKey("toggleRealmQuestDisplay", KeyCodes.C);
        setDefault("contextualPotionBuy", false);
        setDefault("inventorySwap", true);
        setDefault("tradeWithFriends", false);
        setDefault("HPBar", 1);
        setDefault("characterGlow", 0);
        setDefault("gravestones", 0);
        setDefault("playerObjectType", 782);
        setDefault("centerOnPlayer", true);
        setDefault("preferredServer", null);
        setDefault("bestServer", null);
        setDefault("needsTutorial", false);
        setDefault("needsRandomRealm", false);
        setDefault("joinDate", MoreDateUtil.getDayStringInPT());
        setDefault("lastDailyAnalytics", null);
        setDefault("allowRotation", true);
        setDefault("allowMiniMapRotation", false);
        setDefault("charIdUseMap", {});
        setDefault("paymentMethod", null);
        setDefault("watchForTutorialExit", false);
        setDefault("skipPopups", true);
        setDefault("XYZdistance", 1);
        setDefault("tiltCam", false);
        setDefaultKey("XYZleftHotkey", KeyCodes.UNSET);
        setDefaultKey("XYZupHotkey", KeyCodes.UNSET);
        setDefaultKey("XYZdownHotkey", KeyCodes.UNSET);
        setDefaultKey("XYZrightHotkey", KeyCodes.UNSET);
        if (!data_.hasOwnProperty("needsSurvey")) {
            data_.needsSurvey = data_.needsTutorial;
            switch (int((Math.random() * 5))) {
                case 0:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (5 * 60);
                    data_.surveyGroup = "5MinPlaytime";
                    return;
                case 1:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (10 * 60);
                    data_.surveyGroup = "10MinPlaytime";
                    return;
                case 2:
                    data_.surveyDate = 0;
                    data_.playTimeLeftTillSurvey = (30 * 60);
                    data_.surveyGroup = "30MinPlaytime";
                    return;
                case 3:
                    data_.surveyDate = (new Date().time + ((((1000 * 60) * 60) * 24) * 7));
                    data_.playTimeLeftTillSurvey = (2 * 60);
                    data_.surveyGroup = "1WeekRealtime";
                    return;
                case 4:
                    data_.surveyDate = (new Date().time + ((((1000 * 60) * 60) * 24) * 14));
                    data_.playTimeLeftTillSurvey = (2 * 60);
                    data_.surveyGroup = "2WeekRealtime";
                    return;
            }
        }

        /* Extra*/
        setDefaultKey("tradeNearestPlayerKey", KeyCodes.UNSET);
        setDefaultKey("QuestTeleport", KeyCodes.UNSET);
        setDefaultKey("ReconRealm", KeyCodes.P);
        setDefaultKey("RandomRealm", KeyCodes.LEFTBRACKET);
        setDefaultKey("ReconVault", KeyCodes.K);
        setDefaultKey("ReconDaily", KeyCodes.UNSET);
        setDefaultKey("TombCycleKey", KeyCodes.UNSET);
        setDefaultKey("anchorTeleport", KeyCodes.UNSET);
        setDefaultKey("DrinkAllHotkey", KeyCodes.UNSET);
        setDefault("expandRealmQuestsDisplay", true);
        setDefaultKey("SelfTPHotkey", KeyCodes.UNSET);
        setDefault("ignoreIce", true);
        setDefault("offsetWeapon", false);
        setDefault("usernames", []);
        setDefault("logins", []);
        setDefault("instaNexus", true);
        setDefault("showAOGuildies", false);
        setDefault("etheriteDisable", true);
        setDefault("offsetColossus", true);
        setDefault("voidbowDisable", true);
        setDefault("spiritdaggerDisable", true);
        setDefault("cultistStaffDisable", true);
        setDefault("passwords", []);
        setDefault("showEnemyCounter", true);
        setDefault("FocusFPS", false);
        setDefault("bgFPS", 10);
        setDefault("showTimers", true);
        setDefault("fgFPS", 60);
        setDefault("AutoSyncClientHP", false);
        setDefault("extraPlayerMenu", true);
        setDefault("safeWalk", true);
        setDefault("reconDelay", 250);
        setDefault("dodBot", false);
        setDefault("dodComplete", 0);
        setDefault("cacheCharList", true);
        setDefault("customSounds", true);
        setDefault("customVolume", 1);
        setDefault("autoClaimCalendar", true);
        setDefault("TradeDelay", true);
        setDefault("traceMessage", false);
        setDefault("rightClickOption", "Off");
        setDefaultKey("msg1key", KeyCodes.F1);
        setDefaultKey("msg2key", KeyCodes.F2);
        setDefaultKey("msg3key", KeyCodes.F3);
        setDefaultKey("msg4key", KeyCodes.F4);
        setDefault("msg1", "/pause");
        setDefault("msg2", "He lives and reigns and conquers the world");
        setDefault("msg3", "black");
        setDefault("msg4", "ready");
        setDefault("anchorName", "");
        setDefault("instaTradeSelect", false);
        setDefaultKey("resetClientHP", KeyCodes.UNSET);
        setDefault("TombCycleBoss", 3368);
        setDefaultKey("mboxToggle", KeyCodes.UNSET);

        setDefault("hackerMode", false);
        setDefault("playerSize", 25);
        setDefault("pSize", true);
        setDefault("NoClip", false);
        setDefaultKey("NoClipKey", KeyCodes.UNSET);

        /*Visual*/
        setDefaultKey("LowCPUModeHotKey", KeyCodes.MINUS);
        setDefaultKey("Cam45DegInc", KeyCodes.UNSET);
        setDefaultKey("Cam45DegDec", KeyCodes.UNSET);
        setDefaultKey("sskey", KeyCodes.DELETE);
        setDefault("stageScale", StageScaleMode.NO_SCALE);
        setDefault("hideLockList", true);
        setDefault("hidePets", true);
        setDefault("hideOtherDamage", true);
        setDefault("mscale", 1);
        setDefault("uiscale", false);
        setDefault("alphaOnOthers", false);
        setDefault("alphaMan", 0.4);
        setDefault("lootPreview", "vault");
        setDefault("showDamageAndHP", "base");
        setDefault("showDamageAndHPColorized", true);
        setDefault("liteMonitor", true);
        setDefault("showClientStat", true);
        setDefault("liteParticle", true);
        setDefault("autoDecrementHP", true);
        setDefault("bigLootBags", true);
        setDefault("evenLowerGraphics", true);
        setDefault("showCHbar", true);
        setDefault("showTradePopup", true);
        setDefault("mobNotifier", false);
        setDefault("showMobInfo", false);
        setDefault("questHUD", false);
        setDefault("newHUD", false);
        setDefault("hideLowCPUModeChat", false);
        setDefault("selectedItemColor", 0);
        setDefault("cNameBypass", false);
        setDefault("showDyes", true);
        setDefault("showSkins", true);
        setDefault("nsetSkin", ["", -1]);
        setDefault("customUI", true);
        setDefault("mapHack", false);
        setDefault("noRotate", true);
        setDefault("showHighestDps", "off");
        setDefault("setTex1", -1);
        setDefault("setTex2", -1);
        setDefault("showBG", true);
        setDefault("lastTab", TextKey.OPTIONS_CONTROLS);
    }


}
}//package com.company.assembleegameclient.parameters

