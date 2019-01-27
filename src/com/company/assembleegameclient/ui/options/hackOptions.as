﻿//com.company.assembleegameclient.ui.options.Options

package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.util.KeyCodes;
import com.greensock.plugins.DropShadowFilterPlugin;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.Capabilities;
import flash.text.TextFieldAutoSize;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.view.Layers;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.UIUtils;

import org.swiftsuspenders.Injector;

public class hackOptions extends Sprite {
    public static const Y_POSITION:int = 550;

    private var gs_:GameSprite;
    private var continueButton_:TitleMenuOption;
    private var resetToDefaultsButton_:TitleMenuOption;
    private var homeButton_:TitleMenuOption;
    private var backButton:TitleMenuOption;
    private var layers:Layers;
    private var tabs_:Vector.<OptionsTabTitle> = new Vector.<OptionsTabTitle>();
    private var selected_:OptionsTabTitle;
    private var options_:Vector.<Sprite> = new Vector.<Sprite>();
    private var defaultTab_:OptionsTabTitle;

    public function hackOptions(_arg_1:GameSprite) {
        var TABS:Vector.<String>;
        var _local_2:TextFieldDisplayConcrete;
        var _local_6:OptionsTabTitle;
        var _local_7:OptionsTabTitle;
        TABS = new <String>["DBKeys", "Visual 2"];
        super();
        this.gs_ = _arg_1;
        graphics.clear();
        graphics.beginFill(0x2B2B2B, 0.8);
        graphics.drawRect(0, 0, 800, 600);
        graphics.endFill();
        graphics.lineStyle(1, 0x5E5E5E);
        graphics.moveTo(0, 100);
        graphics.lineTo(800, 100);
        graphics.lineStyle();
        _local_2 = new TextFieldDisplayConcrete().setSize(36).setColor(0xFFFFFF);
        _local_2.setBold(true);
        _local_2.setStringBuilder(new LineBuilder().setParams("Options 2"));
        _local_2.setAutoSize(TextFieldAutoSize.CENTER);
        _local_2.filters = [DropShadowFilterPlugin.DEFAULT_FILTER];
        _local_2.x = ((800 / 2) - (_local_2.width / 2));
        _local_2.y = 8;
        addChild(_local_2);
        addChild(new ScreenGraphic());
        this.continueButton_ = new TitleMenuOption(TextKey.OPTIONS_CONTINUE_BUTTON, 36, false);
        this.continueButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.continueButton_.setAutoSize(TextFieldAutoSize.CENTER);
        this.continueButton_.addEventListener(MouseEvent.CLICK, this.onContinueClick);
        addChild(this.continueButton_);

        this.backButton = new TitleMenuOption("Back", 24, false);
        this.backButton.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.backButton.setAutoSize(TextFieldAutoSize.LEFT);
        this.backButton.addEventListener(MouseEvent.CLICK, this.onBackClick);
        addChild(this.backButton);

        this.resetToDefaultsButton_ = new TitleMenuOption(TextKey.OPTIONS_RESET_TO_DEFAULTS_BUTTON, 22, false);
        this.resetToDefaultsButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.resetToDefaultsButton_.setAutoSize(TextFieldAutoSize.LEFT);
        this.resetToDefaultsButton_.addEventListener(MouseEvent.CLICK, this.onResetToDefaultsClick);
        addChild(this.resetToDefaultsButton_);
        this.homeButton_ = new TitleMenuOption(TextKey.OPTIONS_HOME_BUTTON, 22, false);
        this.homeButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.homeButton_.setAutoSize(TextFieldAutoSize.RIGHT);
        this.homeButton_.addEventListener(MouseEvent.CLICK, this.onHomeClick);
        addChild(this.homeButton_);
        var _local_3:int = 14;
        var _local_4:int;
        while (_local_4 < TABS.length) {
            _local_7 = new OptionsTabTitle(TABS[_local_4]);
            _local_7.x = _local_3;
            if (Parameters.ssmode) {
                _local_7.y = 70;
                _local_3 = (_local_3 + ((UIUtils.SHOW_EXPERIMENTAL_MENU) ? 90 : 108));
            }
            else {
                _local_7.y = (50 + (25 * int((_local_4 / 8))));
                if ((_local_4 % 8) == 0) {
                    _local_3 = 14;
                    _local_7.x = _local_3;
                }
                _local_3 = (_local_3 + 94);
                if (_local_7.text_ == Parameters.data_.lastTab) {
                    _local_6 = _local_7;
                }
            }
            addChild(_local_7);
            _local_7.addEventListener(MouseEvent.CLICK, this.onTabClick);
            this.tabs_.push(_local_7);
            _local_4++;
        }
        if (_local_6 != null) {
            this.defaultTab_ = _local_6;
        }
        else {
            this.defaultTab_ = this.tabs_[0];
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        var _local_5:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
        _local_5.dispatch();
        var loc2:Injector = StaticInjectorContext.getInjector();
        this.layers = loc2.getInstance(Layers);
    }

    private static function makeOnOffLabels():Vector.<StringBuilder> {
        return (new <StringBuilder>[makeLineBuilder(TextKey.OPTIONS_ON), makeLineBuilder(TextKey.OPTIONS_OFF)]);
    }

    private static function makeLineBuilder(_arg_1:String):LineBuilder {
        return (new LineBuilder().setParams(_arg_1));
    }

    private function onContinueClick(_arg_1:MouseEvent):void {
        this.close();
    }

    private function onResetToDefaultsClick(_arg_1:MouseEvent):void {
        var _local_3:BaseOption;
        var _local_2:int;
        while (_local_2 < this.options_.length) {
            _local_3 = (this.options_[_local_2] as BaseOption);
            if (_local_3 != null) {
                delete Parameters.data_[_local_3.paramName_];
            }
            _local_2++;
        }
        Parameters.setDefaults();
        Parameters.save();
        this.refresh();
    }

    private function onHomeClick(_arg_1:MouseEvent):void {
        this.close();
        Parameters.fameBot = false;
        this.gs_.closed.dispatch();
    }

    private function onTabClick(_arg_1:MouseEvent):void {
        var _local_2:OptionsTabTitle = (_arg_1.currentTarget as OptionsTabTitle);
        Parameters.data_.lastTab = _local_2.text_;
        this.setSelected(_local_2);
    }

    private function setSelected(_arg_1:OptionsTabTitle):void {
        if (_arg_1 == this.selected_) {
            return;
        }
        if (this.selected_ != null) {
            this.selected_.setSelected(false);
        }
        this.selected_ = _arg_1;
        this.selected_.setSelected(true);
        this.removeOptions();
        switch (this.selected_.text_) {
            case "DBKeys":
                this.addDbKeyOpt();
                return;
            case "Visual 2":
                this.addVisualTwoOpt();
                return;
        }
    }


    private function addVisualTwoOpt():void {
    }

    private function addDbKeyOpt():void {
        this.addOptionAndPosition(new KeyMapper("kdbArmorBroken", "Armor Broken", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbPre1", Parameters.data_.dbPre1[0], (("EffectId: " + Parameters.data_.dbPre1[1]) + "\\nUse /eff 1 <effect id> <name> to change this preset.")), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbBleeding", "Bleeding", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbPre2", Parameters.data_.dbPre2[0], (("EffectId: " + Parameters.data_.dbPre2[1]) + "\\nUse /eff 2 <effect id> <name> to change this preset.")), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbDazed", "Dazed", "Toggles the effect"), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbPre3", Parameters.data_.dbPre3[0], (("EffectId: " + Parameters.data_.dbPre3[1]) + "\\nUse /eff 3 <effect id> <name> to change this preset.")), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbParalyzed", "Paralyzed", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new KeyMapper("kdbSick", "Sick", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new KeyMapper("kdbSlowed", "Slowed", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new KeyMapper("kdbStunned", "Stunned", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new KeyMapper("kdbWeak", "Weak", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new KeyMapper("kdbQuiet", "Quiet", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbAll", "All", "Toggles all effects that can disconnect you."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbPetStasis", "Pet Stasis", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbPetrify", "Petrify", "Toggles the effect."), 0, 0, true);
        this.addOptionAndPosition(new KeyMapper("kdbSilenced", "Silenced", "Toggles the effect."), 0, 0, true);
    }

    private function onAddedToStage(_arg_1:Event):void {
        this.continueButton_.x = 400;
        this.continueButton_.y = Y_POSITION;
        this.resetToDefaultsButton_.x = 20;
        this.resetToDefaultsButton_.y = Y_POSITION;
        this.homeButton_.x = 780;
        this.homeButton_.y = Y_POSITION;
        this.backButton.x = 225;
        this.backButton.y = Y_POSITION;
        this.setSelected(this.defaultTab_);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, 1);
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 1);
    }

    private function onBackClick(_arg_1:MouseEvent):void {
        this.close();
        this.layers.overlay.addChild(new Options(this.gs_));
    }


    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (Capabilities.playerType == "Desktop" && _arg_1.keyCode == KeyCodes.ESCAPE) {
            Parameters.data_.fullscreenMode = false;
            Parameters.save();
            this.refresh();
        }
        if (_arg_1.keyCode == Parameters.data_.options) {
            this.close();
        }
        _arg_1.stopImmediatePropagation();
    }

    private function close():void {
        stage.focus = null;
        parent.removeChild(this);
        if (Parameters.needToRecalcDesireables) {
            Parameters.setAutolootDesireables();
            Parameters.needToRecalcDesireables = false;
        }
    }

    private function onKeyUp(_arg_1:KeyboardEvent):void {
        _arg_1.stopImmediatePropagation();
    }

    private function removeOptions():void {
        var _local_1:Sprite;
        for each (_local_1 in this.options_) {
            removeChild(_local_1);
        }
        this.options_.length = 0;
    }

    private function addOptionAndPosition(option:Option, offsetX:Number = 0, offsetY:Number = 0, smaller:Boolean = false):void {
        var positionOption:Function;
        positionOption = function ():void {
            option.x = ((((options_.length % 2) == 0) ? 20 : 415) + offsetX);
            option.y = (((int((options_.length / 2)) * ((smaller) ? 34 : 44)) + ((smaller) ? 109 : 122)) + offsetY);
        };
        option.textChanged.addOnce(positionOption);
        this.addOption(option);
    }

    private function addOption(_arg_1:Option):void {
        addChild(_arg_1);
        _arg_1.addEventListener(Event.CHANGE, this.onChange);
        this.options_.push(_arg_1);
    }

    private function onChange(_arg_1:Event):void {
        this.refresh();
    }

    private function refresh():void {
        var _local_2:BaseOption;
        var _local_1:int;
        while (_local_1 < this.options_.length) {
            _local_2 = (this.options_[_local_1] as BaseOption);
            if (_local_2 != null) {
                _local_2.refresh();
            }
            _local_1++;
        }
    }


}
}//package com.company.assembleegameclient.ui.options

