﻿//com.company.assembleegameclient.objects.Projectile

package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.engine3d.Point3D;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.Square;
import com.company.assembleegameclient.objects.particles.HitEffect;
import com.company.assembleegameclient.objects.particles.SparkParticle;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;
import com.company.assembleegameclient.util.BloodComposition;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.GraphicsUtil;
import com.company.util.Trig;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.Dictionary;

import zfn.Hit;

public class Projectile extends BasicObject {

    private static var objBullIdToObjId_:Dictionary = new Dictionary();

    public var props_:ObjectProperties;
    public var containerProps_:ObjectProperties;
    public var projProps_:ProjectileProperties;
    public var texture_:BitmapData;
    public var bulletId_:uint;
    public var ownerId_:int;
    public var containerType_:int;
    public var bulletType_:uint;
    public var damagesEnemies_:Boolean;
    public var damagesPlayers_:Boolean;
    public var damage_:int;
    public var sound_:String;
    public var startX_:Number;
    public var startY_:Number;
    public var startTime_:int;
    public var angle_:Number = 0;
    public var multiHitDict_:Dictionary;
    public var p_:Point3D = new Point3D(100);
    private var staticPoint_:Point = new Point();
    private var staticVector3D_:Vector3D = new Vector3D();
    protected var shadowGradientFill_:GraphicsGradientFill = new GraphicsGradientFill(GradientType.RADIAL, [0, 0], [0.5, 0], null, new Matrix());
    protected var shadowPath_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());


    public static function findObjId(_arg_1:int, _arg_2:uint):int {
        return (objBullIdToObjId_[((_arg_2 << 24) | _arg_1)]);
    }

    public static function getNewObjId(_arg_1:int, _arg_2:uint):int {
        var _local_3:int = getNextFakeObjectId();
        objBullIdToObjId_[((_arg_2 << 24) | _arg_1)] = _local_3;
        return (_local_3);
    }

    public static function removeObjId(_arg_1:int, _arg_2:uint):void {
        delete objBullIdToObjId_[((_arg_2 << 24) | _arg_1)];
    }

    public static function dispose():void {
        objBullIdToObjId_ = new Dictionary();
    }


    public function reset(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:int, _arg_7:String = "", _arg_8:String = ""):void {
        var _local_11:Number;
        clear();
        this.containerType_ = _arg_1;
        this.bulletType_ = _arg_2;
        this.ownerId_ = _arg_3;
        this.bulletId_ = _arg_4;
        this.angle_ = Trig.boundToPI(_arg_5);
        this.startTime_ = _arg_6;
        objectId_ = getNewObjId(this.ownerId_, this.bulletId_);
        z_ = 0.5;
        this.containerProps_ = ObjectLibrary.propsLibrary_[this.containerType_];
        this.projProps_ = this.containerProps_.projectiles_[_arg_2];
        var _local_9:String = (((!(_arg_7 == "")) && (this.projProps_.objectId_ == _arg_8)) ? _arg_7 : this.projProps_.objectId_);
        this.props_ = ObjectLibrary.getPropsFromId(_local_9);
        hasShadow_ = (this.props_.shadowSize_ > 0);
        var _local_10:TextureData = ObjectLibrary.typeToTextureData_[this.props_.type_];
        this.texture_ = _local_10.getTexture(objectId_);
        this.damagesPlayers_ = this.containerProps_.isEnemy_;
        this.damagesEnemies_ = (!(this.damagesPlayers_));
        this.sound_ = this.containerProps_.oldSound_;
        this.multiHitDict_ = ((this.projProps_.multiHit_) ? new Dictionary() : null);
        if (this.projProps_.size_ >= 0) {
            _local_11 = this.projProps_.size_;
        }
        else {
            _local_11 = ObjectLibrary.getSizeFromType(this.containerType_);
        }
        //--
        this.p_.setSize((8 * (_local_11 / 100)));
        this.damage_ = 0;
    }

    public function setDamage(_arg_1:int):void {
        this.damage_ = _arg_1;
    }

    override public function addTo(_arg_1:Map, _arg_2:Number, _arg_3:Number):Boolean {
        var _local_4:Player;
        this.startX_ = _arg_2;
        this.startY_ = _arg_3;
        if (!super.addTo(_arg_1, _arg_2, _arg_3)) {
            return (false);
        }
        if (((!(this.containerProps_.flying_)) && (square_.sink_))) {
            z_ = 0.1;
        }
        //--
        else {
            _local_4 = (_arg_1.goDict_[this.ownerId_] as Player);
            if (((!(_local_4 == null)) && (_local_4.sinkLevel_ > 0))) {
                z_ = (0.5 - (0.4 * (_local_4.sinkLevel_ / Parameters.MAX_SINK_LEVEL)));
            }
        }
        return (true);
    }

    public function moveTo(_arg_1:Number, _arg_2:Number):Boolean {
        var _local_3:Square = map_.getSquare(_arg_1, _arg_2);
        if (_local_3 == null) {
            return (false);
        }
        x_ = _arg_1;
        y_ = _arg_2;
        square_ = _local_3;
        return (true);
    }

    override public function removeFromMap():void {
        super.removeFromMap();
        removeObjId(this.ownerId_, this.bulletId_);
        this.multiHitDict_ = null;
        FreeList.deleteObject(this);
    }

    private function positionAt(_arg_1:int, _arg_2:Point):void {
        var _local_5:Number;
        var _local_6:Number;
        var _local_7:Number;
        var _local_8:Number;
        var _local_9:Number;
        var _local_10:Number;
        var _local_11:Number;
        var _local_12:Number;
        var _local_13:Number;
        var _local_14:Number;
        _arg_2.x = this.startX_;
        _arg_2.y = this.startY_;
        var _local_3:Number = (_arg_1 * (this.projProps_.speed_ / 10000));
        var _local_4:Number = (((this.bulletId_ % 2) == 0) ? 0 : Math.PI);
        if (this.projProps_.wavy_) {
            _local_5 = (6 * Math.PI);
            _local_6 = (Math.PI / 64);
            _local_7 = (this.angle_ + (_local_6 * Math.sin((_local_4 + ((_local_5 * _arg_1) / 1000)))));
            _arg_2.x = (_arg_2.x + (_local_3 * Math.cos(_local_7)));
            _arg_2.y = (_arg_2.y + (_local_3 * Math.sin(_local_7)));
        }
        else {
            if (this.projProps_.parametric_) {
                _local_8 = (((_arg_1 / this.projProps_.lifetime_) * 2) * Math.PI);
                _local_9 = (Math.sin(_local_8) * ((this.bulletId_ % 2) ? 1 : -1));
                _local_10 = (Math.sin((2 * _local_8)) * (((this.bulletId_ % 4) < 2) ? 1 : -1));
                _local_11 = Math.sin(this.angle_);
                _local_12 = Math.cos(this.angle_);
                _arg_2.x = (_arg_2.x + (((_local_9 * _local_12) - (_local_10 * _local_11)) * this.projProps_.magnitude_));
                _arg_2.y = (_arg_2.y + (((_local_9 * _local_11) + (_local_10 * _local_12)) * this.projProps_.magnitude_));
            }
            else {
                if (this.projProps_.boomerang_) {
                    _local_13 = ((this.projProps_.lifetime_ * (this.projProps_.speed_ / 10000)) / 2);
                    if (_local_3 > _local_13) {
                        _local_3 = (_local_13 - (_local_3 - _local_13));
                    }
                }
                _arg_2.x = (_arg_2.x + (_local_3 * Math.cos(this.angle_)));
                _arg_2.y = (_arg_2.y + (_local_3 * Math.sin(this.angle_)));
                if (this.projProps_.amplitude_ != 0) {
                    _local_14 = (this.projProps_.amplitude_ * Math.sin((_local_4 + ((((_arg_1 / this.projProps_.lifetime_) * this.projProps_.frequency_) * 2) * Math.PI))));
                    _arg_2.x = (_arg_2.x + (_local_14 * Math.cos((this.angle_ + (Math.PI / 2)))));
                    _arg_2.y = (_arg_2.y + (_local_14 * Math.sin((this.angle_ + (Math.PI / 2)))));
                }
            }
        }
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean {
        var bloodCompColor:Vector.<uint>;
        var p:Player;
        var playerBool:Boolean;
        var isEnemyBool:Boolean;
        var bool:Boolean;
        var dmgWithDef:int;
        var effBool:Boolean;
        var startTime:int = (_arg_1 - this.startTime_);
        if (startTime > this.projProps_.lifetime_) {
            return (false);
        }
        var _local_4:Point = this.staticPoint_;
        this.positionAt(startTime, _local_4);
        if (((!(this.moveTo(_local_4.x, _local_4.y))) || (square_.tileType_ == 0xFFFF))) {
            if (this.damagesPlayers_) {
                map_.gs_.gsc_.squareHit(_arg_1, this.bulletId_, this.ownerId_);
            }
            else {
                if (square_.obj_ != null) {
                    if (!Parameters.data_.noParticlesMaster || !Parameters.ssmode && !Parameters.data_.liteParticle) {
                        if (texture_ != null) {
                            bloodCompColor = BloodComposition.getColors(this.texture_);
                            map_.addObj(new HitEffect(bloodCompColor, 100, 3, this.angle_, this.projProps_.speed_), _local_4.x, _local_4.y);
                        }
                    }
                }
            }
            return (false);
        }
        if ((((!(square_.obj_ == null)) && ((!(square_.obj_.props_.isEnemy_)) || (!(this.damagesEnemies_)))) && ((square_.obj_.props_.enemyOccupySquare_) || ((!(this.projProps_.passesCover_)) && (square_.obj_.props_.occupySquare_))))) {
            if (this.damagesPlayers_) {
                map_.gs_.gsc_.otherHit(_arg_1, this.bulletId_, this.ownerId_, square_.obj_.objectId_);
            }
            else {
                if (!Parameters.data_.noParticlesMaster) {
                    bloodCompColor = BloodComposition.getColors(this.texture_);
                    map_.addObj(new HitEffect(bloodCompColor, 100, 3, this.angle_, this.projProps_.speed_), _local_4.x, _local_4.y);
                }
            }
            if ((!((Parameters.data_.PassesCover) && (this.ownerId_ == map_.player_.objectId_) && (!Parameters.ssmode)))) {
                return (false);
            }
        }
        //--
        var gameobj:GameObject = this.getHit(_local_4.x, _local_4.y);
        if (gameobj != null) {
            p = map_.player_;
            playerBool = (!(p == null));
            isEnemyBool = gameobj.props_.isEnemy_;
            bool = (((playerBool) && (!(p.isPaused))) && ((this.damagesPlayers_) || ((isEnemyBool) && (this.ownerId_ == p.objectId_))));
            if (bool) {
                dmgWithDef = GameObject.damageWithDefense(this.damage_, gameobj.defense_, this.projProps_.armorPiercing_, gameobj.condition_);
                effBool = false;
                if (gameobj.hp_ <= dmgWithDef) {
                    effBool = true;
                    if (gameobj.props_.isEnemy_) {
                        doneAction(map_.gs_, Tutorial.KILL_ACTION);
                    }
                }
                if (gameobj == p) {
                    if (p.subtractDamage(dmgWithDef, _arg_1)) {
                        return (false);
                    }
                    if (this.projProps_.effects_ != null) {
                        effBool = false;
                        var counter:int = 0;
                        while (counter < this.projProps_.effects_.length) {
                            var effect:uint = this.projProps_.effects_[counter];
                            if (effect > 32) {
                                effect = ((1 << effect) & Parameters.data_.ssdebuffBitmask2);
                            }
                            else {
                                effect = ((1 << (effect - 32)) & Parameters.data_.ssdebuffBitmask);
                            }
                            if (effect > 0) {
                                effBool = true;
                            }
                            counter++;
                        }
                        if (effBool) {
                            p.damage(true, dmgWithDef, null, false, this);
                        }
                        else {
                            p.damage(true, dmgWithDef, this.projProps_.effects_, false, this);
                            this.map_.gs_.hitQueue.push(new Hit(this.bulletId_, this.ownerId_));
                        }
                    }
                    else {
                        p.damage(true, dmgWithDef, this.projProps_.effects_, false, this);
                        this.map_.gs_.hitQueue.push(new Hit(bulletId_, ownerId_));
                    }
                }
                else {
                    if (gameobj.props_.isEnemy_) {
                        if (((!(this.damageIgnored(gameobj))) || (((gameobj.isInvulnerable) && (!(this.isStunned()))) && (Parameters.data_.PassesCover)))) {
                            return (true);
                        }
                        if ((((gameobj.props_.isCube_) && (Parameters.data_.fameBlockCubes)) || ((!(gameobj.props_.isGod_)) && (Parameters.data_.fameBlockGodsOnly)))) {
                            return (true);
                        }
                        if (isNaN(Parameters.dmgCounter[gameobj.objectId_])) {
                            Parameters.dmgCounter[gameobj.objectId_] = 0;
                        }
                        map_.gs_.gsc_.enemyHit(_arg_1, this.bulletId_, gameobj.objectId_, effBool);
                        gameobj.damage(true, dmgWithDef, this.projProps_.effects_, effBool, this);
                        if (isNaN(Parameters.dmgCounter[gameobj.objectId_])) {
                            Parameters.dmgCounter[gameobj.objectId_] = 0;
                        }
                        Parameters.dmgCounter[gameobj.objectId_] = (Parameters.dmgCounter[gameobj.objectId_] + dmgWithDef);
                    }
                    else {
                        if (!this.projProps_.multiHit_) {
                            map_.gs_.gsc_.otherHit(_arg_1, this.bulletId_, this.ownerId_, gameobj.objectId_);
                        }
                    }
                }
            }
            if (this.projProps_.multiHit_) {
                this.multiHitDict_[gameobj] = true;
            }
            else {
                return (false);
            }
        }
        return (true);
    }

    private function isStunned():Boolean {
        if (((this.containerType_ > 2567) && (this.containerType_ < 2573))) {
            return (true);
        }
        if (((this.containerType_ > 2656) && (this.containerType_ < 2662))) {
            return (true);
        }
        switch (this.containerType_) {
            case 2767:
            case 2850:
            case 2624:
            case 9017:
            case 3395:
            case 3087:
            case 3079:
            case 2856:
            case 2782:
            case 2326:
                return (true);
        }
        return (false);
    }

    public function damageIgnored(_arg_1:GameObject):Boolean {
        var _local_2:int;
        for each (_local_2 in Parameters.data_.AAIgnore) {
            if (_local_2 == _arg_1.props_.type_) {
                if ((!(Parameters.data_.damageIgnored))) {
                    return (false);
                }
                break;
            }
        }
        return (true);
    }


    public function getHit(_arg_1:Number, _arg_2:Number):GameObject {
        var _local_5:GameObject;
        var _local_6:Number;
        var _local_7:Number;
        var _local_8:Number;
        var _local_9:Number;
        var _local_3:Number = Number.MAX_VALUE;
        var _local_4:GameObject;
        for each (_local_5 in map_.goDict_) {
            if (!_local_5.isInvincible) {
                if (!_local_5.isStasis) {
                    //--
                    if ((((this.damagesEnemies_) && (_local_5.props_.isEnemy_)) || ((this.damagesPlayers_) && (_local_5.props_.isPlayer_)))) {
                        if (!((_local_5.dead_) || (_local_5.isPaused))) {
                            _local_6 = ((_local_5.x_ > _arg_1) ? (_local_5.x_ - _arg_1) : (_arg_1 - _local_5.x_));
                            _local_7 = ((_local_5.y_ > _arg_2) ? (_local_5.y_ - _arg_2) : (_arg_2 - _local_5.y_));
                            if (!((_local_6 > _local_5.radius_) || (_local_7 > _local_5.radius_))) {
                                if (!((this.projProps_.multiHit_) && (!(this.multiHitDict_[_local_5] == null)))) {
                                    if (_local_5 == map_.player_) {
                                        return (_local_5);
                                    }
                                    _local_8 = Math.sqrt(((_local_6 * _local_6) + (_local_7 * _local_7)));
                                    _local_9 = ((_local_6 * _local_6) + (_local_7 * _local_7));
                                    if (_local_9 < _local_3) {
                                        _local_3 = _local_9;
                                        _local_4 = _local_5;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return (_local_4);
    }

    override public function draw(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void {
        var colDec:uint;
        var colHex:uint;
        var trail:int;
        var counter:int;
        if (!Parameters.drawProj_) {
            return;
        }
        var _local_4:BitmapData = this.texture_;
        if (Parameters.projColorType_ != 0) {
            switch (Parameters.projColorType_) {
                case 1:
                    colDec = 16777100;
                    colHex = 0xFFFFFF;
                    break;
                case 2:
                    colDec = 16777100;
                    colHex = 16777100;
                    break;
                case 3:
                    colDec = 0xFF0000;
                    colHex = 0xFF0000;
                    break;
                case 4:
                    colDec = 0xFF;
                    colHex = 0xFF;
                    break;
                case 5:
                    colDec = 0xFFFFFF;
                    colHex = 0xFFFFFF;
                    break;
                case 6:
                    colDec = 0;
                    colHex = 0;
                    break;
            }
            _local_4 = TextureRedrawer.redraw(_local_4, 120, true, colHex);
        }
        var _local_5:Number;
        if (Parameters.ssmode || !Parameters.data_.noRotate) {
            _local_5 = ((props_.rotation_ == 0) ? 0 : (_arg_3 / props_.rotation_));
        }
        else {
            _local_5 = 0;
        }
        this.staticVector3D_.x = x_;
        this.staticVector3D_.y = y_;
        this.staticVector3D_.z = z_;
        var _local_6:Number = ((this.projProps_.faceDir_) ? this.getDirectionAngle(_arg_3) : this.angle_);
        var _local_7:Number = ((this.projProps_.noRotation_) ? (_arg_2.angleRad_ + this.props_.angleCorrection_) : (((_local_6 - _arg_2.angleRad_) + this.props_.angleCorrection_) + _local_5));
        this.p_.draw(_arg_1, this.staticVector3D_, _local_7, _arg_2.wToS_, _arg_2, _local_4);
        if (projProps_.particleTrail_ && (!Parameters.data_.noParticlesMaster || Parameters.ssmode || !Parameters.data_.liteParticle)) {
            trail = ((this.projProps_.particleTrailLifetimeMS != -1) ? this.projProps_.particleTrailLifetimeMS : 600);
            counter = 0;
            while (counter < 3) {
                if (map_ != null && map_.player_.objectId_ != ownerId_ || (!(projProps_.particleTrailIntensity_ == -1 && (Math.random() * 100) > projProps_.particleTrailIntensity_))) {
                    map_.addObj(new SparkParticle(100, projProps_.particleTrailColor_, trail, 0.5, RandomUtil.plusMinus(3), RandomUtil.plusMinus(3)), x_, y_);
                }
                counter++;
            }
        }
    }

    private function getDirectionAngle(_arg_1:Number):Number {
        var _local_2:int = (_arg_1 - this.startTime_);
        var _local_3:Point = new Point();
        this.positionAt((_local_2 + 16), _local_3);
        var _local_4:Number = (_local_3.x - x_);
        var _local_5:Number = (_local_3.y - y_);
        return (Math.atan2(_local_5, _local_4));
    }

    override public function drawShadow(_arg_1:Vector.<IGraphicsData>, _arg_2:Camera, _arg_3:int):void {
        if (!Parameters.drawProj_) {
            return;
        }
        var _local_4:Number = (this.props_.shadowSize_ / 400);
        var _local_5:Number = (30 * _local_4);
        var _local_6:Number = (15 * _local_4);
        this.shadowGradientFill_.matrix.createGradientBox((_local_5 * 2), (_local_6 * 2), 0, (posS_[0] - _local_5), (posS_[1] - _local_6));
        _arg_1.push(this.shadowGradientFill_);
        this.shadowPath_.data.length = 0;
        Vector.<Number>(this.shadowPath_.data).push((posS_[0] - _local_5), (posS_[1] - _local_6), (posS_[0] + _local_5), (posS_[1] - _local_6), (posS_[0] + _local_5), (posS_[1] + _local_6), (posS_[0] - _local_5), (posS_[1] + _local_6));
        _arg_1.push(this.shadowPath_);
        _arg_1.push(GraphicsUtil.END_FILL);
    }


}
}//package com.company.assembleegameclient.objects

