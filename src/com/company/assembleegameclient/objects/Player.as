//com.company.assembleegameclient.objects.Player

package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.particles.HealingEffect;
import com.company.assembleegameclient.objects.particles.LevelUpEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.TradeSlot;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.ConditionEffect;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.CachingColorTransformer;
import com.company.util.ConversionUtil;
import com.company.util.GraphicsUtil;
import com.company.util.IntPoint;
import com.company.util.MoreColorUtil;
import com.company.util.MoreStringUtil;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.net.Socket;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import io.decagames.rotmg.supportCampaign.data.SupporterFeatures;
import io.decagames.rotmg.ui.popups.signals.CloseAllPopupsSignal;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.constants.UseType;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.model.UseBuyPotionVO;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.game.signals.UseBuyPotionSignal;
import kabam.rotmg.messaging.impl.data.StatData;
import kabam.rotmg.stage3D.GraphicsFillExtra;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.BitmapTextFactory;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.model.TabStripModel;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class Player extends Character {

    public static const MS_BETWEEN_TELEPORT:int = 10000;
    public static const MS_REALM_TELEPORT:int = 120000;
    private static const MOVE_THRESHOLD:Number = 0.4;
    public static var isAdmin:Boolean = false;
    public static var isMod:Boolean = false;
    private const potionVO:UseBuyPotionVO = new UseBuyPotionVO(2594, UseBuyPotionVO.CONTEXTBUY);
    private static const NEARBY:Vector.<Point> = new <Point>[new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1)];
    private static var newP:Point = new Point();
    private static const RANK_OFFSET_MATRIX:Matrix = new Matrix(1, 0, 0, 1, 2, 2);
    private static const NAME_OFFSET_MATRIX:Matrix = new Matrix(1, 0, 0, 1, 20, 1);
    private static const MIN_MOVE_SPEED:Number = 0.004;
    private static const MAX_MOVE_SPEED:Number = 0.0096;
    private static const MIN_ATTACK_FREQ:Number = 0.0015;
    private static const MAX_ATTACK_FREQ:Number = 0.008;
    private static const MIN_ATTACK_MULT:Number = 0.5;
    private static const MAX_ATTACK_MULT:Number = 2;
    private static const MAX_LOOT_DIST:Number = 1;
    private static const VAULT_CHEST:int = 1284;
    private static const DOD_PATH_X:Array = [125, 125, 132, 132, 129, 129, 132, 132, 130, 131, 129, 128];
    private static const DOD_PATH_Y:Array = [228, 224, 223, 217, 217, 212, 212, 209, 208, 203, 203, 129];

    public var xpTimer:int;
    public var skinId:int;
    public var skin:AnimatedChar;
    public var isShooting:Boolean;
    public var creditsWereChanged:Signal = new Signal();
    public var fameWasChanged:Signal = new Signal();
    private var exitGame:ExitGameSignal;
    private var closeAllPopups:CloseAllPopupsSignal;
    private var famePortrait_:BitmapData = null;
    public var lastSwap_:int = -1;
    public var accountId_:String = "";
    public var credits_:int = 0;
    public var tokens_:int = 0;
    public var numStars_:int = 0;
    public var fame_:int = 0;
    public var nameChosen_:Boolean = false;
    public var currFame_:int = -1;
    public var nextClassQuestFame_:int = -1;
    public var requestHealNumber:int = 0;
    public var legendaryRank_:int = -1;
    public var guildName_:String = null;
    public var guildRank_:int = -1;
    public var isFellowGuild_:Boolean = false;
    public var breath_:int = -1;
    public var maxMP_:int = 200;
    public var mp_:Number = 0;
    public var nextLevelExp_:int = 1000;
    public var exp_:int = 0;
    public var attack_:int = 0;
    public var speed_:int = 0;
    public var dexterity_:int = 0;
    public var vitality_:int = 0;
    public var wisdom_:int = 0;
    public var maxHPBoost_:int = 0;
    public var maxMPBoost_:int = 0;
    public var attackBoost_:int = 0;
    public var defenseBoost_:int = 0;
    public var speedBoost_:int = 0;
    public var vitalityBoost_:int = 0;
    public var wisdomBoost_:int = 0;
    public var dexterityBoost_:int = 0;
    public var xpBoost_:int = 0;
    public var healthPotionCount_:int = 0;
    public var magicPotionCount_:int = 0;
    public var supporterFlagWasChanged:Signal = new Signal();
    public var attackMax_:int = 0;
    public var defenseMax_:int = 0;
    public var speedMax_:int = 0;
    public var dexterityMax_:int = 0;
    public var vitalityMax_:int = 0;
    public var wisdomMax_:int = 0;
    public var maxHPMax_:int = 0;
    public var maxMPMax_:int = 0;
    public var hasBackpack_:Boolean = false;
    public var starred_:Boolean = false;
    public var ignored_:Boolean = false;
    public var distSqFromThisPlayer_:Number = 0;
    protected var rotate_:Number = 0;
    public var supporterFlag:int = 0;
    public var relMoveVec_:Point = null;
    protected var moveMultiplier_:Number = 1;
    public var attackPeriod_:int = 0;
    public var nextAltAttack_:int = 0;
    public var nextTeleportAt_:int = 0;
    public var dropBoost:int = 0;
    public var tierBoost:int = 0;
    protected var healingEffect_:HealingEffect = null;
    protected var nearestMerchant_:Merchant = null;
    public var isDefaultAnimatedChar:Boolean = true;
    public var projectileIdSetOverrideNew:String = "";
    public var projectileIdSetOverrideOld:String = "";
    public var addTextLine:AddTextLineSignal;
    private var factory:CharacterFactory;
    private var ip_:IntPoint = new IntPoint();
    private var breathBackFill_:GraphicsSolidFill = null;
    private var breathBackPath_:GraphicsPath = null;
    private var breathFill_:GraphicsSolidFill = null;
    private var breathPath_:GraphicsPath = null;

    public var clientHp:int = 100;
    public var hp2:int;
    public var healBuffer:int = 0;
    public var healBufferTime:int = 0;
    public var hpLog:Number = 0;
    public var autoNexusNumber:int = 0;
    public var autoHealNumber:int = 0;
    public var autoHpPotNumber:int = 0;
    public var followVec:Point = new Point(0, 0);
    public var followPos:Point = new Point(0, 0);
    public var followLanded:Boolean = false;
    public var conMoveVec:Point = null;
    public var mousePos_:Point = new Point(0, 0);
    public var lastAutoAbilityAttempt:int = 0;
    public var lastHpPotTime:int = 0;
    public var lastTpTime_:int = 0;
    public var ticksHPLastOff:int = 0;
    public var questMob:GameObject;
    public var questMob1:GameObject;
    public var questMob2:GameObject;
    public var questMob3:GameObject;
    private var socketCreated:Boolean;

    private var tx:Number;
    private var ta:Number;
    private var ty:Number;


    //private var fX:Number;
    //private var fY:Number;
    //private var fA:Number;


    private var lastManaUse:int = 0;
    private var potionInventoryModel:PotionInventoryModel;
    private var useBuyPotionSignal:UseBuyPotionSignal;

    private var target:Boolean;
    public var movingTo:Boolean;
    private var socket:Socket;
    public var lastLootTime:int = 0;
    public var collect:int;
    private var previousDamaging:Boolean = false;
    private var previousWeak:Boolean = false;
    private var previousBerserk:Boolean = false;
    private var previousDaze:Boolean = false;
    public var dodCounter:int = 0;
    private var timerStep:int = 500;
    private var timerCount:int = 1;
    private var startTime:int = 0;
    private var endCount:int = 0;
    public var select_:int = -1;
    private var nextSelect:int = 0;
    private var loopStart:int = 4;

    public function Player(_arg_1:XML) {
        var _local_2:Injector = StaticInjectorContext.getInjector();
        this.addTextLine = _local_2.getInstance(AddTextLineSignal);
        this.exitGame = _local_2.getInstance(ExitGameSignal);
        this.closeAllPopups = _local_2.getInstance(CloseAllPopupsSignal);
        this.factory = _local_2.getInstance(CharacterFactory);
        this.useBuyPotionSignal = _local_2.getInstance(UseBuyPotionSignal);
        this.potionInventoryModel = _local_2.getInstance(PotionInventoryModel);
        super(_arg_1);
        this.attackMax_ = int(_arg_1.Attack.@max);
        this.defenseMax_ = int(_arg_1.Defense.@max);
        this.speedMax_ = int(_arg_1.Speed.@max);
        this.dexterityMax_ = int(_arg_1.Dexterity.@max);
        this.vitalityMax_ = int(_arg_1.HpRegen.@max);
        this.wisdomMax_ = int(_arg_1.MpRegen.@max);
        this.maxHPMax_ = int(_arg_1.MaxHitPoints.@max);
        this.maxMPMax_ = int(_arg_1.MaxMagicPoints.@max);
        this.texturingCache_ = new Dictionary();
    }

    private function onError(param1:Event):void {
    }

    private function ioError(param1:Event):void {
    }

    public function setTarget(numTx:Number, numTy:Number):void {
        this.tx = numTx;
        this.ty = numTy;
        this.ta = Number(Math.atan2(numTy - this.y_, numTx - this.x_));
        this.target = true;
    }

    public function distance():Number {
        var calcTx:Number = this.tx - x_;
        var calcTy:Number = this.ty - y_;
        return Math.sqrt(calcTx * calcTx + calcTy * calcTy);
    }

    public function close():void {
        if (this.socketCreated && this.socket.connected) {
            this.socket.close();
        }
    }

    public function createSocket():void {
        this.socket = new Socket();
        this.socket.addEventListener(Event.CONNECT, this.connectHandler);
        this.socket.addEventListener(ErrorEvent.ERROR, this.onError);
        this.socket.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
        this.socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
        this.socket.connect("127.0.0.1", 8888);
        this.socketCreated = true;
    }

    public function send(param1:Number, param2:Number):void {
        this.socket.writeFloat(param1);
        this.socket.writeFloat(param2);
        this.socket.flush();
    }

    private function connectHandler(param1:Event):void {
    }

    private function socketDataHandler(param1:ProgressEvent):void {
        var _loc2_:* = this.socket.readUTFBytes(this.socket.bytesAvailable).split(":");
        this.setTarget(Number(_loc2_[0]), Number(_loc2_[1]));
    }

    public static function fromPlayerXML(_arg_1:String, _arg_2:XML):Player {
        var _local_3:int = int(_arg_2.ObjectType);
        var _local_4:XML = ObjectLibrary.xmlLibrary_[_local_3];
        var _local_5:Player = new Player(_local_4);
        _local_5.name_ = _arg_1;
        _local_5.level_ = int(_arg_2.Level);
        _local_5.exp_ = int(_arg_2.Exp);
        _local_5.equipment_ = ConversionUtil.toIntVector(_arg_2.Equipment);
        _local_5.calculateStatBoosts();
        _local_5.lockedSlot = new Vector.<int>(_local_5.equipment_.length);
        _local_5.maxHP_ = (_local_5.maxHPBoost_ + int(_arg_2.MaxHitPoints));
        _local_5.hp_ = int(_arg_2.HitPoints);
        _local_5.maxMP_ = (_local_5.maxMPBoost_ + int(_arg_2.MaxMagicPoints));
        _local_5.mp_ = int(_arg_2.MagicPoints);
        _local_5.attack_ = (_local_5.attackBoost_ + int(_arg_2.Attack));
        _local_5.defense_ = (_local_5.defenseBoost_ + int(_arg_2.Defense));
        _local_5.speed_ = (_local_5.speedBoost_ + int(_arg_2.Speed));
        _local_5.dexterity_ = (_local_5.dexterityBoost_ + int(_arg_2.Dexterity));
        _local_5.vitality_ = (_local_5.vitalityBoost_ + int(_arg_2.HpRegen));
        _local_5.wisdom_ = (_local_5.wisdomBoost_ + int(_arg_2.MpRegen));
        _local_5.tex1Id_ = int(_arg_2.Tex1);
        _local_5.tex2Id_ = int(_arg_2.Tex2);
        _local_5.hasBackpack_ = (_arg_2.HasBackpack == "1");
        return (_local_5);
    }


    public function getFameBonus():int {
        var equip:int;
        var fame:XML;
        var famebonus:int;
        var counter:uint;
        while (counter < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
            if (equipment_ && equipment_.length > counter) {
                equip = equipment_[counter];
                if (equip != -1) {
                    fame = ObjectLibrary.xmlLibrary_[equip];
                    if (fame != null && fame.hasOwnProperty("FameBonus")) {
                        famebonus = (famebonus + int(fame.FameBonus));
                    }
                }
            }
            counter++;
        }
        return (famebonus);
    }

    public function calculateStatBoosts():void {
        var num:int;
        var activate:XML;
        var increment:XML;
        var stat:int;
        var amount:int;
        this.maxHPBoost_ = 0;
        this.maxMPBoost_ = 0;
        this.attackBoost_ = 0;
        this.defenseBoost_ = 0;
        this.speedBoost_ = 0;
        this.vitalityBoost_ = 0;
        this.wisdomBoost_ = 0;
        this.dexterityBoost_ = 0;
        var counter:uint;
        while (counter < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
            if (equipment_ && equipment_.length > counter) {
                num = equipment_[counter];
                if (num != -1) {
                    activate = ObjectLibrary.xmlLibrary_[num];
                    if (activate != null && activate.hasOwnProperty("ActivateOnEquip")) {
                        for each (increment in activate.ActivateOnEquip) {
                            if (increment.toString() == "IncrementStat") {
                                stat = int(increment.@stat);
                                amount = int(increment.@amount);
                                switch (stat) {
                                    case StatData.MAX_HP_STAT:
                                        this.maxHPBoost_ = (this.maxHPBoost_ + amount);
                                        break;
                                    case StatData.MAX_MP_STAT:
                                        this.maxMPBoost_ = (this.maxMPBoost_ + amount);
                                        break;
                                    case StatData.ATTACK_STAT:
                                        this.attackBoost_ = (this.attackBoost_ + amount);
                                        break;
                                    case StatData.DEFENSE_STAT:
                                        this.defenseBoost_ = (this.defenseBoost_ + amount);
                                        break;
                                    case StatData.SPEED_STAT:
                                        this.speedBoost_ = (this.speedBoost_ + amount);
                                        break;
                                    case StatData.VITALITY_STAT:
                                        this.vitalityBoost_ = (this.vitalityBoost_ + amount);
                                        break;
                                    case StatData.WISDOM_STAT:
                                        this.wisdomBoost_ = (this.wisdomBoost_ + amount);
                                        break;
                                    case StatData.DEXTERITY_STAT:
                                        this.dexterityBoost_ = (this.dexterityBoost_ + amount);
                                        break;
                                }
                            }
                        }
                    }
                }
            }
            counter++;
        }
    }

    public function setRelativeMovement(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
        var _local_4:Number;
        if (this.relMoveVec_ == null) {
            this.relMoveVec_ = new Point();
        }
        this.rotate_ = _arg_1;
        this.relMoveVec_.x = _arg_2;
        this.relMoveVec_.y = _arg_3;
        if (isConfused) {
            _local_4 = this.relMoveVec_.x;
            this.relMoveVec_.x = -(this.relMoveVec_.y);
            this.relMoveVec_.y = -(_local_4);
            this.rotate_ = -(this.rotate_);
        }
    }

    public function setCredits(_arg_1:int):void {
        this.credits_ = _arg_1;
        this.creditsWereChanged.dispatch();
    }

    public function setFame(_arg_1:int):void {
        this.fame_ = _arg_1;
        this.fameWasChanged.dispatch();
    }

    public function setTokens(_arg_1:int):void {
        this.tokens_ = _arg_1;
    }

    public function setGuildName(_arg_1:String):void {
        var _local_3:GameObject;
        var _local_4:Player;
        var _local_5:Boolean;
        this.guildName_ = _arg_1;
        var _local_2:Player = map_.player_;
        if (_local_2 == this) {
            for each (_local_3 in map_.goDict_) {
                _local_4 = (_local_3 as Player);
                if (_local_4 != null && _local_4 != this) {
                    _local_4.setGuildName(_local_4.guildName_);
                }
            }
        }
        else {
            _local_5 = (_local_2 != null && _local_2.guildName_ != null && _local_2.guildName_ != "" && _local_2.guildName_ == this.guildName_);
            if (_local_5 != this.isFellowGuild_) {
                this.isFellowGuild_ = _local_5;
                nameBitmapData_ = null;
            }
        }
    }

    public function isTeleportEligible(_arg_1:Player):Boolean {
        return (!_arg_1.dead_ || _arg_1.isPaused || _arg_1.isInvisible);
    }

    public function msUtilTeleport():int {
        var _local_1:int = getTimer();
        return (Math.max(0, (this.nextTeleportAt_ - _local_1)));
    }

    public function teleportTo(_arg_1:Player):Boolean {
        map_.gs_.gsc_.teleport(_arg_1.objectId_);
        return (true);
    }

    public function levelUpEffect(_arg_1:String, _arg_2:Boolean = true):void {
        if (!Parameters.data_.noParticlesMaster && _arg_2) {
            this.levelUpParticleEffect();
        }
        var _local_3:CharacterStatusText = new CharacterStatusText(this, 0xFF00, 2000);
        _local_3.setStringBuilder(new LineBuilder().setParams(_arg_1));
        map_.mapOverlay_.addStatusText(_local_3);
    }

    public function handleLevelUp(_arg_1:Boolean):void {
        SoundEffectLibrary.play("level_up");
        if (_arg_1) {
            this.levelUpEffect(TextKey.PLAYER_NEWCLASSUNLOCKED, false);
            this.levelUpEffect(TextKey.PLAYER_LEVELUP);
        }
        else {
            this.levelUpEffect(TextKey.PLAYER_LEVELUP);
        }
        if (this == this.map_.player_) {
            this.clientHp = this.maxHP_;
        }
    }

    public function levelUpParticleEffect(_arg_1:uint = 0xFF00FF00):void {
        map_.addObj(new LevelUpEffect(this, _arg_1, 20), x_, y_);
    }

    public function handleExpUp(_arg_1:int):void {
        if (((level_ == 20) && (!(this.bForceExp())))) {
            return;
        }
        if (((Parameters.data_.liteParticle) && (!(this.objectId_ == map_.player_.objectId_)))) {
            return;
        }
        var _local_2:CharacterStatusText = new CharacterStatusText(this, 0xFF00, 1000);
        _local_2.setStringBuilder(new LineBuilder().setParams("+{exp} EXP", {"exp": _arg_1}));
        map_.mapOverlay_.addStatusText(_local_2);
    }

    private function bForceExp():Boolean {
        return (Parameters.data_.forceEXP && Parameters.data_.forceEXP == 1 || Parameters.data_.forceEXP == 2 && map_.player_ == this);
    }

    public function updateFame(_arg_1:int):void {
        var _local_2:CharacterStatusText = new CharacterStatusText(this, 0xE25F00, 2000);
        _local_2.setStringBuilder(new LineBuilder().setParams("+{fame} Fame", {"fame": _arg_1}));
        map_.mapOverlay_.addStatusText(_local_2);
    }

    private function getNearbyMerchant():Merchant {
        var _local_3:Point;
        var _local_4:Merchant;
        var _local_1:int = (((x_ - int(x_)) > 0.5) ? 1 : -1);
        var _local_2:int = (((y_ - int(y_)) > 0.5) ? 1 : -1);
        for each (_local_3 in NEARBY) {
            this.ip_.x_ = (x_ + (_local_1 * _local_3.x));
            this.ip_.y_ = (y_ + (_local_2 * _local_3.y));
            _local_4 = map_.merchLookup_[this.ip_];
            if (_local_4 != null) {
                return ((PointUtil.distanceSquaredXY(_local_4.x_, _local_4.y_, x_, y_) < 1) ? _local_4 : null);
            }
        }
        return (null);
    }

    public function walkTo(_arg_1:Number, _arg_2:Number):Boolean {
        if (this.name_.toLowerCase() == Parameters.data_.multiLeader.toLowerCase() && this.socketCreated && this.socket.connected && Parameters.data_.multiBox) {
            this.send(_arg_1, _arg_2);
        }
        this.modifyMove(_arg_1, _arg_2, newP);
        return (this.moveTo(newP.x, newP.y));
    }

    public function walkTo_follow(_arg_1:Number, _arg_2:Number):Boolean {
        var fX:Number;
        var fY:Number;
        var pX:Number;
        var pY:Number;
        this.modifyMove(_arg_1, _arg_2, newP);
        if (Parameters.syncFollowing || Parameters.followingName || Parameters.VHS == 2 || Parameters.fameBot || Parameters.questFollow) {
            if (!this.followLanded && isValidPosition(this.followPos.x, this.followPos.y)) {
                fX = Math.abs((this.x_ - this.followPos.x));
                fY = Math.abs((this.y_ - this.followPos.y));
                pX = Math.abs((this.x_ - newP.x));
                pY = Math.abs((this.y_ - newP.y));
                if (pX >= fX && pY >= fY) {
                    newP.x = followPos.x;
                    newP.y = followPos.y;
                    this.followLanded = true;
                }
            }
        }
        return (this.moveTo(newP.x, newP.y));
    }

    override public function moveTo(_arg_1:Number, _arg_2:Number):Boolean {
        var _local_3:Boolean = super.moveTo(_arg_1, _arg_2);
        if (map_.gs_.evalIsNotInCombatMapArea()) {
            this.nearestMerchant_ = this.getNearbyMerchant();
        }
        return (_local_3);
    }

    public function modifyMove(_arg_1:Number, _arg_2:Number, _arg_3:Point):void {
        if (isParalyzed || isPetrified) {
            _arg_3.x = x_;
            _arg_3.y = y_;
            return;
        }
        var _local_4:Number = (_arg_1 - x_);
        var _local_5:Number = (_arg_2 - y_);
        if (_local_4 < MOVE_THRESHOLD && _local_4 > -(MOVE_THRESHOLD) && _local_5 < MOVE_THRESHOLD && _local_5 > -(MOVE_THRESHOLD)) {
            this.modifyStep(_arg_1, _arg_2, _arg_3);
            return;
        }
        var _local_6:Number = (MOVE_THRESHOLD / Math.max(Math.abs(_local_4), Math.abs(_local_5)));
        var _local_7:Number = 0;
        _arg_3.x = x_;
        _arg_3.y = y_;
        var _local_8:Boolean;
        while (!_local_8) {
            if ((_local_7 + _local_6) >= 1) {
                _local_6 = (1 - _local_7);
                _local_8 = true;
            }
            this.modifyStep((_arg_3.x + (_local_4 * _local_6)), (_arg_3.y + (_local_5 * _local_6)), _arg_3);
            _local_7 = (_local_7 + _local_6);
        }
    }

    public function modifyStep(_arg_1:Number, _arg_2:Number, _arg_3:Point):void {
        var _local_6:Number;
        var _local_7:Number;
        var _local_4:Boolean = ((((x_ % 0.5) == 0) && (!(_arg_1 == x_))) || (!(int((x_ / 0.5)) == int((_arg_1 / 0.5)))));
        var _local_5:Boolean = ((((y_ % 0.5) == 0) && (!(_arg_2 == y_))) || (!(int((y_ / 0.5)) == int((_arg_2 / 0.5)))));
        if (!_local_4 && !_local_5 || this.isValidPosition(_arg_1, _arg_2)) {
            _arg_3.x = _arg_1;
            _arg_3.y = _arg_2;
            return;
        }
        if (_local_4) {
            _local_6 = ((_arg_1 > x_) ? (int((_arg_1 * 2)) / 2) : (int((x_ * 2)) / 2));
            if (int(_local_6) > int(x_)) {
                _local_6 = (_local_6 - 0.01);
            }
        }
        if (_local_5) {
            _local_7 = ((_arg_2 > y_) ? (int((_arg_2 * 2)) / 2) : (int((y_ * 2)) / 2));
            if (int(_local_7) > int(y_)) {
                _local_7 = (_local_7 - 0.01);
            }
        }
        if (!_local_4) {
            _arg_3.x = _arg_1;
            _arg_3.y = _local_7;
            if (square_ != null && square_.props_.slideAmount_ != 0) {
                this.resetMoveVector(false);
            }
            return;
        }
        if (!_local_5) {
            _arg_3.x = _local_6;
            _arg_3.y = _arg_2;
            if (square_ != null && square_.props_.slideAmount_ != 0) {
                this.resetMoveVector(true);
            }
            return;
        }
        var _local_8:Number = ((_arg_1 > x_) ? (_arg_1 - _local_6) : (_local_6 - _arg_1));
        var _local_9:Number = ((_arg_2 > y_) ? (_arg_2 - _local_7) : (_local_7 - _arg_2));
        if (_local_8 > _local_9) {
            if (this.isValidPosition(_arg_1, _local_7)) {
                _arg_3.x = _arg_1;
                _arg_3.y = _local_7;
                return;
            }
            if (this.isValidPosition(_local_6, _arg_2)) {
                _arg_3.x = _local_6;
                _arg_3.y = _arg_2;
                return;
            }
        }
        else {
            if (this.isValidPosition(_local_6, _arg_2)) {
                _arg_3.x = _local_6;
                _arg_3.y = _arg_2;
                return;
            }
            if (this.isValidPosition(_arg_1, _local_7)) {
                _arg_3.x = _arg_1;
                _arg_3.y = _local_7;
                return;
            }
        }
        _arg_3.x = _local_6;
        _arg_3.y = _local_7;
    }

    private function resetMoveVector(_arg_1:Boolean):void {
        moveVec_.scaleBy(-0.5);
        if (_arg_1) {
            moveVec_.y = (moveVec_.y * -1);
        }
        else {
            moveVec_.x = (moveVec_.x * -1);
        }
    }

    public function isValidPosition(_arg_1:Number, _arg_2:Number):Boolean {
        var _local_3:Square = map_.getSquare(_arg_1, _arg_2);
        if (square_ != _local_3 && _local_3 == null || !_local_3.isWalkable()) {
            return (false);
        }
        if (_local_3.props_.minDamage_ != 0 && Parameters.data_.safeWalk && !this.map_.gs_.mui_.mouseDown_) {
            if (_local_3.obj_ == null) {
                return (false);
            }
        }
        var _local_4:Number = (_arg_1 - int(_arg_1));
        var _local_5:Number = (_arg_2 - int(_arg_2));
        if (_local_4 < 0.5) {
            if (this.isFullOccupy((_arg_1 - 1), _arg_2)) {
                return (false);
            }
            if (_local_5 < 0.5) {
                if (((this.isFullOccupy(_arg_1, (_arg_2 - 1))) || (this.isFullOccupy((_arg_1 - 1), (_arg_2 - 1))))) {
                    return (false);
                }
            }
            else {
                if (_local_5 > 0.5) {
                    if (((this.isFullOccupy(_arg_1, (_arg_2 + 1))) || (this.isFullOccupy((_arg_1 - 1), (_arg_2 + 1))))) {
                        return (false);
                    }
                }
            }
        }
        else {
            if (_local_4 > 0.5) {
                if (this.isFullOccupy((_arg_1 + 1), _arg_2)) {
                    return (false);
                }
                if (_local_5 < 0.5) {
                    if (((this.isFullOccupy(_arg_1, (_arg_2 - 1))) || (this.isFullOccupy((_arg_1 + 1), (_arg_2 - 1))))) {
                        return (false);
                    }
                }
                else {
                    if (_local_5 > 0.5) {
                        if (((this.isFullOccupy(_arg_1, (_arg_2 + 1))) || (this.isFullOccupy((_arg_1 + 1), (_arg_2 + 1))))) {
                            return (false);
                        }
                    }
                }
            }
            else {
                if (_local_5 < 0.5) {
                    if (this.isFullOccupy(_arg_1, (_arg_2 - 1))) {
                        return (false);
                    }
                }
                else {
                    if (_local_5 > 0.5) {
                        if (this.isFullOccupy(_arg_1, (_arg_2 + 1))) {
                            return (false);
                        }
                    }
                }
            }
        }
        return (true);
    }

    public function isFullOccupy(_arg_1:Number, _arg_2:Number):Boolean {
        var _local_3:Square = map_.lookupSquare(_arg_1, _arg_2);
        return (_local_3 == null || _local_3.tileType_ == 0xFF || _local_3.obj_ != null && _local_3.obj_.props_.fullOccupy_);
    }

    public function follow(_arg_1:Number, _arg_2:Number):void {
        followVec.x = (followPos.x - x_);
        followVec.y = (followPos.y - y_);
    }

    public function calcFollowPos():Point {
        var _local_10:Point = new Point();
        var _local_8:Point = new Point();
        var _local_2:Point = new Point();
        var _local_11:Point = new Point();
        var _local_1:int = int.MIN_VALUE;
        var _local_3:int = int.MIN_VALUE;
        var _local_9:int = 0;
        var _local_4:int;
        var _local_5:Number = (Parameters.data_.densityThreshold * Parameters.data_.densityThreshold);
        for each (var _local_6:GameObject in this.map_.vulnPlayerDict_) {
            if (_local_6 != this) {
                _local_9 = int.MAX_VALUE;
                _local_4 = 0;
                _local_1 = 0;
                _local_2.x = 0;
                _local_2.y = 0;
                _local_11.x = 0;
                _local_11.y = 0;
                for each (var _local_7:GameObject in this.map_.vulnPlayerDict_) {
                    if (_local_7 != this && _local_7 != _local_6) {
                        if ((_local_7 as Player).numStars_ >= 5) {
                            _local_9 = PointUtil.distanceSquaredXY(_local_7.x_, _local_7.y_, _local_6.x_, _local_6.y_);
                            if (_local_9 < _local_5) {
                                _local_1++;
                                _local_4++;
                                _local_2.x = (_local_2.x + _local_7.x_);
                                _local_2.y = (_local_2.y + _local_7.y_);
                                _local_11.x = (_local_11.x + _local_7.moveVec_.x);
                                _local_11.y = (_local_11.y + _local_7.moveVec_.y);
                            }
                        }
                    }
                }
                if (_local_4 != 0) {
                    _local_2.x = (_local_2.x / _local_4);
                    _local_2.y = (_local_2.y / _local_4);
                    _local_11.x = (_local_11.x / _local_4);
                    _local_11.y = (_local_11.y / _local_4);
                    if (_local_1 > _local_3) {
                        _local_3 = _local_1;
                        _local_10.x = _local_2.x;
                        _local_10.y = _local_2.y;
                        _local_8.x = _local_11.x;
                        _local_8.y = _local_11.y;
                    }
                }
            }
        }
        if (_local_3 < 3) {
            Parameters.warnDensity = true;
            return (new Point(followPos.x, followPos.y));
        }
        Parameters.warnDensity = true;
        if (_local_8.length > 1) {
            _local_8.normalize(1);
        }
        _local_9 = (Parameters.data_.trainOffset * 0.01);
        _local_2.x = ((_local_10.x + (_local_8.x * (_local_5 * _local_9))) + Parameters.famePoint.x);
        _local_2.y = ((_local_10.y + (_local_8.y * (_local_5 * _local_9))) + Parameters.famePoint.y);
        return (_local_2);
    }

    private function findDirection(_arg_1:Point):Boolean {
        return (absNumber((_arg_1.x - this.x_)) >= absNumber((_arg_1.y - this.y_)));
    }

    private function absNumber(_arg_1:Number):Number {
        return ((_arg_1 < 0) ? -(_arg_1) : _arg_1);
    }

    public function teleToClosestPoint(_arg_1:Point):void {
        var _local_5:Number;
        var _local_4:Number = Number.MAX_VALUE;
        var _local_2:int = -1;
        for each (var _local_3:GameObject in this.map_.goDict_) {
            if ((_local_3 is Player) && !_local_3.isInvisible && !_local_3.isPaused) {
                _local_5 = (((_local_3.x_ - _arg_1.x) * (_local_3.x_ - _arg_1.x)) + ((_local_3.y_ - _arg_1.y) * (_local_3.y_ - _arg_1.y)));
                if (_local_5 < _local_4) {
                    _local_4 = _local_5;
                    _local_2 = _local_3.objectId_;
                }
            }
        }
        if (_local_2 == this.objectId_) {
            this.textNotification("You are closest!", 0xFFFFFF, 1500, false);
            return;
        }
        this.map_.gs_.gsc_.teleport(_local_2);
        this.textNotification(("Teleporting to " + this.map_.goDict_[_local_2].name_), 0xFFFFFF, 1500, false);
    }

    public function attemptAutoAim(_arg_1:Number):void {
        var _local_2:int = this.equipment_[0];
        var _local_3:int = getTimer();
        if (_local_2 != -1) {
            if (Parameters.data_.AAOn) {
                if (!this.shootAutoAimWeaponAngle(_local_2, _local_3) && this.map_.gs_.mui_.autofire_ && !this.map_.gs_.evalIsNotInCombatMapArea()) {
                    this.shoot((Parameters.data_.cameraAngle + _arg_1), _local_3);
                }
            }
            else {
                if (this.map_.gs_.mui_.autofire_) {
                    this.shoot((Parameters.data_.cameraAngle + _arg_1), _local_3);
                }
            }
        }

        this.attemptAutoAbility(_arg_1, _local_3, this.equipment_[1]);
    }

    public function attemptAutoAbility(_arg_1:Number, _arg_2:int = -1, _arg_3:int = 0):void {
        if (this.equipment_ == null) {
            return;
        }
        if (_arg_3 == 0) {
            _arg_3 = this.equipment_[1];
        }
        if (_arg_2 == -1) {
            _arg_2 = getTimer();
        }
        if (_arg_3 != -1 && Parameters.data_.AutoAbilityOn && !this.map_.gs_.evalIsNotInCombatMapArea() && Parameters.abi && !Parameters.data_.fameBlockAbility) {
            this.shootAutoAimAbilityAngle(_arg_3, _arg_2);
        }
    }

    public function shootAutoAimWeaponAngle(_arg_1:int, _arg_2:int):Boolean {
        var _local_8:Vector3D;
        var _local_6:Number;
        if ((((this.isStunned) || (this.isPaused)) || (this.isPetrified))) {
            return (false);
        }
        var _local_9:ObjectProperties = ObjectLibrary.getPropsFromType(_arg_1);
        this.attackPeriod_ = ((1 / this.attackFrequency()) * (1 / _local_9.rateOfFire_));
        if (_arg_2 < (attackStart_ + this.attackPeriod_)) {
            return (false);
        }
        var _local_5:Vector3D = new Vector3D(this.x_, this.y_);
        var point:Point = this.sToW(this.mousePos_.x, this.mousePos_.y);
        var _local_3:Vector3D = new Vector3D(point.x, point.y);
        var projProps:ProjectileProperties = _local_9.projectiles_[0];
        var speed:Number = (projProps.speed_ / 10000);
        if (this.isUnstable) {
            this.attackStart_ = _arg_2;
            this.attackAngle_ = (Math.random() * 6.28318530717959);
            this.doShoot(_arg_2, _arg_1, ObjectLibrary.xmlLibrary_[_arg_1], this.attackAngle_, true);
            return (true);
        }
        _local_8 = this.calcAimAngle(speed, (projProps.lifetime_ * speed + Parameters.data_.aaDistance), _local_5, _local_3);
        if (_local_8) {
            _local_6 = Math.atan2((_local_8.y - this.y_), (_local_8.x - this.x_));
            this.attackStart_ = _arg_2;
            this.attackAngle_ = _local_6;
            this.doShoot(this.attackStart_, _arg_1, ObjectLibrary.xmlLibrary_[_arg_1], _local_6, true);
            return (true);
        }
        this.isShooting = false;
        return (false);
    }

    public function shootAutoAimAbilityAngle(_arg_1:int, _arg_2:int):void {
        var vec:Vector3D;
        var objLib:XML = ObjectLibrary.xmlLibrary_[_arg_1];
        if (!canUseAltWeapon(_arg_2, objLib)) {
            return;
        }
        if ((_arg_2 - lastAutoAbilityAttempt) <= 520) {
            return;
        }
        var point:Point = this.sToW(this.mousePos_.x, this.mousePos_.y);
        _arg_2 = getTimer();
        switch (this.objectType_) {
            case 784:
                this.priestHeal(_arg_2);
                lastAutoAbilityAttempt = _arg_2;
                return;
            case 0x0300:
                if (objLib.Activate.(text() == "Teleport") == "Teleport") {
                    return;
                }
                return;
            case 797:
            case 799:
                this.useAltWeapon(this.x_, this.y_, 1, _arg_2, true, objLib);
                lastAutoAbilityAttempt = _arg_2;
                return;
            case 806:
                if (!this.isNinjaSpeedy) {
                    this.useAltWeapon(this.x_, this.y_, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
            case 801:
            case 800:
            case 802:
                if (this.necroHeal()) {
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
            case 804:
                if (objLib.Activate.(text() == "Teleport") == "Teleport") {
                    return;
                }
                if (Parameters.SPOOKYBOINEAR && Parameters.data_.AntiSpookiBoiDecoi) {
                    this.useAltWeapon(this.x_, this.y_, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                else {
                    if (Parameters.data_.spamPrism) {
                        for each (var _local_5:GameObject in this.map_.vulnEnemyDict_) {
                            if (PointUtil.distanceSquaredXY(this.x_, this.y_, _local_5.x_, _local_5.y_) <= 225) {
                                this.useAltWeapon(this.x_, this.y_, 1, _arg_2, true, objLib);
                                lastAutoAbilityAttempt = _arg_2;
                                return;
                            }
                        }
                    }
                }
                return;
            case 798:
            case 775:
                if (objLib.Activate == "Shoot") {
                    var projProp:ProjectileProperties = ObjectLibrary.getPropsFromType(_arg_1).projectiles_[0];
                    if (this.isUnstable) {
                        vec = new Vector3D((Math.random() - 0.5), (Math.random() - 0.5));
                    }
                    else {
                        vec = this.calcAimAngle(projProp.speed_, projProp.maxProjTravel_, new Vector3D(this.x_, this.y_), new Vector3D(point.x, point.y), true);
                    }
                    if (vec != null) {
                        this.useAltWeapon(vec.x, vec.y, 1, _arg_2, true, objLib);
                        lastAutoAbilityAttempt = _arg_2;
                    }
                }
                return;
            case 805:
                if (this.isUnstable) {
                    vec = null;
                }
                else {
                    vec = this.calcAimAngle(NaN, 7, new Vector3D(this.x_, this.y_), new Vector3D(point.x, point.y));
                }
                if (vec) {
                    this.useAltWeapon(vec.x, vec.y, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
            case 782:
                if (this.isUnstable) {
                    vec = null;
                }
                else {
                    vec = this.calcAimAngle(NaN, 12, new Vector3D(this.x_, this.y_), new Vector3D(point.x, point.y));
                }
                if (vec) {
                    this.useAltWeapon(vec.x, vec.y, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
            case 803:
                if (this.isUnstable) {
                    vec = new Vector3D((Math.random() - 0.5), (Math.random() - 0.5));
                }
                else {
                    this.useAltWeapon(this.x_, this.y_, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
            case 785:
                if (this.isUnstable) {
                    vec = null;
                }
                else {
                    vec = this.calcAimAngle(NaN, getWakiRange(_arg_1), new Vector3D(this.x_, this.y_), new Vector3D(point.x, point.y));
                }
                if (vec) {
                    this.useAltWeapon(vec.x, vec.y, 1, _arg_2, true, objLib);
                    lastAutoAbilityAttempt = _arg_2;
                }
                return;
        }
    }

    public function handleAutoMana():void
    {
        if (((mp_ / maxMP_) * 100) <= Parameters.data_.autoMana)
        {
            if (this.potionInventoryModel.getPotionModel(PotionInventoryModel.MAGIC_POTION_ID).available)
            {
                if (((!(isQuiet)) && (!(mp_ == 0))))
                {
                    this.useBuyPotionSignal.dispatch(new UseBuyPotionVO(PotionInventoryModel.MAGIC_POTION_ID, UseBuyPotionVO.CONTEXTBUY));
                    this.lastManaUse = (getTimer() + 500);
                }
            }
        }
    }

    public function getWakiRange(_arg_1:int):Number {
        switch (_arg_1) {
            case 8994:
                return (4.6);
            case 9152:
                return (6.4);
            default:
                return (4.4);
        }
    }

    public function calcAimAngle(_arg_1:Number, _arg_2:Number, _arg_3:Vector3D, _arg_4:Vector3D, _arg_5:Boolean = false):Vector3D {
        var gameObj:* = null;
        var v:* = null;
        var aimmode:int;
        var counter:int;
        _arg_2 = (_arg_2 * _arg_2);
        var vec:Vector3D = new Vector3D();
        var maxVal:Number = Number.MAX_VALUE;
        var maxVal2:Number = Number.MAX_VALUE;
        var minVal1:int = int.MIN_VALUE;
        var minVal2:int = int.MIN_VALUE;
        var boundDist:int = Parameters.data_.AABoundingDist;
        boundDist = (boundDist * boundDist);
        var dmgIgnored:Boolean = Parameters.data_.damageIgnored;
        var aimInvuln:Boolean = Parameters.data_.autoaimAtInvulnerable;
        var shootWall:Boolean = Parameters.data_.shootAtWalls;
        var aimExcepted:Boolean = Parameters.data_.onlyAimAtExcepted;
        var targetlead:Boolean = Parameters.data_.AATargetLead;
        var sbThresh:int = Parameters.data_.spellbombHPThreshold;
        var skThresh:int = Parameters.data_.skullHPThreshold;
        var bossPrior:Boolean = Parameters.data_.BossPriority;
        var obj:Vector.<GameObject> = new Vector.<GameObject>();
        var bool:Boolean = true;
        do {
            aimmode = Parameters.data_.aimMode;
            if (aimmode == 0) {
                for each (gameObj in this.map_.vulnEnemyDict_) {
                    if (!((!(shootWall)) && (!(gameObj is Character)))) {
                        if (!((bossPrior) && (!(gameObj.props_.boss_)))) {
                            if (!((((gameObj.dead_) || ((gameObj.props_.ignored) && (!(dmgIgnored)))) || ((!(gameObj.props_.excepted)) && (aimExcepted))) || ((!(aimInvuln)) && (gameObj.isInvulnerable)))) {
                                if (isNaN(_arg_1)) {
                                    if (((_arg_2 == 144) && (gameObj.maxHP_ < sbThresh))) continue;
                                    if (((_arg_2 == 49) && (gameObj.maxHP_ < skThresh))) continue;
                                    vec = new Vector3D(gameObj.tickPosition_.x, gameObj.tickPosition_.y);
                                }
                                else {
                                    if (((_arg_5) && (gameObj.maxHP_ < sbThresh))) continue;
                                    if (((gameObj.jittery) || (!(targetlead)))) {
                                        vec = new Vector3D(gameObj.x_, gameObj.y_);
                                    }
                                    else {
                                        vec = this.leadPos(_arg_3, new Vector3D(gameObj.x_, gameObj.y_), new Vector3D(gameObj.moveVec_.x, gameObj.moveVec_.y), _arg_1);
                                    }
                                }
                                if (vec) {
                                    maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, this.x_, this.y_);
                                    if (maxVal <= _arg_2) {
                                        maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, _arg_4.x, _arg_4.y);
                                        if (maxVal <= boundDist) {
                                            if (((bossPrior) && (gameObj.props_.boss_))) {
                                                bool = false;
                                                v = vec;
                                                break;
                                            }
                                            if (maxVal <= maxVal2) {
                                                maxVal2 = maxVal;
                                                v = vec;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                if (aimmode == 1) {
                    for each (gameObj in this.map_.vulnEnemyDict_) {
                        if (!((!(shootWall)) && (!(gameObj is Character)))) {
                            if (!((bossPrior) && (!(gameObj.props_.boss_)))) {
                                if (!((((gameObj.dead_) || ((gameObj.props_.ignored) && (!(dmgIgnored)))) || ((!(gameObj.props_.excepted)) && (aimExcepted))) || ((!(aimInvuln)) && (gameObj.isInvulnerable)))) {
                                    if (isNaN(_arg_1)) {
                                        if (((_arg_2 == 144) && (gameObj.maxHP_ < sbThresh))) continue;
                                        if (((_arg_2 == 49) && (gameObj.maxHP_ < skThresh))) continue;
                                        vec = new Vector3D(gameObj.tickPosition_.x, gameObj.tickPosition_.y);
                                    }
                                    else {
                                        if (((gameObj.jittery) || (!(targetlead)))) {
                                            vec = new Vector3D(gameObj.x_, gameObj.y_);
                                        }
                                        else {
                                            vec = this.leadPos(_arg_3, new Vector3D(gameObj.x_, gameObj.y_), new Vector3D(gameObj.moveVec_.x, gameObj.moveVec_.y), _arg_1);
                                        }
                                    }
                                    if (vec) {
                                        if (gameObj.maxHP_ >= minVal1) {
                                            if (gameObj.maxHP_ == minVal1) {
                                                if (gameObj.hp_ <= minVal2) {
                                                    maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, this.x_, this.y_);
                                                    if (!((gameObj.hp_ == minVal2) && (maxVal > maxVal2))) {
                                                        if (maxVal < _arg_2) {
                                                            minVal1 = gameObj.maxHP_;
                                                            minVal2 = gameObj.hp_;
                                                            v = vec;
                                                            maxVal2 = maxVal;
                                                        }
                                                    }
                                                }
                                            }
                                            else {
                                                maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, this.x_, this.y_);
                                                if (maxVal < _arg_2) {
                                                    if (((bossPrior) && (gameObj.props_.boss_))) {
                                                        bool = false;
                                                        v = vec;
                                                        break;
                                                    }
                                                    minVal1 = gameObj.maxHP_;
                                                    minVal2 = gameObj.hp_;
                                                    maxVal2 = maxVal;
                                                    v = vec;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if (aimmode == 2) {
                        for each (gameObj in this.map_.vulnEnemyDict_) {
                            if (!((!(shootWall)) && (!(gameObj is Character)))) {
                                if (!((bossPrior) && (!(gameObj.props_.boss_)))) {
                                    if (!((((gameObj.dead_) || ((gameObj.props_.ignored) && (!(dmgIgnored)))) || ((!(gameObj.props_.excepted)) && (aimExcepted))) || ((!(aimInvuln)) && (gameObj.isInvulnerable)))) {
                                        if (isNaN(_arg_1)) {
                                            if (((_arg_2 == 144) && (gameObj.maxHP_ < sbThresh))) continue;
                                            if (((_arg_2 == 49) && (gameObj.maxHP_ < skThresh))) continue;
                                            vec = new Vector3D(gameObj.tickPosition_.x, gameObj.tickPosition_.y);
                                        }
                                        else {
                                            if (((gameObj.jittery) || (!(targetlead)))) {
                                                vec = new Vector3D(gameObj.x_, gameObj.y_);
                                            }
                                            else {
                                                vec = this.leadPos(_arg_3, new Vector3D(gameObj.x_, gameObj.y_), new Vector3D(gameObj.moveVec_.x, gameObj.moveVec_.y), _arg_1);
                                            }
                                        }
                                        if (vec) {
                                            maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, this.x_, this.y_);
                                            if (maxVal < _arg_2) {
                                                if (((bossPrior) && (gameObj.props_.boss_))) {
                                                    bool = false;
                                                    v = vec;
                                                    break;
                                                }
                                                if (maxVal < maxVal2) {
                                                    maxVal2 = maxVal;
                                                    v = vec;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        if (aimmode == 3) {
                            obj.length = 0;
                            counter = 0;
                            for each (gameObj in this.map_.vulnEnemyDict_) {
                                if (!((!(shootWall)) && (!(gameObj is Character)))) {
                                    if (!((bossPrior) && (!(gameObj.props_.boss_)))) {
                                        if (!((((gameObj.dead_) || ((gameObj.props_.ignored) && (!(dmgIgnored)))) || ((!(gameObj.props_.excepted)) && (aimExcepted))) || ((!(aimInvuln)) && (gameObj.isInvulnerable)))) {
                                            if (isNaN(_arg_1)) {
                                                if (((_arg_2 == 144) && (gameObj.maxHP_ < sbThresh))) continue;
                                                if (((_arg_2 == 49) && (gameObj.maxHP_ < skThresh))) continue;
                                                vec = new Vector3D(gameObj.tickPosition_.x, gameObj.tickPosition_.y);
                                            }
                                            else {
                                                if (((gameObj.jittery) || (!(targetlead)))) {
                                                    vec = new Vector3D(gameObj.x_, gameObj.y_);
                                                }
                                                else {
                                                    vec = this.leadPos(_arg_3, new Vector3D(gameObj.x_, gameObj.y_), new Vector3D(gameObj.moveVec_.x, gameObj.moveVec_.y), _arg_1);
                                                }
                                            }
                                            if (vec) {
                                                maxVal = this.getDistSquared(gameObj.x_, gameObj.y_, this.x_, this.y_);
                                                if (maxVal < _arg_2) {
                                                    if (((bossPrior) && (gameObj.props_.boss_))) {
                                                        bool = false;
                                                        v = vec;
                                                        break;
                                                    }
                                                    obj.push(gameObj);
                                                    counter++;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (counter != 0) {
                                gameObj = obj[int((Math.random() * counter))];
                                if (isNaN(_arg_1)) {
                                    vec = new Vector3D(gameObj.tickPosition_.x, gameObj.tickPosition_.y);
                                }
                                else {
                                    if (((gameObj.jittery) || (!(targetlead)))) {
                                        vec = new Vector3D(gameObj.x_, gameObj.y_);
                                    }
                                    else {
                                        vec = this.leadPos(_arg_3, new Vector3D(gameObj.x_, gameObj.y_), new Vector3D(gameObj.moveVec_.x, gameObj.moveVec_.y), _arg_1);
                                    }
                                }
                                v = vec;
                            }
                        }
                    }
                }
            }
            if (bossPrior) {
                if (bool) {
                    bossPrior = false;
                }
            }
            else {
                bool = false;
            }
        } while (bool);
        return (v);
    }

    public function getDistSquared(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number {
        var _local_5:Number = (_arg_1 - _arg_3);
        var _local_6:Number = (_arg_2 - _arg_4);
        return ((_local_6 * _local_6) + (_local_5 * _local_5));
    }

    public function leadPos(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:Number):Vector3D {
        var _local_11:Vector3D = _arg_2.subtract(_arg_1);
        var _local_6:Number = (2 * (_arg_3.dotProduct(_arg_3) - (_arg_4 * _arg_4)));
        var _local_7:Number = (2 * _local_11.dotProduct(_arg_3));
        var _local_8:Number = _local_11.dotProduct(_local_11);
        var _local_5:Number = Math.sqrt(((_local_7 * _local_7) - ((2 * _local_6) * _local_8)));
        var _local_10:Number = ((-(_local_7) + _local_5) / _local_6);
        var _local_9:Number = ((-(_local_7) - _local_5) / _local_6);
        if (((_local_10 < _local_9) && (_local_10 >= 0))) {
            _arg_3.scaleBy(_local_10);
        }
        else {
            if (_local_9 >= 0) {
                _arg_3.scaleBy(_local_9);
            }
            else {
                return (null);
            }
        }
        return (_arg_2.add(_arg_3));
    }

    public function necroHeal():Boolean {
        var _local_1:Point = this.getNecroTarget();
        if (_local_1) {
            return (this.useAltWeapon(_local_1.x, _local_1.y, 1, -1, true));
        }
        return (false);
    }

    public function priestHeal(_arg_1:int):void {
        if ((((this.hp_ <= this.autoHealNumber) || (this.clientHp <= this.autoHealNumber)) || (this.hp2 <= this.autoHealNumber))) {
            this.useAltWeapon(this.x_, this.y_, 1, _arg_1, true);
        }
    }

    public function getNecroTarget():Point {
        var point:* = null;
        var numNearby:int = -1;
        var num:int;
        var skullHpThresh:int = Parameters.data_.skullHPThreshold;
        var skullTarget:int = Parameters.data_.skullTargets;
        var skullRadius:Number = Number(ObjectLibrary.xmlLibrary_[this.equipment_[1]].Activate.@radius);
        for each (var obj:GameObject in map_.vulnEnemyDict_) {
            if ((((obj.maxHP_ >= skullHpThresh) && (obj is Character)) && (PointUtil.distanceSquaredXY(obj.x_, obj.y_, this.x_, this.y_) <= 225))) {
                numNearby = this.getNumNearbyEnemies(obj, skullRadius);
                if (((numNearby > skullTarget) && (numNearby > num))) {
                    point = obj;
                    num = numNearby;
                }
            }
        }
        if (((num < skullTarget) || (point == null))) {
            return (null);
        }
        return (new Point(point.x_, point.y_));
    }

    public function getNumNearbyEnemies(_arg_1:GameObject, _arg_2:int):int {
        _arg_2 = (_arg_2 * _arg_2);
        var counter:int;
        var skullHpThresh:int = Parameters.data_.skullHPThreshold;
        for each (var _local_3:GameObject in map_.vulnEnemyDict_) {
            if ((((_local_3.maxHP_ >= skullHpThresh) && (_local_3 is Character)) && (PointUtil.distanceSquaredXY(_local_3.x_, _local_3.y_, _arg_1.x_, _arg_1.y_) <= _arg_2))) {
                counter++;
            }
        }
        return (counter);
    }

    public function autoLoot(_arg_1:int = -1):void {
        var counter:int;
        var equip:int;
        var objlib:* = null;
        if (_arg_1 == -1) {
            _arg_1 = getTimer();
        }
        if ((_arg_1 - this.map_.gs_.gsc_.lastInvSwapTime) <= 500) {
            return;
        }
        if ((((this.isInventoryFull()) && ((Parameters.data_.autoLootHPPots) && (healthPotionCount_ == 6))) && ((Parameters.data_.autoLootMPPots) && (magicPotionCount_ == 6)))) {
            return;
        }
        for each (var _local_3:GameObject in this.map_.goDict_) {
            if ((((_local_3 is Container) && (_local_3.equipment_)) && (PointUtil.distanceSquaredXY(this.x_, this.y_, _local_3.x_, _local_3.y_) <= 1))) {
                counter = 0;
                while (counter < 8) {
                    equip = _local_3.equipment_[counter];
                    if (equip != -1) {
                        objlib = ObjectLibrary.propsLibrary_[equip];
                        if (objlib) {
                            if ((((Parameters.data_.autoDrinkFromBags) && (objlib.isPotion_)) && (shouldDrink_incAndOpti(equip)))) {
                                drink(_local_3, counter, equip);
                            }
                            else {
                                if (((objlib.desiredLoot_) || ((Parameters.data_.autoLootUpgrades) && (checkForUpgrade(objlib))))) {
                                    pickup(_local_3, counter, equip);
                                }
                            }
                        }
                    }
                    counter++;
                }
            }
        }
    }

    public function checkForUpgrade(_arg_1:ObjectProperties):Boolean {
        var counter:int;
        var slotType:int;
        if (_arg_1.slotType_ != int.MIN_VALUE) {
            counter = 0;
            while (counter < 4) {
                slotType = this.slotTypes_[counter];
                if (_arg_1.slotType_ == slotType) {
                    if (this.equipment_ && this.equipment_[counter] == -1) {
                        return (true);
                    }
                    var _local_3:ObjectProperties = ObjectLibrary.propsLibrary_[this.equipment_[counter]];
                    if (_local_3 && _local_3.tier != int.MIN_VALUE && _arg_1.tier > _local_3.tier) {
                        return (true);
                    }
                }
                counter++;
            }
        }
        return (false);
    }

    public function drink(_arg_1:GameObject, _arg_2:int, _arg_3:int):void {
        this.map_.gs_.gsc_.useItem(getTimer(), _arg_1.objectId_, _arg_2, _arg_3, x_, y_, 1);
        _arg_1.equipment_[_arg_2] = -1;
        SoundEffectLibrary.play("use_potion");
    }

    public function pickup(_arg_1:GameObject, _arg_2:int, _arg_3:int):void {
        var _local_4:int;
        if (_arg_3 == PotionInventoryModel.HEALTH_POTION_ID) {
            if (this.healthPotionCount_ == 6) {
                if (Parameters.data_.autoLootHPPotsInv) {
                    _local_4 = findItem(this.equipment_, -1, 4, false, ((this.hasBackpack_) ? 20 : 12));
                    if (_local_4 != -1) {
                        this.map_.gs_.gsc_.invSwap(this, this, _local_4, -1, _arg_1, _arg_2, _arg_1.equipment_[_arg_2]);
                    }
                }
            }
            else {
                this.map_.gs_.gsc_.invSwapPotion(this, _arg_1, _arg_2, PotionInventoryModel.HEALTH_POTION_ID, this, PotionInventoryModel.HEALTH_POTION_SLOT, -1);
            }
        }
        else {
            if (_arg_3 == PotionInventoryModel.MAGIC_POTION_ID) {
                if (this.magicPotionCount_ == 6) {
                    if (Parameters.data_.autoLootMPPotsInv) {
                        _local_4 = findItem(this.equipment_, -1, 4, false, ((this.hasBackpack_) ? 20 : 12));
                        if (_local_4 != -1) {
                            this.map_.gs_.gsc_.invSwap(this, this, _local_4, -1, _arg_1, _arg_2, _arg_1.equipment_[_arg_2]);
                        }
                    }
                }
                else {
                    this.map_.gs_.gsc_.invSwapPotion(this, _arg_1, _arg_2, PotionInventoryModel.MAGIC_POTION_ID, this, PotionInventoryModel.MAGIC_POTION_SLOT, -1);
                }
            }
            else {
                _local_4 = findItem(this.equipment_, -1, 4, false, ((this.hasBackpack_) ? 20 : 12));
                if (_local_4 != -1) {
                    this.map_.gs_.gsc_.invSwap(this, this, _local_4, this.equipment_[_local_4], _arg_1, _arg_2, _arg_1.equipment_[_arg_2]);
                }
            }
        }
    }

    public function findItem(_arg_1:Vector.<int>, _arg_2:int, _arg_3:int = 0, _arg_4:Boolean = false, _arg_5:int = 8):int {
        var _local_6:int = -1;
        if (_arg_4) {
            _local_6 = _arg_3;
            while (_local_6 < _arg_5) {
                if (_arg_1[_local_6] != _arg_2) {
                    return (_local_6);
                }
                _local_6++;
            }
        }
        else {
            _local_6 = _arg_3;
            while (_local_6 < _arg_5) {
                if (_arg_1[_local_6] == _arg_2) {
                    return (_local_6);
                }
                _local_6++;
            }
        }
        return (-1);
    }

    public function calcSealHeal():int {
        var _local_3:int;
        var _local_5:Number;
        var _local_2:int = this.equipment_[1];
        var _local_4:Number = ((this.wisdom_ < 30) ? 4.5 : (4.5 + (0.03 * this.wisdom_)));
        _local_4 = (_local_4 * _local_4);
        var _local_1:XML = ObjectLibrary.xmlLibrary_[_local_2];
        if (((_local_1.Activate[0] == "StatBoostAura") && (_local_1.useWisModifier))) {
            switch (_local_2) {
                case 8344:
                case 2854:
                    _local_3 = ((this.wisdom_ < 30) ? 75 : (75 + (0.5 * this.wisdom_)));
                    break;
                case 2645:
                    _local_3 = ((this.wisdom_ < 30) ? 55 : (55 + (0.366666666666667 * this.wisdom_)));
                    break;
                case 2644:
                    _local_3 = ((this.wisdom_ < 30) ? 45 : (45 + (0.3 * this.wisdom_)));
                    break;
                case 2778:
                    _local_3 = ((this.wisdom_ < 30) ? 25 : (25 + (0.166666666666667 * this.wisdom_)));
                    break;
                case 2643:
                    _local_3 = ((this.wisdom_ < 30) ? 10 : (10 + (0.0666666666666667 * this.wisdom_)));
                    break;
                case 9062:
                    _local_3 = ((this.wisdom_ < 30) ? 60 : (60 + (0.4 * this.wisdom_)));
            }
            _local_5 = PointUtil.distanceSquaredXY(map_.player_.tickPosition_.x, map_.player_.tickPosition_.y, (this.moveVec_.x + this.x_), (this.moveVec_.y + this.y_));
            if (_local_5 < _local_4) {
                return (_local_3);
            }
        }
        return (0);
    }

    public function addSealHealth(_arg_1:int):void {
        this.healBuffer = (this.healBuffer + _arg_1);
        this.healBufferTime = (getTimer() + 220);
    }

    public function triggerHealBuffer():void {
        if (this.healBuffer > 0) {
            this.addHealth(this.healBuffer);
            this.healBuffer = 0;
            this.healBufferTime = 2147483647;
        }
    }

    public function maxHpChanged(_arg_1:int):void {
        if (_arg_1 < this.maxHP_) {
            if (this.clientHp > this.maxHP_) {
                this.clientHp = this.maxHP_;
            }
        }
    }

    public function addHealth(_arg_1:int):void {
        this.clientHp = (this.clientHp + _arg_1);
        if (this.clientHp > this.maxHP_) {
            this.clientHp = this.maxHP_;
        }
    }

    public function subtractDamage(_arg_1:int, _arg_2:int = -1):Boolean {
        if (_arg_2 == -1) {
            _arg_2 = getTimer();
        }
        this.clientHp = (this.clientHp - _arg_1);
        this.hp2 = (this.hp2 - _arg_1);
        return (this.checkHealth(_arg_2));
    }

    public function calcHealthPercent():void {
        this.autoHpPotNumber = ((Parameters.data_.autoHPPercent / 100) * this.maxHP_);
        this.autoNexusNumber = ((Parameters.data_.AutoNexus / 100) * this.maxHP_);
        this.autoHealNumber = ((Parameters.data_.AutoHealPercentage / 100) * this.maxHP_);
        this.requestHealNumber = ((Parameters.data_.requestHealPercent * 0.01) * this.maxHP_);
    }

    private function calcHealth(_arg_1:int):void {
        var _local_4:Number = (1 / (1000 / _arg_1));
        var _local_3:Number = (1 + (0.12 * this.vitality_));
        var _local_5:Boolean = ((this.map_.isTrench) && (this.breath_ == 0));
        if (((!(this.isSick)) && (!(this.isBleeding)))) {
            this.hpLog = (this.hpLog + (_local_3 * _local_4));
            if (this.isHealing_()) {
                this.hpLog = (this.hpLog + (20 * _local_4));
            }
        }
        else {
            if (this.isBleeding) {
                this.hpLog = (this.hpLog - (20 * _local_4));
            }
        }
        if (_local_5) {
            this.hpLog = (this.hpLog - (Parameters.DrownAmount * _local_4));
        }
        var _local_2:int = this.hpLog;
        var _local_6:Number = (this.hpLog - _local_2);
        this.hpLog = _local_6;
        this.clientHp = (this.clientHp + _local_2);
        if (this.clientHp > this.maxHP_) {
            this.clientHp = this.maxHP_;
        }
    }

    public function checkHealth(_arg_1:int=-1):Boolean
    {
        var hasPots:Boolean;
        var bp:int;
        var equip:int;
        var counter:int;
        if (_arg_1 == -1)
        {
            _arg_1 = getTimer();
        }
        if (!this.map_.gs_.evalIsNotInCombatMapArea())
        {
            if (((Parameters.data_.AutoNexus == 0) || (Parameters.suicideMode)))
            {
                return (false);
            }
            if ((((this.hp_ <= this.autoNexusNumber) || (this.clientHp <= this.autoNexusNumber)) || (this.hp2 <= this.autoNexusNumber)))
            {
                if (Parameters.data_.instaNexus)
                {
                    this.map_.gs_.gsc_.disconnect();
                }
                else
                {
                    this.map_.gs_.gsc_.escape();
                }
                this.map_.gs_.dispatchEvent(Parameters.reconNexus);
                return (true);
            }
            if ((((((!(Parameters.data_.fameBlockThirsty)) && (!(this.isSick))) && (!(this.autoHpPotNumber == 0))) && (((this.hp_ <= this.autoHpPotNumber) || (this.clientHp <= this.autoHpPotNumber)) || (this.hp2 <= this.autoHpPotNumber))) && ((_arg_1 - this.lastHpPotTime) > Parameters.data_.autohpPotDelay)))
            {
                hasPots = false;
                bp = ((this.hasBackpack_) ? 20 : 12);
                counter = 4;
                while (counter < bp)
                {
                    equip = this.equipment_[counter];
                    if (((equip == 2594) || (equip == 0x0707)))
                    {
                        this.map_.gs_.gsc_.useItem(_arg_1, this.objectId_, counter, equip, this.x_, this.y_, 1);
                        hasPots = true;
                        break;
                    }
                    counter++;
                }
                if (((!(hasPots)) && (this.healthPotionCount_ > 0)))
                {
                    this.map_.gs_.mui_.useBuyPotionSignal.dispatch(potionVO);
                }
                this.lastHpPotTime = _arg_1;
            }
        }
        return (false);
    }

    override public function updateStatuses():void {
        var _local_1:Boolean;
        if (this.map_.player_ == this) {
            this.isWeak = this.isWeak_();
            this.isSlowed = this.isSlowed_();
            this.isSick = this.isSick_();
            this.isDazed = this.isDazed_();
            this.isStunned = this.isStunned_();
            this.isBlind = this.isBlind_();
            this.isDrunk = this.isDrunk_();
            this.isBleeding = this.isBleeding_();
            this.isConfused = this.isConfused_();
            this.isParalyzed = this.isParalyzed_();
            this.isSpeedy = this.isSpeedy_();
            this.isNinjaSpeedy = this.isNinjaSpeedy_();
            this.isHallucinating = this.isHallucinating_();
            this.isDamaging = this.isDamaging_();
            this.isBerserk = this.isBerserk_();
            this.isUnstable = this.isUnstable_();
            this.isDarkness = this.isDarkness_();
            this.isSilenced = this.isSilenced_();
            this.isExposed = this.isExposed_();
            this.isQuiet = this.isQuiet_();
        }
        this.isInvisible = this.isInvisible_();
        this.isHealing = this.isHealing_();
        super.updateStatuses();
        if (this.map_.player_ == this) {
            _local_1 = false;
            if (this.isDamaging != this.previousDamaging) {
                this.previousDamaging = this.isDamaging;
                _local_1 = true;
            }
            if (this.isWeak != this.previousWeak) {
                this.previousWeak = this.isWeak;
                _local_1 = true;
            }
            if (this.isBerserk != this.previousBerserk) {
                this.previousBerserk = this.isBerserk;
                _local_1 = true;
            }
            if (this.isDazed != this.previousDaze) {
                this.previousDaze = this.isDazed;
                _local_1 = true;
            }
            if (_local_1) {
                this.recalcAllEnemyHighestDps();
            }
        }
    }

    public function recalcAllEnemyHighestDps():void {
        for each (var _local_1:GameObject in this.map_.goDict_) {
            if (_local_1.props_.isEnemy_) {
                _local_1.calcHighestDps = true;
            }
        }
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean {
        var angle:Number;
        var ms:Number;
        var rMoveV:Number;
        var vec3:Vector3D;
        var dist:Number;
        var nextDmg:int;
        var groundDmg:Vector.<uint>;
        var timerInt1:int;
        var timerInt2:int;
        var timerStr:String;
        var point:Point;
        var counter:int = 0;
        var num:Number = NaN;
        if (this.map_.player_ == this) {
            if (this.isPaused) {
                return (true);
            }
            this.calcHealth((getTimer() - map_.gs_.lastUpdate_));
            if (this.checkHealth(_arg_1)) {
                return (false);
            }
            var following:Boolean = false;
            if (Parameters.data_.dodBot) {
                if (this.map_.name_ == Map.NEXUS) {
                    dodCounter = 0;
                    this.map_.gs_.gsc_.playerText("/tutorial");
                    return (true);
                }
                if (this.map_.name_ == "Tutorial") {
                    if (PointUtil.distanceSquaredXY(x_, y_, DOD_PATH_X[dodCounter], DOD_PATH_Y[dodCounter]) < 0.1) {
                        dodCounter++;
                    }
                    if (dodCounter == DOD_PATH_X.length) {
                        Parameters.data_.dodComplete++;
                        Parameters.save();
                        addTextLine.dispatch(ChatMessage.make("DoD Complete", "Completed " + Parameters.data_.dodComplete + " quests."));
                        dodCounter = 0;
                        this.map_.gs_.gsc_.playerText("/tutorial");
                        return (true);
                    }
                    if (this.followLanded) {
                        this.followVec.x = 0;
                        this.followVec.y = 0;
                        this.followLanded = false;
                    }
                    else {
                        this.followPos.x = DOD_PATH_X[dodCounter];
                        this.followPos.y = DOD_PATH_Y[dodCounter];
                        following = true;
                        this.follow(this.followPos.x, this.followPos.y);
                    }
                }
            }
            if (this.lastManaUse <= getTimer() && !Parameters.data_.fameBlockThirsty)
            {
                this.handleAutoMana();
            }

            /*if (PointUtil.distanceSquaredXY(x_, y_, fX, fY) < 0.1 ) movingTo = false;
            if (this.movingTo) {
                num = this.getMoveSpeed() * _arg_2;
                this.walkTo(x_ + num * Math.cos(this.fA), y_ + num * Math.sin(this.fA));
            }*/

            if (this.target) {
                num = this.getMoveSpeed() * _arg_2;
                if (this.distance() <= num) {
                    this.walkTo(this.tx, this.ty);
                }
                else {
                    this.walkTo(x_ + num * Math.cos(this.ta), y_ + num * Math.sin(this.ta));
                }
                if (this.distance() > 10) {
                    map_.gs_.gsc_.playerText("/teleport " + Parameters.data_.multiLeader);
                }
            }
            if (followPos.x != 0 && followPos.y != 0) {
                if (Parameters.followingName && Parameters.followName != null && Parameters.followPlayer != null) {
                    if (this.followLanded) {
                        this.followVec.x = 0;
                        this.followVec.y = 0;
                        this.followLanded = false;
                    }
                    else {
                        following = true;
                        if ((_arg_1 - this.lastTpTime_) > Parameters.data_.fameTpCdTime && PointUtil.distanceSquaredXY(x_, y_, Parameters.followPlayer.x_, Parameters.followPlayer.y_) > Parameters.data_.teleDistance) {
                            lastTpTime_ = _arg_1;
                            teleToClosestPoint(followPos);
                        }
                        this.follow(this.followPos.x, this.followPos.y);
                    }
                }
                else {
                    if (Parameters.fameBot) {
                        if (this.followLanded) {
                            this.followVec.x = 0;
                            this.followVec.y = 0;
                            this.followLanded = false;
                        }
                        else {
                            following = true;
                            this.follow(this.followPos.x, this.followPos.y);
                        }
                    }
                }
            }
            if (Parameters.questFollow) {
                if (this.followLanded) {
                    this.followVec.x = 0;
                    this.followVec.y = 0;
                    this.followLanded = false;
                }
                else {
                    if (map_.quest_.objectId_ > 0) {
                        var object:GameObject = map_.goDict_[map_.quest_.objectId_];
                        if (object != null) {
                            this.followPos.x = object.x_;
                            this.followPos.y = object.y_;
                        }
                        following = true;
                        this.follow(this.followPos.x, this.followPos.y);
                    }
                    else {
                        this.followPos.x = this.x_;
                        this.followPos.y = this.y_;
                        this.follow(this.followPos.x, this.followPos.y);
                    }
                }
            }
            else {
                if (Parameters.VHS == 2) {
                    if (this.followLanded || PointUtil.distanceSquaredXY(x_, y_, followPos.x, followPos.y) <= 0.2) {
                        if (Parameters.VHSRecordLength > 0) {
                            if (Parameters.VHSIndex >= Parameters.VHSRecordLength) {
                                Parameters.VHSIndex = 0;
                            }
                            Parameters.VHSNext = Parameters.VHSRecord[Parameters.VHSIndex++];
                            this.followPos.x = Parameters.VHSNext.x;
                            this.followPos.y = Parameters.VHSNext.y;
                            this.followLanded = false;
                        }
                    }
                    else {
                        following = true;
                        this.follow(this.followPos.x, this.followPos.y);
                    }
                }
                else {
                    if (Parameters.VHS == 1) {
                        if (this.x_ != -1 && this.y_ != -1) {
                            if (Parameters.VHSRecord.length == 0) {
                                Parameters.VHSRecord.push(new Point(this.x_, this.y_));
                            }
                            else {
                                point = Parameters.VHSRecord[(Parameters.VHSRecord.length - 1)];
                                if (point.x != this.x_ || point.y != this.y_) {
                                    dist = PointUtil.distanceSquaredXY(this.x_, this.y_, point.x, point.y);
                                    if (dist >= 1) {
                                        Parameters.VHSRecord.push(new Point(this.x_, this.y_));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (!following) {
                this.followVec.x = 0;
                this.followVec.y = 0;
            }
            if (!map_.isVault && !isPaused && Parameters.data_.AutoLootOn) {
                this.autoLoot();
            }
            if (this.collect != 0 && map_.name_ == Map.VAULT && (lastLootTime + 600) < getTimer()) {
                this.vault_();
            }
            if (this.select_ != -1 && getTimer() >= this.nextSelect) {
                counter = this.loopStart;
                while (counter < 12) {
                    var slot:TradeSlot = this.naturalize(counter - 4);
                    if (slot.item_ == this.select_) {
                        this.selectSlot(slot);
                        this.loopStart = (counter + 1);
                        if (counter != 11) {
                            break;
                        }
                    }
                    if (counter == 11) {
                        this.select_ = -1;
                        this.loopStart = 4;
                    }
                    counter++;
                }
            }
            var questId:int = -1;
            if (map_.quest_.getObject() != null)
            {
                questId = map_.quest_.getObject().objectType_;
            }
            if (questId != 3366 && questId != 3367 && questId != 3368)
            {
                this.questMob = map_.quest_.getObject();
            }
            else
            {
                this.questMob = null;
            }
        }
        if (((this.timerCount <= this.endCount) && ((this.startTime + (this.timerStep * this.timerCount)) <= getTimer()))) {
            timerInt1 = (this.endCount * this.timerStep);
            timerInt2 = (this.timerCount * this.timerStep);
            angle = ((timerInt1 - timerInt2) / 1000);
            if (int((timerInt1 / 60000)) > 0) {
                ms = (angle % 60);
                timerStr = ms.toFixed(((this.timerStep < 1000) ? 1 : 0));
                this.textNotification(((int((angle / 60)).toString() + ":") + ((ms < 10) ? ("0" + timerStr) : timerStr)), GameObject.green2red((100 - ((timerInt2 / timerInt1) * 100))));
            }
            else {
                this.textNotification(angle.toFixed(((this.timerStep < 1000) ? 1 : 0)), GameObject.green2red((100 - ((timerInt2 / timerInt1) * 100))));
            }
            this.timerCount++;
        }
        if (this.tierBoost && !isPaused) {
            this.tierBoost = (this.tierBoost - _arg_2);
            if (this.tierBoost < 0) {
                this.tierBoost = 0;
            }
        }
        if (this.dropBoost && !isPaused) {
            this.dropBoost = (this.dropBoost - _arg_2);
            if (this.dropBoost < 0) {
                this.dropBoost = 0;
            }
        }
        if (this.xpTimer && !isPaused) {
            this.xpTimer = (this.xpTimer - _arg_2);
            if (this.xpTimer < 0) {
                this.xpTimer = 0;
            }
        }
        if (isHealing && !isPaused) {
            if (!Parameters.data_.noParticlesMaster && this.healingEffect_ == null) {
                this.healingEffect_ = new HealingEffect(this);
                map_.addObj(this.healingEffect_, x_, y_);
            }
        }
        else {
            if (this.healingEffect_ != null) {
                map_.removeObj(this.healingEffect_.objectId_);
                this.healingEffect_ = null;
            }
        }
        if (this.relMoveVec_ != null) {
            angle = Parameters.data_.cameraAngle;
            if (this.rotate_ != 0) {
                angle = (angle + ((_arg_2 * Parameters.PLAYER_ROTATE_SPEED) * this.rotate_));
                Parameters.data_.cameraAngle = angle;
            }
            if (this.relMoveVec_.x != 0 || this.relMoveVec_.y != 0) {
                if (following) {
                    following = false;
                }
                ms = this.getMoveSpeed();
                rMoveV = Math.atan2(this.relMoveVec_.y, this.relMoveVec_.x);
                if (square_.props_.slideAmount_ > 0 && (Parameters.ssmode || !Parameters.data_.ignoreIce)) {
                    vec3 = new Vector3D();
                    vec3.x = (ms * Math.cos((angle + rMoveV)));
                    vec3.y = (ms * Math.sin((angle + rMoveV)));
                    vec3.z = 0;
                    dist = vec3.length;
                    vec3.scaleBy((-1 * (square_.props_.slideAmount_ - 1)));
                    moveVec_.scaleBy(square_.props_.slideAmount_);
                    if (moveVec_.length < dist) {
                        moveVec_ = moveVec_.add(vec3);
                    }
                }
                else {
                    moveVec_.x = (ms * Math.cos((angle + rMoveV)));
                    moveVec_.y = (ms * Math.sin((angle + rMoveV)));
                }
            }
            else {
                if (conMoveVec && (conMoveVec.x != 0 || conMoveVec.y != 0)) {
                    ms = this.getMoveSpeed();
                    rMoveV = Math.atan2(conMoveVec.y, conMoveVec.x);
                    if ((ms * conMoveVec.x) < 0) {
                        this.moveVec_.x = ((ms * conMoveVec.x) * -(Math.cos(rMoveV)));
                    }
                    else {
                        this.moveVec_.x = ((ms * conMoveVec.x) * Math.cos(rMoveV));
                    }
                    if ((ms * conMoveVec.y) < 0) {
                        this.moveVec_.y = ((ms * conMoveVec.y) * Math.sin(rMoveV));
                    }
                    else {
                        this.moveVec_.y = ((ms * conMoveVec.y) * -(Math.sin(rMoveV)));
                    }
                }
                else {
                    if (following && this.followPos && (this.followVec.x != 0 || this.followVec.y != 0)) {
                        ms = this.getMoveSpeed();
                        rMoveV = Math.atan2(this.followVec.y, this.followVec.x);
                        if (this.square_.props_.slideAmount_ > 0 && (Parameters.ssmode || !Parameters.data_.ignoreIce)) {
                            vec3 = new Vector3D();
                            vec3.x = (ms * Math.cos(rMoveV));
                            vec3.y = (ms * Math.sin(rMoveV));
                            vec3.z = 0;
                            dist = vec3.length;
                            vec3.scaleBy(-(this.square_.props_.slideAmount_ - 1));
                            this.moveVec_.scaleBy(this.square_.props_.slideAmount_);
                            if (this.moveVec_.length < dist) {
                                this.moveVec_ = this.moveVec_.add(vec3);
                            }
                        }
                        else {
                            this.moveVec_.x = (ms * Math.cos(rMoveV));
                            this.moveVec_.y = (ms * Math.sin(rMoveV));
                        }
                    }
                    else {
                        if ((Parameters.ssmode || !Parameters.data_.ignoreIce) && this.moveVec_.length > 0.00012 && this.square_.props_.slideAmount_ > 0) {
                            this.moveVec_.scaleBy(this.square_.props_.slideAmount_);
                        }
                        else {
                            this.moveVec_.x = 0;
                            this.moveVec_.y = 0;
                        }
                    }
                }
            }
            if (this.square_ && this.square_.props_.push_ && (Parameters.ssmode || !Parameters.data_.ignoreIce)) {
                this.moveVec_.x = (this.moveVec_.x - (this.square_.props_.animate_.dx_ * 0.001));
                this.moveVec_.y = (this.moveVec_.y - (this.square_.props_.animate_.dy_ * 0.001));
            }
            if (following) {
                this.walkTo_follow((this.x_ + (_arg_2 * this.moveVec_.x)), (this.y_ + (_arg_2 * this.moveVec_.y)));
            }
            else {
                this.walkTo((x_ + (_arg_2 * moveVec_.x)), (y_ + (_arg_2 * moveVec_.y)));
            }
        }
        else {
            if (!super.update(_arg_1, _arg_2)) {
                return (false);
            }
        }
        if (this.map_.player_ == this) {
            if (this.square_.props_.maxDamage_ > 0 && (this.square_.lastDamage_ + 500) < _arg_1 && !this.isInvincible && (square_.obj_ == null || !this.square_.obj_.props_.protectFromGroundDamage_)) {
                nextDmg = map_.gs_.gsc_.getNextDamage(this.square_.props_.minDamage_, this.square_.props_.maxDamage_);
                if (this.subtractDamage(nextDmg, _arg_1)) {
                    return (false);
                }
                groundDmg = new Vector.<uint>();
                groundDmg.push(ConditionEffect.GROUND_DAMAGE);
                damage(true, nextDmg, groundDmg, (hp_ <= nextDmg), null);
                this.map_.gs_.gsc_.groundDamage(_arg_1, x_, y_);
                this.square_.lastDamage_ = _arg_1;
            }
        }
        return (true);
    }

    public function onMove():void {
        if (map_ != null) {
            var square:Square = map_.getSquare(x_, y_);
            if (square.props_.sinking_) {
                sinkLevel_ = Math.min((sinkLevel_ + 1), Parameters.MAX_SINK_LEVEL);
                this.moveMultiplier_ = (0.1 + ((1 - (sinkLevel_ / Parameters.MAX_SINK_LEVEL)) * (square.props_.speed_ - 0.1)));
            }
            else {
                sinkLevel_ = 0;
                this.moveMultiplier_ = square.props_.speed_;
            }
        }
    }

    override protected function makeNameBitmapData():BitmapData {
        var _local_1:StringBuilder = new StaticStringBuilder(name_);
        var _local_2:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
        var _local_3:BitmapData = _local_2.make(_local_1, 16, this.getNameColor(), true, NAME_OFFSET_MATRIX, true);
        _local_3.draw(FameUtil.numStarsToIcon(this.numStars_), RANK_OFFSET_MATRIX);
        return (_local_3);
    }

    private function getNameColor():uint {
        if (this.isFellowGuild_) {
            return (Parameters.FELLOW_GUILD_COLOR);
        }
        if (this.nameChosen_) {
            return (Parameters.NAME_CHOSEN_COLOR);
        }
        return (0xFFFFFF);
    }

    protected function drawBreathBar(_arg_1:Vector.<IGraphicsData>, _arg_2:int):void {
        var _local_8:Number;
        var _local_9:Number;
        if (this.breathPath_ == null) {
            this.breathBackFill_ = new GraphicsSolidFill();
            this.breathBackPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
            this.breathFill_ = new GraphicsSolidFill(2542335);
            this.breathPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
        }
        if (this.breath_ <= Parameters.BREATH_THRESH) {
            _local_8 = ((Parameters.BREATH_THRESH - this.breath_) / Parameters.BREATH_THRESH);
            this.breathBackFill_.color = MoreColorUtil.lerpColor(0x111111, 0xFF0000, (Math.abs(Math.sin((_arg_2 / 300))) * _local_8));
        }
        else {
            this.breathBackFill_.color = 0x111111;
        }
        var _local_3:int = 20;
        var _local_4:int = 12;
        var _local_5:int = 5;
        var _local_6:Vector.<Number> = (this.breathBackPath_.data as Vector.<Number>);
        _local_6.length = 0;
        var _local_7:Number = 1.2;
        _local_6.push(((posS_[0] - _local_3) - _local_7), (((posS_[1] + _local_4) - 0) - 0), ((posS_[0] + _local_3) + _local_7), (((posS_[1] + _local_4) - 0) - 0), ((posS_[0] + _local_3) + _local_7), (((posS_[1] + _local_4) + _local_5) + _local_7), ((posS_[0] - _local_3) - _local_7), (((posS_[1] + _local_4) + _local_5) + _local_7));
        _arg_1.push(this.breathBackFill_);
        _arg_1.push(this.breathBackPath_);
        _arg_1.push(GraphicsUtil.END_FILL);
        if (this.breath_ > 0) {
            _local_9 = (((this.breath_ / 100) * 2) * _local_3);
            this.breathPath_.data.length = 0;
            _local_6 = (this.breathPath_.data as Vector.<Number>);
            _local_6.length = 0;
            _local_6.push((posS_[0] - _local_3), (posS_[1] + _local_4), ((posS_[0] - _local_3) + _local_9), (posS_[1] + _local_4), ((posS_[0] - _local_3) + _local_9), ((posS_[1] + _local_4) + _local_5), (posS_[0] - _local_3), ((posS_[1] + _local_4) + _local_5));
            _arg_1.push(this.breathFill_);
            _arg_1.push(this.breathPath_);
            _arg_1.push(GraphicsUtil.END_FILL);
        }
        GraphicsFillExtra.setSoftwareDrawSolid(this.breathFill_, true);
        GraphicsFillExtra.setSoftwareDrawSolid(this.breathBackFill_, true);
    }

    override public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void {
        if (!Parameters.ssmode) {
            if (this != map_.player_) {
                if (!this.starred_ && (Parameters.lowCPUMode || Parameters.data_.hideLockList)) {
                    return;
                }
            }
        }
        super.draw(_arg_1, _arg_2, _arg_3);
        if (this != map_.player_) {
            if (Parameters.ssmode) {
                drawName(_arg_1, _arg_2, false);
            }
            else {
                if (!Parameters.data_.alphaOnOthers || this.starred_) {
                    drawName(_arg_1, _arg_2, false);
                }
            }
        }
        else {
            if (this.breath_ >= 0) {
                this.drawBreathBar(_arg_1, _arg_3);
            }
        }
    }

    private function getMoveSpeed():Number {
        if (isSlowed) {
            return (MIN_MOVE_SPEED * this.moveMultiplier_);
        }
        var _local_1:Number = (MIN_MOVE_SPEED + ((this.speed_ / 75) * (MAX_MOVE_SPEED - MIN_MOVE_SPEED)));
        if (isSpeedy || isNinjaSpeedy) {
            _local_1 = (_local_1 * 1.5);
        }
        return (_local_1 * this.moveMultiplier_);
    }

    public function attackFrequency():Number {
        if (isDazed) {
            return (MIN_ATTACK_FREQ);
        }
        var _local_1:Number = (MIN_ATTACK_FREQ + ((this.dexterity_ / 75) * (MAX_ATTACK_FREQ - MIN_ATTACK_FREQ)));
        if (isBerserk) {
            _local_1 = (_local_1 * 1.5);
        }
        return (_local_1);
    }

    private function attackMultiplier():Number {
        if (isWeak) {
            return (MIN_ATTACK_MULT);
        }
        var _local_1:Number = (MIN_ATTACK_MULT + ((this.attack_ / 75) * (MAX_ATTACK_MULT - MIN_ATTACK_MULT)));
        if (isDamaging) {
            _local_1 = (_local_1 * 1.5);
        }
        return (_local_1);
    }

    private function makeSkinTexture():void {
        var _local_1:MaskedImage = this.skin.imageFromAngle(0, AnimatedChar.STAND, 0);
        animatedChar_ = this.skin;
        texture_ = _local_1.image_;
        mask_ = _local_1.mask_;
        this.isDefaultAnimatedChar = true;
    }

    private function setToRandomAnimatedCharacter():void {
        var _local_1:Vector.<XML> = ObjectLibrary.hexTransforms_;
        var _local_2:uint = Math.floor((Math.random() * _local_1.length));
        var _local_3:int = int(_local_1[_local_2].@type);
        var _local_4:TextureData = ObjectLibrary.typeToTextureData_[_local_3];
        texture_ = _local_4.texture_;
        mask_ = _local_4.mask_;
        animatedChar_ = _local_4.animatedChar_;
        this.isDefaultAnimatedChar = false;
    }

    override protected function getTexture(_arg_1:Camera, _arg_2:int):BitmapData {
        var maskedImg:MaskedImage;
        var calcMS:int;
        var dict:Dictionary;
        var _local_12:Number;
        var _local_13:int;
        var colorTrans:ColorTransform;
        var _local_3:Number = 0;
        var _local_4:int = AnimatedChar.STAND;
        if (((this.isShooting) || (_arg_2 < (attackStart_ + this.attackPeriod_)))) {
            facing_ = attackAngle_;
            _local_3 = (((_arg_2 - attackStart_) % this.attackPeriod_) / this.attackPeriod_);
            _local_4 = AnimatedChar.ATTACK;
        }
        else {
            if (((!(moveVec_.x == 0)) || (!(moveVec_.y == 0)))) {
                calcMS = int((3.5 / this.getMoveSpeed()));
                if (((!(moveVec_.y == 0)) || (!(moveVec_.x == 0)))) {
                    facing_ = Math.atan2(moveVec_.y, moveVec_.x);
                }
                _local_3 = ((_arg_2 % calcMS) / calcMS);
                _local_4 = AnimatedChar.WALK;
            }
        }
        if (this.isHexed()) {
            ((this.isDefaultAnimatedChar) && (this.setToRandomAnimatedCharacter()));
        }
        else {
            if (!this.isDefaultAnimatedChar) {
                this.makeSkinTexture();
            }
        }
        if (_arg_1.isHallucinating_) {
            maskedImg = new MaskedImage(getHallucinatingTexture(), null);
        }
        else {
            maskedImg = animatedChar_.imageFromFacing(facing_, _arg_1, _local_4, _local_3);
        }
        var tex1Id:int = tex1Id_;
        var tex2Id:int = tex2Id_;
        var bitData:BitmapData;
        if (this.nearestMerchant_) {
            dict = texturingCache_[this.nearestMerchant_];
            if (dict == null) {
                texturingCache_[this.nearestMerchant_] = new Dictionary();
            }
            else {
                bitData = dict[maskedImg];
            }
            tex1Id = this.nearestMerchant_.getTex1Id(tex1Id_);
            tex2Id = this.nearestMerchant_.getTex2Id(tex2Id_);
        }
        else {
            bitData = texturingCache_[maskedImg];
        }
        if (bitData == null) {
            bitData = TextureRedrawer.resize(maskedImg.image_, maskedImg.mask_, size_, false, tex1Id, tex2Id);
            if (this.nearestMerchant_ != null) {
                texturingCache_[this.nearestMerchant_][maskedImg] = bitData;
            }
            else {
                texturingCache_[maskedImg] = bitData;
            }
        }
        if (hp_ < (maxHP_ * 0.2)) {
            _local_12 = (int((Math.abs(Math.sin((_arg_2 / 200))) * 10)) / 10);
            _local_13 = 128;
            colorTrans = new ColorTransform(1, 1, 1, 1, (_local_12 * _local_13), (-(_local_12) * _local_13), (-(_local_12) * _local_13));
            bitData = CachingColorTransformer.transformBitmapData(bitData, colorTrans);
        }
        var txCache:BitmapData = texturingCache_[bitData];
        if (txCache == null) {
            if (this == this.map_.player_) {
                if (Parameters.VHS == 1) {
                    txCache = GlowRedrawer.outlineGlow(bitData, 0xFF00);
                } else {
                    if (Parameters.VHS == 2) {
                        txCache = GlowRedrawer.outlineGlow(bitData, 0xFFDD00);
                    } else {
                        if (this.hasSupporterFeature(SupporterFeatures.GLOW)) {
                            txCache = GlowRedrawer.outlineGlow(bitData, 13395711, 1.4, false, 0, true);
                            } else {
                                txCache = GlowRedrawer.outlineGlow(bitData, ((this.legendaryRank_ == -1) ? 0 : 0xFF0000));
                        }
                    }
                }
            }
            else {
                if (this.hasSupporterFeature(SupporterFeatures.GLOW)) {
                    txCache = GlowRedrawer.outlineGlow(bitData, 13395711, 1.4, false, 0, true);
                }
                else {
                    txCache = GlowRedrawer.outlineGlow(bitData, ((this.legendaryRank_ == -1) ? 0 : 0xFF0000));
                }
            }
            texturingCache_[bitData] = txCache;
        }
        if ((((!(Parameters.ssmode)) && (Parameters.data_.alphaOnOthers)) && ((!(this.objectId_ == map_.player_.objectId_)) && ((!(this.starred_)) || ((this.isFellowGuild_) && (Parameters.data_.showAOGuildies)))))) {
            txCache = CachingColorTransformer.alphaBitmapData(txCache, Parameters.data_.alphaMan);
        }
        else {
            if (this.isPaused || this.isStasis || this.isPetrified) {
                txCache = CachingColorTransformer.filterBitmapData(txCache, PAUSED_FILTER);
            }
            else {
                if (this.isInvisible) {
                    txCache = CachingColorTransformer.alphaBitmapData(txCache, 0.4);
                }
            }
        }
        return (txCache);
    }

    override public function getPortrait():BitmapData {
        var _local_1:MaskedImage;
        var _local_2:int;
        if (portrait_ == null) {
            _local_1 = animatedChar_.imageFromDir(AnimatedChar.RIGHT, AnimatedChar.STAND, 0);
            _local_2 = int(((4 / _local_1.image_.width) * 100));
            portrait_ = TextureRedrawer.resize(_local_1.image_, _local_1.mask_, _local_2, true, tex1Id_, tex2Id_);
            portrait_ = GlowRedrawer.outlineGlow(portrait_, 0);
        }
        return (portrait_);
    }

    public function getFamePortrait(_arg_1:int):BitmapData {
        var _local_2:MaskedImage;
        if (this.famePortrait_ == null) {
            _local_2 = animatedChar_.imageFromDir(AnimatedChar.RIGHT, AnimatedChar.STAND, 0);
            _arg_1 = int(((4 / _local_2.image_.width) * _arg_1));
            this.famePortrait_ = TextureRedrawer.resize(_local_2.image_, _local_2.mask_, _arg_1, true, tex1Id_, tex2Id_);
            this.famePortrait_ = GlowRedrawer.outlineGlow(this.famePortrait_, 0);
        }
        return (this.famePortrait_);
    }

    public function canUseAltWeapon(_arg_1:int = -1, _arg_2:XML = null):Boolean {
        if (_arg_1 == -1) {
            _arg_1 = getTimer();
        }
        if (map_ == null) {
            return (false);
        }
        if (Parameters.data_.fameBlockAbility) {
            return (false);
        }
        if (this.isQuiet) {
            return (false);
        }
        if (this.isSilenced) {
            return (false);
        }
        if (this.isPaused) {
            return (false);
        }
        if (_arg_1 < this.nextAltAttack_) {
            return (false);
        }
        var _local_3:int = equipment_[1];
        if (_local_3 == -1) {
            return (false);
        }
        if (_arg_2 == null) {
            _arg_2 = ObjectLibrary.xmlLibrary_[_local_3];
        }
        if (((_arg_2.Activate == "Shoot") && (this.isStunned))) {
            return (false);
        }
        if (_arg_2.MpCost > this.mp_) {
            return (false);
        }
        return (true);
    }


    public function useAltWeapon(_arg_1:Number, _arg_2:Number, _arg_3:int, _arg_4:int = -1, _arg_5:Boolean = false, xml:XML = null):Boolean {
        var mpCost:int;
        var altCooldown:int;
        var point:Point;
        var maxDist:Number;
        var angle:Number;
        var pointValid:Point;
        var canShoot:Boolean;
        var _local_16:Boolean;
        var _local_10:Boolean;
        var activToStr:String;
        var calc:Number;
        var minMax:Number;
        var pointMinMax:Point;
        var projectiles:XML;
        var calcSpdLife:Number;
        var offAngle:Number;
        var checkOccupy:Point;
        var activate:* = null;
        var abilNumber:Number;
        if (_arg_4 == -1) {
            _arg_4 = getTimer();
        }
        if (((map_ == null) || (this.isPaused))) {
            return (false);
        }
        if (Parameters.data_.fameBlockAbility) {
            return (false);
        }
        var equip:int = equipment_[1];
        if (equip == -1) {
            return (false);
        }
        if (xml == null) {
            xml = ObjectLibrary.xmlLibrary_[equip];
        }
        if (((xml == null) || (!("Usable" in xml)))) {
            return (false);
        }
        if (this.isQuiet) {
            SoundEffectLibrary.play("error");
            return (false);
        }
        if (this.isSilenced) {
            SoundEffectLibrary.play("error");
            return (false);
        }
        if (((xml.Activate == "Shoot") && (this.isStunned))) {
            SoundEffectLibrary.play("error");
            return (false);
        }
        if (_arg_3 == 1) {
            for each (activate in xml.Activate) {
                activToStr = activate.toString();
                if (activToStr == "TeleportLimit") {
                    maxDist = Number(activate.@maxDistance);
                    pointValid = new Point((x_ + (maxDist * Math.cos(angle))), (y_ + (maxDist * Math.sin(angle))));
                    if (!this.isValidPosition(pointValid.x, pointValid.y)) {
                        SoundEffectLibrary.play("error");
                        return (false);
                    }
                }
                if (((activToStr == "Teleport") || (activToStr == "ObjectToss"))) {
                    _local_16 = true;
                    _local_10 = true;
                }
                if ((((((activToStr == "BulletNova") || (activToStr == "PoisonGrenade")) || (activToStr == "VampireBlast")) || (activToStr == "Trap")) || (activToStr == "StasisBlast"))) {
                    _local_16 = true;
                }
                if (activToStr == "Shoot") {
                    canShoot = true;
                }
                if (activToStr == "BulletCreate") {
                    angle = Math.atan2((_arg_2 - y_), (_arg_1 - x_));
                    calc = (Math.sqrt(((_arg_1 * _arg_1) + (_arg_2 * _arg_2))) / 50);
                    minMax = Math.max(this.getAttribute(activate, "minDistance", 0), Math.min(this.getAttribute(activate, "maxDistance", 4.4), calc));
                    pointMinMax = new Point((x_ + (minMax * Math.cos(angle))), (y_ + (minMax * Math.sin(angle))));
                    projectiles = ObjectLibrary.propsLibrary_[equip].projectiles_[0];
                    calcSpdLife = ((projectiles.speed_ * projectiles.lifetime_) / 20000);
                    offAngle = (angle + (this.getAttribute(activate, "offsetAngle", 90) * 0.0174532925199433));
                    checkOccupy = new Point((pointMinMax.x + (calcSpdLife * Math.cos((offAngle + 3.14159265358979)))), (pointMinMax.y + (calcSpdLife * Math.sin((offAngle + 3.14159265358979)))));
                    if (this.isFullOccupy((checkOccupy.x + 0.5), (checkOccupy.y + 0.5))) {
                        SoundEffectLibrary.play("error");
                        return (false);
                    }
                }
            }
        }
        if (_arg_5) {
            point = new Point(_arg_1, _arg_2);
            angle = Math.atan2((_arg_2 - y_), (_arg_1 - x_));
        }
        else {
            angle = (Parameters.data_.cameraAngle + Math.atan2(_arg_2, _arg_1));
            if (_local_16) {
                point = map_.pSTopW(_arg_1, _arg_2);
                if (point) {
                    point.x = (point.x);
                    point.y = (point.y);
                }
            }
            else {
                maxDist = (Math.sqrt(((_arg_1 * _arg_1) + (_arg_2 * _arg_2))) * 0.02);
                point = new Point((x_ + (maxDist * Math.cos(angle))), (y_ + (maxDist * Math.sin(angle))));
            }
        }
        if (((objectType_ == 804) && (_local_10))) {
            if (!isValidPosition(point.x, point.y)) {
                SoundEffectLibrary.play("error");
                return (false);
            }
        }
        if (_arg_3 == 1) {
            if (_arg_4 < this.nextAltAttack_) {
                SoundEffectLibrary.play("error");
                return (false);
            }
            mpCost = xml.MpCost;
            if (mpCost > this.mp_) {
                SoundEffectLibrary.play("no_mana");
                return (false);
            }
            altCooldown = 520;
            if (("Cooldown" in xml)) {
                altCooldown = (xml.Cooldown * 1000);
            }
            this.nextAltAttack_ = (_arg_4 + altCooldown);
            if (point) {
                map_.gs_.gsc_.useItem(_arg_4, objectId_, 1, equip, point.x, point.y, _arg_3);
            }
            else {
                map_.gs_.gsc_.useItem(_arg_4, objectId_, 1, equip, x_, y_, _arg_3);
            }
            if (canShoot) {
                this.doShoot(_arg_4, equip, xml, angle, false);
            }
        }
        if (Parameters.data_.abilTimer) {
            abilNumber = (1 + (this.wisdom_ / 150));
            switch (equipment_[1]) {
                case 2650:
                case 8610:
                case 2785:
                case 2855:
                case 8333:
                    this.startTimer(11);
                    break;
                case 3080:
                case 6036:
                    this.startTimer(9);
                    break;
                case 2857:
                case 2667:
                case 8335:
                case 2225:
                    this.startTimer(12);
                    break;
                case 3078:
                    this.startTimer(int((10 * abilNumber)));
                    break;
                case 2854:
                case 2645:
                case 8344:
                case 3102:
                case 5854:
                    this.startTimer(int((8 * abilNumber)));
                    break;
            }
        }
        else {
            if (("MultiPhase" in xml)) {
                map_.gs_.gsc_.useItem(_arg_4, objectId_, 1, equip, point.x, point.y, _arg_3);
                mpCost = xml.MpEndCost;
                if (mpCost <= this.mp_) {
                    this.doShoot(_arg_4, equip, xml, angle, false);
                }
            }
        }
        return (true);
    }

    public function startTimer(_arg_1:int, _arg_2:int = 500):void {
        this.timerCount = 0;
        this.endCount = _arg_1;
        this.timerStep = _arg_2;
        this.startTime = getTimer();
    }

    public function getAttribute(_arg_1:XML, _arg_2:String, _arg_3:Number = 0):Number {
        return ((_arg_1.hasOwnProperty(("@" + _arg_2))) ? Number(_arg_1.@[_arg_2]) : _arg_3);
    }

    public function attemptAttackAngle(_arg_1:Number):void {
        if (this.equipment_[0] == -1) {
            return;
        }
        this.shoot((Parameters.data_.cameraAngle + _arg_1));
    }

    override public function setAttack(_arg_1:int, _arg_2:Number):void {
        var _local_3:XML = ObjectLibrary.xmlLibrary_[_arg_1];
        if (((_local_3 == null) || (!(_local_3.hasOwnProperty("RateOfFire"))))) {
            return;
        }
        var _local_4:Number = Number(_local_3.RateOfFire);
        this.attackPeriod_ = ((1 / this.attackFrequency()) * (1 / _local_4));
        super.setAttack(_arg_1, _arg_2);
    }

    private function shoot(_arg_1:Number, _arg_2:int = -1):void {
        if (((((map_ == null) || (this.isStunned_())) || (this.isPaused_())) || (this.isPetrified_()))) {
            return;
        }
        var equip:int = equipment_[0];
        if (equip == -1) {
            this.addTextLine.dispatch(ChatMessage.make("*Error*", "player.noWeaponEquipped"));
            return;
        }
        var xml:XML = ObjectLibrary.xmlLibrary_[equip];
        if (_arg_2 == -1) {
            _arg_2 = getTimer();
        }
        var rof:Number = xml.RateOfFire;
        this.attackPeriod_ = ((1 / this.attackFrequency()) * (1 / rof));
        if (_arg_2 < (attackStart_ + this.attackPeriod_)) {
            return;
        }
        attackAngle_ = _arg_1;
        attackStart_ = _arg_2;
        this.doShoot(attackStart_, equip, xml, attackAngle_, true);
    }

    public function doShoot(_arg_1:int, _arg_2:int, _arg_3:XML, _arg_4:Number, _arg_5:Boolean):void {
        var bulId:uint;
        var projectile:Projectile;
        var minDmg:int;
        var maxDmg:int;
        var atkM:Number;
        var nexDmg:int;
        var counter:int;
        var numProj:int = ((_arg_3.hasOwnProperty("NumProjectiles")) ? int(_arg_3.NumProjectiles) : 1);
        var arcGap:Number = (((_arg_3.hasOwnProperty("ArcGap")) ? Number(_arg_3.ArcGap) : 11.25) * 0.0174532925199433);
        var arcXproj:Number = (arcGap * (numProj - 1));
        var numMArc:Number = (_arg_4 - (arcXproj * 0.5));
        this.isShooting = _arg_5;
        if (((_arg_2 == 580) && (Parameters.data_.cultistStaffDisable))) {
            numMArc = (numMArc + Math.PI);
        }
        while (counter < numProj) {
            bulId = getBulletId();
            if (!Parameters.ssmode) {
                if (((_arg_2 == 8608) && (Parameters.data_.etheriteDisable))) {
                    numMArc = (numMArc + (((bulId % 2) != 0) ? 0.0436332312998582 : -0.0436332312998582));
                }
                else {
                    if (((_arg_2 == 596) && (Parameters.data_.offsetColossus))) {
                        numMArc = (numMArc + (((bulId % 2) != 0) ? 19 : -(19)));
                    }
                    else {
                        if (((_arg_2 == 588) && (Parameters.data_.voidbowDisable))) {
                            numMArc = (numMArc + (((bulId % 2) != 0) ? 0.06 : -0.06));
                        }
                        else {
                            if (((_arg_2 == 3113) && (Parameters.data_.spiritdaggerDisable))) {
                                numMArc = (numMArc + (((bulId % 2) != 0) ? 0.0423332312998582 : -0.0433332312998582));
                            }
                        }
                    }
                }
            }
            projectile = (FreeList.newObject(Projectile) as Projectile);
            if (((_arg_5) && (!(this.projectileIdSetOverrideNew == "")))) {
                projectile.reset(_arg_2, 0, objectId_, bulId, numMArc, _arg_1, this.projectileIdSetOverrideNew, this.projectileIdSetOverrideOld);
            }
            else {
                projectile.reset(_arg_2, 0, objectId_,  bulId, numMArc, _arg_1);
            }
            minDmg = int(projectile.projProps_.minDamage_);
            maxDmg = int(projectile.projProps_.maxDamage_);
            atkM = ((_arg_5) ? this.attackMultiplier() : 1);
            nexDmg = (map_.gs_.gsc_.getNextDamage(minDmg, maxDmg) * atkM);
            if (_arg_1 > (map_.gs_.moveRecords_.lastClearTime_ + 600)) {
                nexDmg = 0;
            }
            /*{
            --
            }*/
                projectile.setDamage(nexDmg);
            //}
            if (((counter == 0) && (!(projectile.sound_ == null)))) {
                SoundEffectLibrary.play(projectile.sound_, 0.75, false);
            }
            map_.addObj(projectile, (x_ + (Math.cos(_arg_4) * 0.3)), (y_ + (Math.sin(_arg_4) * 0.3)));
            map_.gs_.gsc_.playerShoot(_arg_1, projectile);
            numMArc = (numMArc + arcGap);
            counter++;
        }
    }

    public function isHexed():Boolean {
        return (!((condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.HEXED_BIT) == 0));
    }

    public function isInventoryFull():Boolean {
        if (equipment_ == null) {
            return (false);
        }
        var equipLenght:int = equipment_.length;
        var counter:uint = 4;
        while (counter < equipLenght) {
            if (equipment_[counter] == -1) {
                return (false);
            }
            counter++;
        }
        return (true);
    }

    public function nextAvailableInventorySlot():int {
        var slots:int = ((this.hasBackpack_) ? equipment_.length : (equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS));
        var counter:uint = 4;
        while (counter < slots) {
            if (equipment_[counter] <= 0) {
                return (counter);
            }
            counter++;
        }
        return (-1);
    }

    public function numberOfAvailableSlots():int {
        var slots:int = ((this.hasBackpack_) ? equipment_.length : (equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS));
        var counter:int;
        var counterFour:uint = 4;
        while (counterFour < slots) {
            if (equipment_[counterFour] <= 0) {
                counter++;
            }
            counterFour++;
        }
        return (counter);
    }

    public function swapInventoryIndex(_arg_1:String):int {
        var eqSlots:int;
        var eqInvSlots:int;
        if (!this.hasBackpack_) {
            return (-1);
        }
        if (_arg_1 == TabStripModel.BACKPACK) {
            eqSlots = GeneralConstants.NUM_EQUIPMENT_SLOTS;
            eqInvSlots = (GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS);
        }
        else {
            eqSlots = (GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS);
            eqInvSlots = equipment_.length;
        }
        var counter:uint = eqSlots;
        while (counter < eqInvSlots) {
            if (equipment_[counter] <= 0) {
                return (counter);
            }
            counter++;
        }
        return (-1);
    }

    public function getPotionCount(_arg_1:int):int {
        switch (_arg_1) {
            case PotionInventoryModel.HEALTH_POTION_ID:
                return (this.healthPotionCount_);
            case PotionInventoryModel.MAGIC_POTION_ID:
                return (this.magicPotionCount_);
        }
        return (0);
    }

    public function getTex1():int {
        return (tex1Id_);
    }

    public function getTex2():int {
        return (tex2Id_);
    }

    public function getClosestBag(_arg_1:Boolean):Container {
        var obj:GameObject;
        var distXY:Number;
        var maxVal:Number = Number.MAX_VALUE;
        var obj2:GameObject;
        for each (obj in map_.goDict_) {
            if (obj is Container) {
                distXY = PointUtil.distanceSquaredXY(obj.x_, obj.y_, x_, y_);
                if (distXY < maxVal) {
                    if (_arg_1) {
                        if (distXY <= 1) {
                            obj2 = obj;
                        }
                    }
                    else {
                        obj2 = obj;
                    }
                    maxVal = distXY;
                }
            }
        }
        return (obj2 as Container);
    }

    public function getClosestPortal(_arg_1:Boolean):Portal {
        var obj:GameObject;
        var distXY:Number;
        var maxVal:Number = Number.MAX_VALUE;
        var obj2:GameObject;
        for each (obj in map_.goDict_) {
            if (obj is Portal) {
                distXY = PointUtil.distanceSquaredXY(obj.x_, obj.y_, x_, y_);
                if (distXY < maxVal) {
                    if (_arg_1) {
                        if (distXY <= 1) {
                            obj2 = obj;
                        }
                    }
                    else {
                        obj2 = obj;
                    }
                    maxVal = distXY;
                }
            }
        }
        return (obj2 as Portal);
    }

    public function sToW(_arg_1:Number, _arg_2:Number):Point {
        var camAngle:Number = Parameters.data_.cameraAngle;
        var cosAngle:Number = Math.cos(camAngle);
        var sinAngle:Number = Math.sin(camAngle);
        _arg_1 = (_arg_1 / 50);
        _arg_2 = (_arg_2 / 50);
        var _local_3:Number = ((_arg_1 * cosAngle) - (_arg_2 * sinAngle));
        var _local_4:Number = ((_arg_1 * sinAngle) + (_arg_2 * cosAngle));
        return (new Point((this.x_ + _local_3), (this.y_ + _local_4)));
    }

    public function setSupporterFlag(_arg_1:int):void {
        this.supporterFlag = _arg_1;
        this.supporterFlagWasChanged.dispatch();
    }

    public function hasSupporterFeature(_arg_1:int):Boolean {
        return ((this.supporterFlag & _arg_1) == _arg_1);
    }

    public function getPotType(_arg_1:int):int {
        if ((((_arg_1 == 2591) || (_arg_1 == 5465)) || (_arg_1 == 9064))) {
            return (0);
        }
        if ((((_arg_1 == 2592) || (_arg_1 == 5466)) || (_arg_1 == 9065))) {
            return (1);
        }
        if ((((_arg_1 == 2593) || (_arg_1 == 5467)) || (_arg_1 == 9066))) {
            return (2);
        }
        if ((((_arg_1 == 2636) || (_arg_1 == 5470)) || (_arg_1 == 9069))) {
            return (3);
        }
        if ((((_arg_1 == 2612) || (_arg_1 == 5468)) || (_arg_1 == 9067))) {
            return (4);
        }
        if ((((_arg_1 == 2613) || (_arg_1 == 5469)) || (_arg_1 == 9068))) {
            return (5);
        }
        if ((((_arg_1 == 2793) || (_arg_1 == 5471)) || (_arg_1 == 9070))) {
            return (6);
        }
        if ((((_arg_1 == 2794) || (_arg_1 == 5472)) || (_arg_1 == 9071))) {
            return (7);
        }
        return (-1);
    }

    public function shouldDrink_incAndOpti(itemID:int):Boolean {
        if ((((itemID == 2591) || (itemID == 5465)) || (itemID == 9064))) {
            return ((attackMax_ - (attack_++ - attackBoost_)) > 0);
        }
        if ((((itemID == 2592) || (itemID == 5466)) || (itemID == 9065))) {
            return ((defenseMax_ - (defense_++ - defenseBoost_)) > 0);
        }
        if ((((itemID == 2593) || (itemID == 5467)) || (itemID == 9066))) {
            return ((speedMax_ - (speed_++ - speedBoost_)) > 0);
        }
        if ((((itemID == 2636) || (itemID == 5470)) || (itemID == 9069))) {
            return ((dexterityMax_ - (dexterity_++ - dexterityBoost_)) > 0);
        }
        if ((((itemID == 2612) || (itemID == 5468)) || (itemID == 9067))) {
            return ((vitalityMax_ - (vitality_++ - vitalityBoost_)) > 0);
        }
        if ((((itemID == 2613) || (itemID == 5469)) || (itemID == 9068))) {
            return ((wisdomMax_ - (wisdom_++ - wisdomBoost_)) > 0);
        }
        if ((((itemID == 2793) || (itemID == 5471)) || (itemID == 9070))) {
            itemID = (maxHPMax_ - (maxHP_ - maxHPBoost_));
            if (itemID < 5) {
                maxHP_ = (maxHPMax_ - maxHPBoost_);
            }
            else {
                maxHP_ = (maxHP_ + 5);
            }
            return (Math.ceil(((maxHPMax_ - (maxHP_ - maxHPBoost_)) * 0.2)) > 0);
        }
        if ((((itemID == 2794) || (itemID == 5472)) || (itemID == 9071))) {
            itemID = (maxMPMax_ - (maxMP_ - maxMPBoost_));
            if (itemID < 5) {
                maxMP_ = (maxMPMax_ - maxMPBoost_);
            }
            else {
                maxMP_ = (maxMP_ + 5);
            }
            return (Math.ceil(((maxMPMax_ - (maxMP_ - maxMPBoost_)) * 0.2)) > 0);
        }
        return (false);
    }

    public function shouldDrink(_arg_1:int):Boolean {
        if (_arg_1 == 0) {
            return ((attackMax_ - (attack_ - attackBoost_)) > 0);
        }
        if (_arg_1 == 1) {
            return ((defenseMax_ - (defense_ - defenseBoost_)) > 0);
        }
        if (_arg_1 == 2) {
            return ((speedMax_ - (speed_ - speedBoost_)) > 0);
        }
        if (_arg_1 == 3) {
            return ((dexterityMax_ - (dexterity_ - dexterityBoost_)) > 0);
        }
        if (_arg_1 == 4) {
            return ((vitalityMax_ - (vitality_ - vitalityBoost_)) > 0);
        }
        if (_arg_1 == 5) {
            return ((wisdomMax_ - (wisdom_ - wisdomBoost_)) > 0);
        }
        if (_arg_1 == 6) {
            return (Math.ceil(((maxHPMax_ - (maxHP_ - maxHPBoost_)) * 0.2)) > 0);
        }
        if (_arg_1 == 7) {
            return (Math.ceil(((maxMPMax_ - (maxMP_ - maxMPBoost_)) * 0.2)) > 0);
        }
        return (false);
    }

    public function textNotification(_arg_1:String, _arg_2:int = 0xFFFFFF, _arg_3:int = 2000, _arg_4:Boolean = false):void {
        if (!Parameters.ssmode) {
            if (_arg_4) {
                map_.addObj(new LevelUpEffect(this, (_arg_2 | 0x7F000000), 20), x_, y_);
            }
            var _local_5:CharacterStatusText = new CharacterStatusText(this, _arg_2, _arg_3);
            _local_5.setStringBuilder(new StaticStringBuilder(_arg_1));
            map_.mapOverlay_.addStatusText(_local_5);
        }
    }

    public function sbAssist(_arg_1:int, _arg_2:int):void {
        var pointDist:Number;
        var gameObj:GameObject;
        var _local_3:int = this.equipment_[1];
        if (_local_3 == -1) {
            return;
        }
        var objLib:XML = ObjectLibrary.xmlLibrary_[_local_3];
        for each (var _local_7:XML in objLib.Activate) {
            if (_local_7.toString() == "Teleport") {
                this.useAltWeapon(_arg_1, _arg_2, 1, -1, false);
                return;
            }
        }
        var point:Point = sToW(_arg_1, _arg_2);
        var maxVal:Number = Number.MAX_VALUE;
        for each (var _local_9:GameObject in map_.vulnEnemyDict_) {
            pointDist = PointUtil.distanceSquaredXY(_local_9.x_, _local_9.y_, point.x, point.y);
            if (pointDist < maxVal) {
                maxVal = pointDist;
                gameObj = _local_9;
            }
        }
        if (maxVal <= 25) {
            this.useAltWeapon(gameObj.x_, gameObj.y_, 1, -1, true);
        }
        else {
            this.useAltWeapon(_arg_1, _arg_2, 1, -1, false);
        }
    }

    public function getPlayer(_arg_1:String):GameObject {
        var _local_1:GameObject;
        var _local_2:GameObject;
        var _local_3:int = int.MAX_VALUE;
        var _local_4:int;
        for each (_local_1 in this.map_.goDict_) {
            if (_local_1 is Player) {
                _local_4 = MoreStringUtil.levenshtein(_arg_1, _local_1.name_.toLowerCase().substr(0, _arg_1.length));
                if (_local_4 < _local_3) {
                    _local_3 = _local_4;
                    _local_2 = _local_1;
                }
                if (_local_3 == 0) {
                    break;
                }
            }
        }
        return (_local_2);
    }

    override public function removeFromMap():void {
        if (this == map_.player_) {
            this.close();
        }
        if ((this.name_.toLowerCase() == Parameters.data_.multiLeader.toLowerCase()) || (((Parameters.followingName) && (Parameters.data_.followIntoPortals)) && (this.name_ == Parameters.followName))) {
            var gameObj:GameObject;
            for each(gameObj in this.map_.goDict_) {
                if (gameObj is Portal && this.getDistSquared(x_, y_, gameObj.x_, gameObj.y_) <= 1) {
                    this.map_.gs_.gsc_.usePortal(gameObj.objectId_);
                    break;
                }
            }
        }
        super.removeFromMap();
    }

    private function selectSlot(tradeSlot:TradeSlot):void {
        var counter:int;
        var boolVec:Vector.<Boolean> = new <Boolean>[false, false, false, false];
        this.nextSelect = (getTimer() + 175);
        tradeSlot.setIncluded((!(tradeSlot.included_)));
        counter = 4;
        while (counter < 12) {
            boolVec[counter] = map_.gs_.hudView.tradePanel.myInv_.slots_[counter].included_;
            counter++;
        }
        map_.gs_.gsc_.changeTrade(boolVec);
        map_.gs_.hudView.tradePanel.tradeButton_.reset();
    }

    private function naturalize(_arg_1:int):TradeSlot {
        var _local_2:Vector.<int> = new <int>[4, 8, 5, 9, 6, 10, 7, 11];
        return (map_.gs_.hudView.tradePanel.myInv_.slots_[_local_2[_arg_1]]);
    }

    public function vault_():void {
        var counter:int;
        var gameObj:GameObject;
        var contPos:int;
        var objPos:int;
        var container:Container;
        var num:int;
        counter = 4;
        while (counter < equipment_.length) {
            if (!this.hasBackpack_ && counter > 11) {
                break;
            }
            if (this.collect > 0 && equipment_[counter] == -1) {
                num = counter;
                break;
            }
            if (this.collect < 0 && equipment_[counter] == (0 - this.collect)) {
                num = counter;
                break;
            }
            if (this.collect == int.MIN_VALUE) {
                switch (equipment_[counter]) {
                    case 2592:
                    case 2591:
                    case 2593:
                    case 2636:
                    case 2612:
                    case 2613:
                    case 2793:
                    case 2794:
                        num = counter;
                        break;
                }
            }
            counter++;
        }
        if (num == 0) {
            this.collect = 0;
            this.textNotification("Stopping", 0xFF0000, 1500);
            return;
        }
        for each (gameObj in map_.goDict_) {
            if (gameObj.objectType_ == VAULT_CHEST) {
                if (container == null) {
                    container = (gameObj as Container);
                    contPos = int((((x_ - container.x_) * (x_ - container.x_)) + ((y_ - container.y_) * (y_ - container.y_))));
                }
                else {
                    objPos = int((((x_ - gameObj.x_) * (x_ - gameObj.x_)) + ((y_ - gameObj.y_) * (y_ - gameObj.y_))));
                    if (objPos < contPos) {
                        contPos = objPos;
                        container = (gameObj as Container);
                    }
                }
            }
        }
        if (container == null) {
            return;
        }
        if (contPos > MAX_LOOT_DIST) {
            return;
        }
        counter = 0;
        while (counter < container.equipment_.length) {
            if (container.equipment_[counter] == this.collect) {
                map_.gs_.gsc_.invSwap(this, container, counter, container.equipment_[counter], this, num, equipment_[num]);
                lastLootTime = getTimer();
                return;
            }
            if (((container.equipment_[counter] == -1) && (this.collect < 0))) {
                map_.gs_.gsc_.invSwap(this, this, num, equipment_[num], container, counter, container.equipment_[counter]);
                lastLootTime = getTimer();
                return;
            }
            if (this.collect == int.MAX_VALUE) {
                switch (container.equipment_[counter]) {
                    case 2592:
                    case 2591:
                    case 2593:
                    case 2636:
                    case 2612:
                    case 2613:
                    case 2793:
                    case 2794:
                        map_.gs_.gsc_.invSwap(this, container, counter, container.equipment_[counter], this, num, equipment_[num]);
                        lastLootTime = getTimer();
                        return;
                }
            }
            counter++;
        }
        this.collect = 0;
        this.textNotification("Stopping", 0xFF0000, 1500);
    }

    public function highestDpsWeapon(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean):int {
        var xml:XML;
        if (this.slotTypes_.length == 0) {
            return (-1);
        }
        var type:int = 1;
        var slotTypeWeap:int = this.slotTypes_[0];
        var minDmg:int;
        var maxDmg:int;
        var avgDmg:int = 0;
        var numProj:int = 1;
        var rof:int = 1;
        var atkFreq:int = 0;
        var num:int;
        var calcDmg:int = 0;
        for each (var _local_14:int in this.equipment_) {
            xml = ObjectLibrary.xmlLibrary_[_local_14];
            if (xml) {
                if (xml.SlotType != slotTypeWeap) {
                    continue;
                }
                if (xml.hasOwnProperty("Projectile")) {
                    minDmg = xml.Projectile.MinDamage;
                    maxDmg = xml.Projectile.MaxDamage;
                    avgDmg = (minDmg + (maxDmg / 2));
                    avgDmg = (avgDmg * this.attackMultiplier());
                    avgDmg = Math.max((avgDmg * 0.15), (avgDmg - _arg_1));
                    if (_arg_2) {
                        avgDmg = (avgDmg * 0.9);
                    }
                    if (_arg_3) {
                        avgDmg = (avgDmg * 1.2);
                    }
                    if (xml.hasOwnProperty("RateOfFire")) {
                        rof = xml.RateOfFire;
                    }
                    if (xml.hasOwnProperty("NumProjectiles")) {
                        numProj = xml.NumProjectiles;
                    }
                    atkFreq = ((this.attackFrequency() * rof) * 1000);
                    calcDmg = ((atkFreq * avgDmg) * numProj);
                    if (calcDmg > num) {
                        num = calcDmg;
                        type = int(xml.@type);
                    }
                }
            }
            minDmg = 0;
            maxDmg = 0;
            avgDmg = 0;
            rof = 1;
            numProj = 1;
            calcDmg = 0;
        }
        return (type);
    }


}
}//package com.company.assembleegameclient.objects

