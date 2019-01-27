//com.company.assembleegameclient.objects.ObjectProperties

package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.sound.SoundEffectLibrary;

import flash.utils.Dictionary;

public class ObjectProperties {

    public var type_:int;
    public var id_:String;
    public var displayId_:String;
    public var shadowSize_:int;
    public var isPlayer_:Boolean = false;
    public var isEnemy_:Boolean = false;
    public var isQuest_:Boolean;
    public var boss_:Boolean = false;
    public var rateOfFire_:Number;
    public var drawOnGround_:Boolean = false;
    public var ignored:Boolean;
    public var excepted:Boolean;
    public var drawUnder_:Boolean = false;
    public var occupySquare_:Boolean = false;
    public var fullOccupy_:Boolean = false;
    public var enemyOccupySquare_:Boolean = false;
    public var static_:Boolean = false;
    public var noMiniMap_:Boolean = false;
    public var isCube_:Boolean;
    public var isGod_:Boolean;
    public var slotType_:int = int.MIN_VALUE;
    public var tier:int = int.MIN_VALUE;
    public var noHealthBar_:Boolean = false;
    public var healthBar_:int = 0;
    public var protectFromGroundDamage_:Boolean = false;
    public var desiredLoot_:Boolean;
    public var isItem_:Boolean = false;
    public var isPotion_:Boolean;
    public var protectFromSink_:Boolean = false;
    public var z_:Number = 0;
    public var flying_:Boolean = false;
    public var color_:int = -1;
    public var showName_:Boolean = false;
    public var dontFaceAttacks_:Boolean = false;
    public var dontFaceMovement_:Boolean = false;
    public var bloodProb_:Number = 0;
    public var bloodColor_:uint = 0xFF0000;
    public var shadowColor_:uint = 0;
    public var sounds_:Object = null;
    public var portrait_:TextureData = null;
    public var minSize_:int = 100;
    public var maxSize_:int = 100;
    public var sizeStep_:int = 5;
    public var whileMoving_:WhileMovingProperties = null;
    public var belonedDungeon:String = "";
    public var oldSound_:String = null;
    public var projectiles_:Dictionary = new Dictionary();
    public var angleCorrection_:Number = 0;
    public var rotation_:Number = 0;

    internal const unlistedBosses:Vector.<int> = new <int>[1337, 0x0800, 2340, 2349, 3448, 3449, 3452, 3613, 3622, 4312, 4324, 4325, 4326, 5943, 8200, 24092, 24327, 24351, 24363, 24587, 29003, 29021, 29039, 29341, 29342, 29723, 29764, 30026, 45104, 45371, 45076, 28618, 28619, 32751, 29793];


    public function ObjectProperties(xml:XML) {
        var _local_2:XML;
        var _local_3:XML;
        var _local_4:int;
        super();
        if (xml == null) {
            return;
        }
        this.type_ = int(xml.@type);
        this.id_ = String(xml.@id);
        this.displayId_ = this.id_;
        if (xml.hasOwnProperty("DisplayId")) {
            this.displayId_ = xml.DisplayId;
        }
        this.isGod_ = ("God" in xml);
        this.isCube_ = ("Cube" in xml);
        this.shadowSize_ = ((xml.hasOwnProperty("ShadowSize")) ? xml.ShadowSize : 100);
        this.isPlayer_ = xml.hasOwnProperty("Player");
        this.isEnemy_ = xml.hasOwnProperty("Enemy");
        this.isItem_ = xml.hasOwnProperty("Item");
        this.drawOnGround_ = xml.hasOwnProperty("DrawOnGround");
        if (((this.drawOnGround_) || (xml.hasOwnProperty("DrawUnder")))) {
            this.drawUnder_ = true;
        }
        if (xml.hasOwnProperty("SlotType")) {
            this.slotType_ = xml.SlotType;
        }
        this.boss_ = xml.hasOwnProperty("Quest");
        if (this.unlistedBosses.indexOf(this.type_) >= 0) {
            this.boss_ = true;
        }
        this.occupySquare_ = xml.hasOwnProperty("OccupySquare");
        this.fullOccupy_ = xml.hasOwnProperty("FullOccupy");
        this.enemyOccupySquare_ = xml.hasOwnProperty("EnemyOccupySquare");
        this.static_ = xml.hasOwnProperty("Static");
        this.noMiniMap_ = xml.hasOwnProperty("NoMiniMap");
        if (xml.hasOwnProperty("HealthBar")) {
            this.healthBar_ = xml.HealthBar;
        }
        this.protectFromGroundDamage_ = xml.hasOwnProperty("ProtectFromGroundDamage");
        this.protectFromSink_ = xml.hasOwnProperty("ProtectFromSink");
        this.flying_ = xml.hasOwnProperty("Flying");
        this.showName_ = xml.hasOwnProperty("ShowName");
        this.dontFaceAttacks_ = xml.hasOwnProperty("DontFaceAttacks");
        this.dontFaceMovement_ = xml.hasOwnProperty("DontFaceMovement");
        this.isPotion_ = ("Potion" in xml);
        if (xml.hasOwnProperty("Z")) {
            this.z_ = Number(xml.Z);
        }
        if (xml.hasOwnProperty("Color")) {
            this.color_ = uint(xml.Color);
        }
        if (xml.hasOwnProperty("Size")) {
            this.minSize_ = (this.maxSize_ = xml.Size);
        }
        else {
            if (xml.hasOwnProperty("MinSize")) {
                this.minSize_ = xml.MinSize;
            }
            if (xml.hasOwnProperty("MaxSize")) {
                this.maxSize_ = xml.MaxSize;
            }
            if (xml.hasOwnProperty("SizeStep")) {
                this.sizeStep_ = xml.SizeStep;
            }
        }
        this.oldSound_ = ((xml.hasOwnProperty("OldSound")) ? String(xml.OldSound) : null);
        for each (_local_2 in xml.Projectile) {
            _local_4 = int(_local_2.@id);
            this.projectiles_[_local_4] = new ProjectileProperties(_local_2);
        }
        this.rateOfFire_ = (("RateOfFire" in xml) ? xml.RateOfFire : 0);
        this.angleCorrection_ = ((xml.hasOwnProperty("AngleCorrection")) ? ((Number(xml.AngleCorrection) * Math.PI) / 4) : 0);
        this.rotation_ = ((xml.hasOwnProperty("Rotation")) ? xml.Rotation : 0);
        if (xml.hasOwnProperty("BloodProb")) {
            this.bloodProb_ = Number(xml.BloodProb);
        }
        if (xml.hasOwnProperty("BloodColor")) {
            this.bloodColor_ = uint(xml.BloodColor);
        }
        if (xml.hasOwnProperty("ShadowColor")) {
            this.shadowColor_ = uint(xml.ShadowColor);
        }
        for each (_local_3 in xml.Sound) {
            if (this.sounds_ == null) {
                this.sounds_ = {};
            }
            this.sounds_[int(_local_3.@id)] = _local_3.toString();
        }
        if (xml.hasOwnProperty("Portrait")) {
            this.portrait_ = new TextureDataConcrete(XML(xml.Portrait));
        }
        if (xml.hasOwnProperty("WhileMoving")) {
            this.whileMoving_ = new WhileMovingProperties(XML(xml.WhileMoving));
        }
    }

    public function loadSounds():void {
        var _local_1:String;
        if (this.sounds_ == null) {
            return;
        }
        for each (_local_1 in this.sounds_) {
            SoundEffectLibrary.load(_local_1);
        }
    }

    public function getSize():int {
        if (this.minSize_ == this.maxSize_) {
            return (this.minSize_);
        }
        var _local_1:int = int(((this.maxSize_ - this.minSize_) / this.sizeStep_));
        return (this.minSize_ + (int((Math.random() * _local_1)) * this.sizeStep_));
    }


}
}//package com.company.assembleegameclient.objects

class WhileMovingProperties {

    public var z_:Number = 0;
    public var flying_:Boolean = false;

    public function WhileMovingProperties(_arg_1:XML) {
        if (_arg_1.hasOwnProperty("Z")) {
            this.z_ = Number(_arg_1.Z);
        }
        this.flying_ = _arg_1.hasOwnProperty("Flying");
    }

}


