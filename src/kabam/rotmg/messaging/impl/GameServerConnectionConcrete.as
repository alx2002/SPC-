﻿﻿﻿//kabam.rotmg.messaging.impl.GameServerConnectionConcrete

package kabam.rotmg.messaging.impl {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.events.GuildResultEvent;
import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
import com.company.assembleegameclient.game.events.NameResultEvent;
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.FlashDescription;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Merchant;
import com.company.assembleegameclient.objects.NameChanger;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Pet;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.objects.Projectile;

import kabam.lib.net.impl.ChatSocketServer;
import kabam.lib.net.impl.ChatSocketServerModel;
import kabam.rotmg.messaging.impl.incoming.ChatToken;
import kabam.rotmg.messaging.impl.outgoing.ChatHello;
import kabam.rotmg.ui.signals.RealmHeroesSignal;
import kabam.rotmg.ui.signals.RealmQuestLevelSignal;
import kabam.rotmg.messaging.impl.incoming.RealmHeroesResponse;
import com.company.assembleegameclient.objects.ProjectileProperties;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.objects.particles.AOEEffect;
import com.company.assembleegameclient.objects.particles.BurstEffect;
import com.company.assembleegameclient.objects.particles.CollapseEffect;
import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
import com.company.assembleegameclient.objects.particles.FlowEffect;
import com.company.assembleegameclient.objects.particles.HealEffect;
import com.company.assembleegameclient.objects.particles.LightningEffect;
import com.company.assembleegameclient.objects.particles.LineEffect;
import com.company.assembleegameclient.objects.particles.NovaEffect;
import com.company.assembleegameclient.objects.particles.ParticleEffect;
import com.company.assembleegameclient.objects.particles.PoisonEffect;
import com.company.assembleegameclient.objects.particles.RingEffect;
import com.company.assembleegameclient.objects.particles.RisingFuryEffect;
import com.company.assembleegameclient.objects.particles.ShockeeEffect;
import com.company.assembleegameclient.objects.particles.ShockerEffect;
import com.company.assembleegameclient.objects.particles.StreamEffect;
import com.company.assembleegameclient.objects.particles.TeleportEffect;
import com.company.assembleegameclient.objects.particles.ThrowEffect;
import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.PicView;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.AssetLoader;
import com.company.assembleegameclient.util.ConditionEffect;
import com.company.assembleegameclient.util.Currency;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.util.MoreStringUtil;
import com.company.util.PointUtil;
import com.company.util.Random;
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.util.Base64;
import com.hurlant.util.der.PEM;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
import io.decagames.rotmg.classes.NewClassUnlockSignal;
import io.decagames.rotmg.dailyQuests.messages.incoming.QuestFetchResponse;
import io.decagames.rotmg.dailyQuests.signal.QuestFetchCompleteSignal;
import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.pets.data.vo.HatchPetVO;
import io.decagames.rotmg.pets.signals.DeletePetSignal;
import io.decagames.rotmg.pets.signals.HatchPetSignal;
import io.decagames.rotmg.pets.signals.NewAbilitySignal;
import io.decagames.rotmg.pets.signals.PetFeedResultSignal;
import io.decagames.rotmg.pets.signals.UpdateActivePet;
import io.decagames.rotmg.pets.signals.UpdatePetYardSignal;
import io.decagames.rotmg.social.model.SocialModel;
import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;

import kabam.lib.net.api.MessageMap;
import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.Message;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.PurchaseConfirmationDialog;
import kabam.rotmg.arena.control.ArenaDeathSignal;
import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
import kabam.rotmg.arena.model.CurrentArenaRunModel;
import kabam.rotmg.arena.view.BattleSummaryDialog;
import kabam.rotmg.arena.view.ContinueOrQuitDialog;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
import kabam.rotmg.dailyLogin.message.ClaimDailyRewardResponse;
import kabam.rotmg.dailyLogin.signal.ClaimDailyRewardResponseSignal;
import kabam.rotmg.death.control.HandleDeathSignal;
import kabam.rotmg.death.control.ZombifySignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.focus.control.SetGameFocusSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
import kabam.rotmg.maploading.signals.ChangeMapSignal;
import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
import kabam.rotmg.messaging.impl.data.GroundTileData;
import kabam.rotmg.messaging.impl.data.ObjectData;
import kabam.rotmg.messaging.impl.data.ObjectStatusData;
import kabam.rotmg.messaging.impl.data.SlotObjectData;
import kabam.rotmg.messaging.impl.data.StatData;
import kabam.rotmg.messaging.impl.incoming.AccountList;
import kabam.rotmg.messaging.impl.incoming.AllyShoot;
import kabam.rotmg.messaging.impl.incoming.Aoe;
import kabam.rotmg.messaging.impl.incoming.BuyResult;
import kabam.rotmg.messaging.impl.incoming.ClientStat;
import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
import kabam.rotmg.messaging.impl.incoming.Damage;
import kabam.rotmg.messaging.impl.incoming.Death;
import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
import kabam.rotmg.messaging.impl.incoming.EvolvedMessageHandler;
import kabam.rotmg.messaging.impl.incoming.EvolvedPetMessage;
import kabam.rotmg.messaging.impl.incoming.Failure;
import kabam.rotmg.messaging.impl.incoming.File;
import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
import kabam.rotmg.messaging.impl.incoming.Goto;
import kabam.rotmg.messaging.impl.incoming.GuildResult;
import kabam.rotmg.messaging.impl.incoming.InvResult;
import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
import kabam.rotmg.messaging.impl.incoming.MapInfo;
import kabam.rotmg.messaging.impl.incoming.NameResult;
import kabam.rotmg.messaging.impl.incoming.NewAbilityMessage;
import kabam.rotmg.messaging.impl.incoming.NewTick;
import kabam.rotmg.messaging.impl.incoming.Notification;
import kabam.rotmg.messaging.impl.incoming.PasswordPrompt;
import kabam.rotmg.messaging.impl.incoming.Pic;
import kabam.rotmg.messaging.impl.incoming.Ping;
import kabam.rotmg.messaging.impl.incoming.PlaySound;
import kabam.rotmg.messaging.impl.incoming.QuestObjId;
import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
import kabam.rotmg.messaging.impl.incoming.Reconnect;
import kabam.rotmg.messaging.impl.incoming.ReskinUnlock;
import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
import kabam.rotmg.messaging.impl.incoming.ShowEffect;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeDone;
import kabam.rotmg.messaging.impl.incoming.TradeRequested;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.messaging.impl.incoming.Update;
import kabam.rotmg.messaging.impl.incoming.VerifyEmail;
import kabam.rotmg.messaging.impl.incoming.arena.ArenaDeath;
import kabam.rotmg.messaging.impl.incoming.arena.ImminentArenaWave;
import kabam.rotmg.messaging.impl.incoming.pets.DeletePetMessage;
import kabam.rotmg.messaging.impl.incoming.pets.HatchPetMessage;
import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
import kabam.rotmg.messaging.impl.outgoing.AoeAck;
import kabam.rotmg.messaging.impl.outgoing.Buy;
import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
import kabam.rotmg.messaging.impl.outgoing.ChangePetSkin;
import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
import kabam.rotmg.messaging.impl.outgoing.CheckCredits;
import kabam.rotmg.messaging.impl.outgoing.ChooseName;
import kabam.rotmg.messaging.impl.outgoing.Create;
import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
import kabam.rotmg.messaging.impl.outgoing.Escape;
import kabam.rotmg.messaging.impl.outgoing.GoToQuestRoom;
import kabam.rotmg.messaging.impl.outgoing.GotoAck;
import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
import kabam.rotmg.messaging.impl.outgoing.Hello;
import kabam.rotmg.messaging.impl.outgoing.InvDrop;
import kabam.rotmg.messaging.impl.outgoing.InvSwap;
import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
import kabam.rotmg.messaging.impl.outgoing.KeyInfoRequest;
import kabam.rotmg.messaging.impl.outgoing.Load;
import kabam.rotmg.messaging.impl.outgoing.Move;
import kabam.rotmg.messaging.impl.outgoing.OtherHit;
import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
import kabam.rotmg.messaging.impl.outgoing.PlayerText;
import kabam.rotmg.messaging.impl.outgoing.Pong;
import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
import kabam.rotmg.messaging.impl.outgoing.Reskin;
import kabam.rotmg.messaging.impl.outgoing.SetCondition;
import kabam.rotmg.messaging.impl.outgoing.ShootAck;
import kabam.rotmg.messaging.impl.outgoing.SquareHit;
import kabam.rotmg.messaging.impl.outgoing.Teleport;
import kabam.rotmg.messaging.impl.outgoing.UseItem;
import kabam.rotmg.messaging.impl.outgoing.UsePortal;
import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
import kabam.rotmg.messaging.impl.outgoing.arena.QuestRedeem;
import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
import kabam.rotmg.minimap.model.UpdateGroundTileVO;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.model.Key;
import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
import kabam.rotmg.ui.signals.ShowKeySignal;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
import kabam.rotmg.ui.view.NotEnoughGoldDialog;
import kabam.rotmg.ui.view.TitleView;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.ILogger;

public class GameServerConnectionConcrete extends GameServerConnection {

    private static const TO_MILLISECONDS:int = 1000;
    private static const MAX_RECONNECT_ATTEMPTS:int = 5;

    private var petUpdater:PetUpdater;
    private var messages:MessageProvider;
    private var player:Player;
    private var retryConnection_:Boolean = true;
    private var rand_:Random = null;
    private var giftChestUpdateSignal:GiftStatusUpdateSignal;
    private var death:Death;
    private var retryTimer_:Timer;
    private var delayBeforeReconnect:int = 2;
    private var addTextLine:AddTextLineSignal;
    private var addSpeechBalloon:AddSpeechBalloonSignal;
    private var updateGroundTileSignal:UpdateGroundTileSignal;
    private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
    private var logger:ILogger;
    private var handleDeath:HandleDeathSignal;
    private var zombify:ZombifySignal;
    private var setGameFocus:SetGameFocusSignal;
    private var updateBackpackTab:UpdateBackpackTabSignal;
    private var petFeedResult:PetFeedResultSignal;
    private var closeDialogs:CloseDialogsSignal;
    private var openDialog:OpenDialogSignal;
    private var arenaDeath:ArenaDeathSignal;
    private var imminentWave:ImminentArenaWaveSignal;
    private var questFetchComplete:QuestFetchCompleteSignal;
    private var questRedeemComplete:QuestRedeemCompleteSignal;
    private var keyInfoResponse:KeyInfoResponseSignal;
    private var claimDailyRewardResponse:ClaimDailyRewardResponseSignal;
    private var newClassUnlockSignal:NewClassUnlockSignal;
    private var currentArenaRun:CurrentArenaRunModel;
    private var classesModel:ClassesModel;
    private var injector:Injector;
    private var model:GameModel;
    private var updateActivePet:UpdateActivePet;
    private var petsModel:PetsModel;
    private var socialModel:SocialModel;
    private var statsTracker:CharactersMetricsTracker;
    private var chatServerConnection:ChatSocketServer;
    private var chatServerModel:ChatSocketServerModel;
    private var _isReconnecting:Boolean;
    private var _numberOfReconnectAttempts:int;
    private var _chatReconnectionTimer:Timer;

    private var realmHeroesSignal:RealmHeroesSignal;
    private var realmQuestLevelSignal:RealmQuestLevelSignal;
    public function GameServerConnectionConcrete(_arg_1:AGameSprite, _arg_2:Server, _arg_3:int, _arg_4:Boolean, _arg_5:int, _arg_6:int, _arg_7:ByteArray, _arg_8:String, _arg_9:Boolean) {
        this.injector = StaticInjectorContext.getInjector();
        this.giftChestUpdateSignal = this.injector.getInstance(GiftStatusUpdateSignal);
        this.addTextLine = this.injector.getInstance(AddTextLineSignal);
        this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
        this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
        this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
        this.petFeedResult = this.injector.getInstance(PetFeedResultSignal);
        this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
        this.updateActivePet = this.injector.getInstance(UpdateActivePet);
        this.petsModel = this.injector.getInstance(PetsModel);
        this.socialModel = this.injector.getInstance(SocialModel);
        this.closeDialogs = this.injector.getInstance(CloseDialogsSignal);
        changeMapSignal = this.injector.getInstance(ChangeMapSignal);
        this.openDialog = this.injector.getInstance(OpenDialogSignal);
        this.arenaDeath = this.injector.getInstance(ArenaDeathSignal);
        this.imminentWave = this.injector.getInstance(ImminentArenaWaveSignal);
        this.questFetchComplete = this.injector.getInstance(QuestFetchCompleteSignal);
        this.questRedeemComplete = this.injector.getInstance(QuestRedeemCompleteSignal);
        this.keyInfoResponse = this.injector.getInstance(KeyInfoResponseSignal);
        this.claimDailyRewardResponse = this.injector.getInstance(ClaimDailyRewardResponseSignal);
        this.newClassUnlockSignal = this.injector.getInstance(NewClassUnlockSignal);
        this.realmHeroesSignal = this.injector.getInstance(RealmHeroesSignal);
        this.realmQuestLevelSignal = this.injector.getInstance(RealmQuestLevelSignal);
        this.statsTracker = this.injector.getInstance(CharactersMetricsTracker);
        this.logger = this.injector.getInstance(ILogger);
        this.handleDeath = this.injector.getInstance(HandleDeathSignal);
        this.zombify = this.injector.getInstance(ZombifySignal);
        this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
        this.classesModel = this.injector.getInstance(ClassesModel);
        serverConnection = this.injector.getInstance(SocketServer);
        this.chatServerConnection = this.injector.getInstance(ChatSocketServer);
        this.chatServerModel = this.injector.getInstance(ChatSocketServerModel);
        this.messages = this.injector.getInstance(MessageProvider);
        this.model = this.injector.getInstance(GameModel);
        this.currentArenaRun = this.injector.getInstance(CurrentArenaRunModel);
        gs_ = _arg_1;
        server_ = _arg_2;
        gameId_ = _arg_3;
        createCharacter_ = _arg_4;
        charId_ = _arg_5;
        keyTime_ = _arg_6;
        key_ = _arg_7;
        mapJSON_ = _arg_8;
        isFromArena_ = _arg_9;
        this.socialModel.loadInvitations();
        this.socialModel.setCurrentServer(server_);
        this.getPetUpdater();
        instance = this;
    }

    private static function isStatPotion(_arg_1:int):Boolean {
        return (((((((((((_arg_1 == 2591) || (_arg_1 == 5465)) || (_arg_1 == 9064)) || (((_arg_1 == 2592) || (_arg_1 == 5466)) || (_arg_1 == 9065))) || (((_arg_1 == 2593) || (_arg_1 == 5467)) || (_arg_1 == 9066))) || (((_arg_1 == 2612) || (_arg_1 == 5468)) || (_arg_1 == 9067))) || (((_arg_1 == 2613) || (_arg_1 == 5469)) || (_arg_1 == 9068))) || (((_arg_1 == 2636) || (_arg_1 == 5470)) || (_arg_1 == 9069))) || (((_arg_1 == 2793) || (_arg_1 == 5471)) || (_arg_1 == 9070))) || (((_arg_1 == 2794) || (_arg_1 == 5472)) || (_arg_1 == 9071))) || ((((((((_arg_1 == 9724) || (_arg_1 == 9725)) || (_arg_1 == 9726)) || (_arg_1 == 9727)) || (_arg_1 == 0x2600)) || (_arg_1 == 9729)) || (_arg_1 == 9730)) || (_arg_1 == 9731)));
    }


    private function getPetUpdater():void {
        this.injector.map(AGameSprite).toValue(gs_);
        this.petUpdater = this.injector.getInstance(PetUpdater);
        this.injector.unmap(AGameSprite);
    }

    override public function disconnect():void
    {
        this.removeServerConnectionListeners();
        this.unmapMessages();
        serverConnection.disconnect();
        player.close();
    }

    private function removeServerConnectionListeners():void {
        serverConnection.connected.remove(this.onConnected);
        serverConnection.closed.remove(this.onClosed);
        serverConnection.error.remove(this.onError);
    }

    override public function connect():void {
        this.addServerConnectionListeners();
        this.mapMessages();
        var _local_1:ChatMessage = new ChatMessage();
        _local_1.name = Parameters.CLIENT_CHAT_NAME;
        _local_1.text = TextKey.CHAT_CONNECTING_TO;
        var _local_2:String = server_.name;
        if (_local_2 == '{"text":"server.vault"}') {
            _local_2 = "server.vault";
        }
        _local_2 = LineBuilder.getLocalizedStringFromKey(_local_2);
        _local_1.tokens = {"serverName": _local_2};
        this.addTextLine.dispatch(_local_1);
        serverConnection.connect(server_.address, server_.port);
    }

    public function addServerConnectionListeners():void {
        serverConnection.connected.add(this.onConnected);
        serverConnection.closed.add(this.onClosed);
        serverConnection.error.add(this.onError);
    }

    public function mapMessages():void {
        var msgMap:MessageMap = this.injector.getInstance(MessageMap);
        msgMap.map(CREATE).toMessage(Create);
        msgMap.map(PLAYERSHOOT).toMessage(PlayerShoot);
        msgMap.map(MOVE).toMessage(Move);
        msgMap.map(PLAYERTEXT).toMessage(PlayerText);
        msgMap.map(UPDATEACK).toMessage(Message);
        msgMap.map(INVSWAP).toMessage(InvSwap);
        msgMap.map(USEITEM).toMessage(UseItem);
        msgMap.map(HELLO).toMessage(Hello);
        msgMap.map(INVDROP).toMessage(InvDrop);
        msgMap.map(PONG).toMessage(Pong);
        msgMap.map(LOAD).toMessage(Load);
        msgMap.map(SETCONDITION).toMessage(SetCondition);
        msgMap.map(TELEPORT).toMessage(Teleport);
        msgMap.map(USEPORTAL).toMessage(UsePortal);
        msgMap.map(BUY).toMessage(Buy);
        msgMap.map(PLAYERHIT).toMessage(PlayerHit);
        msgMap.map(ENEMYHIT).toMessage(EnemyHit);
        msgMap.map(AOEACK).toMessage(AoeAck);
        msgMap.map(SHOOTACK).toMessage(ShootAck);
        msgMap.map(OTHERHIT).toMessage(OtherHit);
        msgMap.map(SQUAREHIT).toMessage(SquareHit);
        msgMap.map(GOTOACK).toMessage(GotoAck);
        msgMap.map(GROUNDDAMAGE).toMessage(GroundDamage);
        msgMap.map(CHOOSENAME).toMessage(ChooseName);
        msgMap.map(CREATEGUILD).toMessage(CreateGuild);
        msgMap.map(GUILDREMOVE).toMessage(GuildRemove);
        msgMap.map(GUILDINVITE).toMessage(GuildInvite);
        msgMap.map(REQUESTTRADE).toMessage(RequestTrade);
        msgMap.map(CHANGETRADE).toMessage(ChangeTrade);
        msgMap.map(ACCEPTTRADE).toMessage(AcceptTrade);
        msgMap.map(CANCELTRADE).toMessage(CancelTrade);
        msgMap.map(CHECKCREDITS).toMessage(CheckCredits);
        msgMap.map(ESCAPE).toMessage(Escape);
        msgMap.map(QUESTROOMMSG).toMessage(GoToQuestRoom);
        msgMap.map(JOINGUILD).toMessage(JoinGuild);
        msgMap.map(CHANGEGUILDRANK).toMessage(ChangeGuildRank);
        msgMap.map(EDITACCOUNTLIST).toMessage(EditAccountList);
        msgMap.map(ACTIVEPETUPDATEREQUEST).toMessage(ActivePetUpdateRequest);
        msgMap.map(PETUPGRADEREQUEST).toMessage(PetUpgradeRequest);
        msgMap.map(ENTERARENA).toMessage(EnterArena);
        msgMap.map(ACCEPTARENADEATH).toMessage(OutgoingMessage);
        msgMap.map(QUESTFETCHASK).toMessage(OutgoingMessage);
        msgMap.map(QUESTREDEEM).toMessage(QuestRedeem);
        msgMap.map(KEYINFOREQUEST).toMessage(KeyInfoRequest);
        msgMap.map(PETCHANGEFORMMSG).toMessage(ReskinPet);
        msgMap.map(CLAIMLOGINREWARDMSG).toMessage(ClaimDailyRewardMessage);
        msgMap.map(PETCHANGESKINMSG).toMessage(ChangePetSkin);
        msgMap.map(FAILURE).toMessage(Failure).toMethod(this.onFailure);
        msgMap.map(CREATESUCCESS).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
        msgMap.map(SERVERPLAYERSHOOT).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
        msgMap.map(DAMAGE).toMessage(Damage).toMethod(this.onDamage);
        msgMap.map(UPDATE).toMessage(Update).toMethod(this.onUpdate);
        msgMap.map(NOTIFICATION).toMessage(Notification).toMethod(this.onNotification);
        msgMap.map(GLOBALNOTIFICATION).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
        msgMap.map(NEWTICK).toMessage(NewTick).toMethod(this.onNewTick);
        msgMap.map(SHOWEFFECT).toMessage(ShowEffect).toMethod(this.onShowEffect);
        msgMap.map(GOTO).toMessage(Goto).toMethod(this.onGoto);
        msgMap.map(INVRESULT).toMessage(InvResult).toMethod(this.onInvResult);
        msgMap.map(RECONNECT).toMessage(Reconnect).toMethod(this.onReconnect);
        msgMap.map(PING).toMessage(Ping).toMethod(this.onPing);
        msgMap.map(MAPINFO).toMessage(MapInfo).toMethod(this.onMapInfo);
        msgMap.map(PIC).toMessage(Pic).toMethod(this.onPic);
        msgMap.map(DEATH).toMessage(Death).toMethod(this.onDeath);
        msgMap.map(BUYRESULT).toMessage(BuyResult).toMethod(this.onBuyResult);
        msgMap.map(AOE).toMessage(Aoe).toMethod(this.onAoe);
        msgMap.map(ACCOUNTLIST).toMessage(AccountList).toMethod(this.onAccountList);
        msgMap.map(QUESTOBJID).toMessage(QuestObjId).toMethod(this.onQuestObjId);
        msgMap.map(NAMERESULT).toMessage(NameResult).toMethod(this.onNameResult);
        msgMap.map(GUILDRESULT).toMessage(GuildResult).toMethod(this.onGuildResult);
        msgMap.map(ALLYSHOOT).toMessage(AllyShoot).toMethod(this.onAllyShoot);
        msgMap.map(ENEMYSHOOT).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
        msgMap.map(TRADEREQUESTED).toMessage(TradeRequested).toMethod(this.onTradeRequested);
        msgMap.map(TRADESTART).toMessage(TradeStart).toMethod(this.onTradeStart);
        msgMap.map(TRADECHANGED).toMessage(TradeChanged).toMethod(this.onTradeChanged);
        msgMap.map(TRADEDONE).toMessage(TradeDone).toMethod(this.onTradeDone);
        msgMap.map(TRADEACCEPTED).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
        msgMap.map(CLIENTSTAT).toMessage(ClientStat).toMethod(this.onClientStat);
        msgMap.map(FILE).toMessage(File).toMethod(this.onFile);
        msgMap.map(INVITEDTOGUILD).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
        msgMap.map(PLAYSOUND).toMessage(PlaySound).toMethod(this.onPlaySound);
        msgMap.map(ACTIVEPETUPDATE).toMessage(ActivePet).toMethod(this.onActivePetUpdate);
        msgMap.map(NEWABILITY).toMessage(NewAbilityMessage).toMethod(this.onNewAbility);
        msgMap.map(PETYARDUPDATE).toMessage(PetYard).toMethod(this.onPetYardUpdate);
        msgMap.map(EVOLVEPET).toMessage(EvolvedPetMessage).toMethod(this.onEvolvedPet);
        msgMap.map(DELETEPET).toMessage(DeletePetMessage).toMethod(this.onDeletePet);
        msgMap.map(HATCHPET).toMessage(HatchPetMessage).toMethod(this.onHatchPet);
        msgMap.map(IMMINENTARENAWAVE).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
        msgMap.map(ARENADEATH).toMessage(ArenaDeath).toMethod(this.onArenaDeath);
        msgMap.map(VERIFYEMAIL).toMessage(VerifyEmail).toMethod(this.onVerifyEmail);
        msgMap.map(RESKINUNLOCK).toMessage(ReskinUnlock).toMethod(this.onReskinUnlock);
        msgMap.map(PASSWORDPROMPT).toMessage(PasswordPrompt).toMethod(this.onPasswordPrompt);
        msgMap.map(QUESTFETCHRESPONSE).toMessage(QuestFetchResponse).toMethod(this.onQuestFetchResponse);
        msgMap.map(QUESTREDEEMRESPONSE).toMessage(QuestRedeemResponse).toMethod(this.onQuestRedeemResponse);
        msgMap.map(KEYINFORESPONSE).toMessage(KeyInfoResponse).toMethod(this.onKeyInfoResponse);
        msgMap.map(LOGINREWARDMSG).toMessage(ClaimDailyRewardResponse).toMethod(this.onLoginRewardResponse);
        msgMap.map(REALMHEROLEFTMSG).toMessage(RealmHeroesResponse).toMethod(this.onRealmHeroesResponse);
        msgMap.map(CHATTOKENMSG).toMessage(ChatToken).toMethod(this.onChatToken);
    }

    private function onHatchPet(_arg_1:HatchPetMessage):void {
        var _local_2:HatchPetSignal = this.injector.getInstance(HatchPetSignal);
        var _local_3:HatchPetVO = new HatchPetVO();
        _local_3.itemType = _arg_1.itemType;
        _local_3.petSkin = _arg_1.petSkin;
        _local_3.petName = _arg_1.petName;
        _local_2.dispatch(_local_3);
    }

    private function onDeletePet(_arg_1:DeletePetMessage):void {
        var _local_2:DeletePetSignal = this.injector.getInstance(DeletePetSignal);
        this.injector.getInstance(PetsModel).deletePet(_arg_1.petID);
        _local_2.dispatch(_arg_1.petID);
    }

    private function onNewAbility(_arg_1:NewAbilityMessage):void {
        var _local_2:NewAbilitySignal = this.injector.getInstance(NewAbilitySignal);
        _local_2.dispatch(_arg_1.type);
    }

    private function onPetYardUpdate(_arg_1:PetYard):void {
        var _local_2:UpdatePetYardSignal = StaticInjectorContext.getInjector().getInstance(UpdatePetYardSignal);
        _local_2.dispatch(_arg_1.type);
    }

    private function onEvolvedPet(_arg_1:EvolvedPetMessage):void {
        var _local_2:EvolvedMessageHandler = this.injector.getInstance(EvolvedMessageHandler);
        _local_2.handleMessage(_arg_1);
    }

    private function onActivePetUpdate(_arg_1:ActivePet):void {
        this.updateActivePet.dispatch(_arg_1.instanceID);
        var _local_2:String = ((_arg_1.instanceID > 0) ? this.petsModel.getPet(_arg_1.instanceID).name : "");
        var _local_3:String = ((_arg_1.instanceID < 0) ? TextKey.PET_NOT_FOLLOWING : TextKey.PET_FOLLOWING);
        this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _local_3, -1, -1, "", false, {"petName": _local_2}));
    }

    private function unmapMessages():void {
        var msgMap:MessageMap = this.injector.getInstance(MessageMap);
        msgMap.unmap(CREATE);
        msgMap.unmap(PLAYERSHOOT);
        msgMap.unmap(MOVE);
        msgMap.unmap(PLAYERTEXT);
        msgMap.unmap(UPDATEACK);
        msgMap.unmap(INVSWAP);
        msgMap.unmap(USEITEM);
        msgMap.unmap(HELLO);
        msgMap.unmap(INVDROP);
        msgMap.unmap(PONG);
        msgMap.unmap(LOAD);
        msgMap.unmap(SETCONDITION);
        msgMap.unmap(TELEPORT);
        msgMap.unmap(USEPORTAL);
        msgMap.unmap(BUY);
        msgMap.unmap(PLAYERHIT);
        msgMap.unmap(ENEMYHIT);
        msgMap.unmap(AOEACK);
        msgMap.unmap(SHOOTACK);
        msgMap.unmap(OTHERHIT);
        msgMap.unmap(SQUAREHIT);
        msgMap.unmap(GOTOACK);
        msgMap.unmap(GROUNDDAMAGE);
        msgMap.unmap(CHOOSENAME);
        msgMap.unmap(CREATEGUILD);
        msgMap.unmap(GUILDREMOVE);
        msgMap.unmap(GUILDINVITE);
        msgMap.unmap(REQUESTTRADE);
        msgMap.unmap(CHANGETRADE);
        msgMap.unmap(ACCEPTTRADE);
        msgMap.unmap(CANCELTRADE);
        msgMap.unmap(CHECKCREDITS);
        msgMap.unmap(ESCAPE);
        msgMap.unmap(QUESTROOMMSG);
        msgMap.unmap(JOINGUILD);
        msgMap.unmap(CHANGEGUILDRANK);
        msgMap.unmap(EDITACCOUNTLIST);
        msgMap.unmap(FAILURE);
        msgMap.unmap(CREATESUCCESS);
        msgMap.unmap(SERVERPLAYERSHOOT);
        msgMap.unmap(DAMAGE);
        msgMap.unmap(UPDATE);
        msgMap.unmap(NOTIFICATION);
        msgMap.unmap(GLOBALNOTIFICATION);
        msgMap.unmap(NEWTICK);
        msgMap.unmap(SHOWEFFECT);
        msgMap.unmap(GOTO);
        msgMap.unmap(INVRESULT);
        msgMap.unmap(RECONNECT);
        msgMap.unmap(PING);
        msgMap.unmap(MAPINFO);
        msgMap.unmap(PIC);
        msgMap.unmap(DEATH);
        msgMap.unmap(BUYRESULT);
        msgMap.unmap(AOE);
        msgMap.unmap(ACCOUNTLIST);
        msgMap.unmap(QUESTOBJID);
        msgMap.unmap(NAMERESULT);
        msgMap.unmap(GUILDRESULT);
        msgMap.unmap(ALLYSHOOT);
        msgMap.unmap(ENEMYSHOOT);
        msgMap.unmap(TRADEREQUESTED);
        msgMap.unmap(TRADESTART);
        msgMap.unmap(TRADECHANGED);
        msgMap.unmap(TRADEDONE);
        msgMap.unmap(TRADEACCEPTED);
        msgMap.unmap(CLIENTSTAT);
        msgMap.unmap(FILE);
        msgMap.unmap(INVITEDTOGUILD);
        msgMap.unmap(PLAYSOUND);
        msgMap.unmap(CHATTOKENMSG);
        msgMap.unmap(REALMHEROLEFTMSG);
    }

    private function encryptConnection():void {
        var _local_1:ICipher = Crypto.getCipher("rc4", MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(0, 26)));
        var _local_2:ICipher = Crypto.getCipher("rc4", MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(26)));
        serverConnection.setOutgoingCipher(_local_1);
        serverConnection.setIncomingCipher(_local_2);
    }

    override public function getNextDamage(_arg_1:uint, _arg_2:uint):uint {
        return (this.rand_.nextIntRange(_arg_1, _arg_2));
    }

    override public function enableJitterWatcher():void {
        if (jitterWatcher_ == null) {
            jitterWatcher_ = new JitterWatcher();
        }
    }

    override public function disableJitterWatcher():void {
        if (jitterWatcher_ != null) {
            jitterWatcher_ = null;
        }
    }

    private function create():void {
        var _local_1:CharacterClass = this.classesModel.getSelected();
        var _local_2:Create = (this.messages.require(CREATE) as Create);
        _local_2.classType = _local_1.id;
        _local_2.skinType = _local_1.skins.getSelectedSkin().id;
        serverConnection.sendMessage(_local_2);
        Parameters.Cache_CHARLIST_valid = false;
        Parameters.lockRecon = true;
    }

    private function load():void {
        var _local_1:Load = (this.messages.require(LOAD) as Load);
        _local_1.charId_ = charId_;
        _local_1.isFromArena_ = isFromArena_;
        serverConnection.sendMessage(_local_1);
        if (isFromArena_) {
            this.openDialog.dispatch(new BattleSummaryDialog());
        }
        Parameters.lockRecon = true;
    }

    override public function playerShoot(_arg_1:int, _arg_2:Projectile):void {
        var _local_3:PlayerShoot = (this.messages.require(PLAYERSHOOT) as PlayerShoot);
        _local_3.time_ = _arg_1;
        _local_3.bulletId_ = _arg_2.bulletId_;
        _local_3.containerType_ = _arg_2.containerType_;
        _local_3.startingPos_.x_ = _arg_2.x_;
        _local_3.startingPos_.y_ = _arg_2.y_;
        _local_3.angle_ = _arg_2.angle_;
        serverConnection.sendMessage(_local_3);
    }

    override public function playerHit(_arg_1:int, _arg_2:int):void {
        var _local_3:PlayerHit = (this.messages.require(PLAYERHIT) as PlayerHit);
        _local_3.bulletId_ = _arg_1;
        _local_3.objectId_ = _arg_2;
        serverConnection.sendMessage(_local_3);
    }

    override public function enemyHit(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean):void {
        var _local_5:EnemyHit = (this.messages.require(ENEMYHIT) as EnemyHit);
        _local_5.time_ = _arg_1;
        _local_5.bulletId_ = _arg_2;
        _local_5.targetId_ = _arg_3;
        _local_5.kill_ = _arg_4;
        serverConnection.sendMessage(_local_5);
    }

    override public function otherHit(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void {
        var _local_5:OtherHit = (this.messages.require(OTHERHIT) as OtherHit);
        _local_5.time_ = _arg_1;
        _local_5.bulletId_ = _arg_2;
        _local_5.objectId_ = _arg_3;
        _local_5.targetId_ = _arg_4;
        serverConnection.sendMessage(_local_5);
    }

    override public function squareHit(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local_4:SquareHit = (this.messages.require(SQUAREHIT) as SquareHit);
        _local_4.time_ = _arg_1;
        _local_4.bulletId_ = _arg_2;
        _local_4.objectId_ = _arg_3;
        serverConnection.sendMessage(_local_4);
    }

    public function aoeAck(_arg_1:int, _arg_2:Number, _arg_3:Number):void {
        var _local_4:AoeAck = (this.messages.require(AOEACK) as AoeAck);
        _local_4.time_ = _arg_1;
        _local_4.position_.x_ = _arg_2;
        _local_4.position_.y_ = _arg_3;
        serverConnection.sendMessage(_local_4);
    }

    override public function groundDamage(_arg_1:int, _arg_2:Number, _arg_3:Number):void {
        var _local_4:GroundDamage = (this.messages.require(GROUNDDAMAGE) as GroundDamage);
        _local_4.time_ = _arg_1;
        _local_4.position_.x_ = _arg_2;
        _local_4.position_.y_ = _arg_3;
        serverConnection.sendMessage(_local_4);
    }

    public function shootAck(_arg_1:int):void {
        var _local_2:ShootAck = (this.messages.require(SHOOTACK) as ShootAck);
        _local_2.time_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function playerText(_arg_1:String):void {
        var _local_2:PlayerText = (this.messages.require(PLAYERTEXT) as PlayerText);
        _local_2.text_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function invSwap(p:Player, obj:GameObject, _arg_3:int, _arg_4:int, obj2:GameObject, _arg_6:int, _arg_7:int):Boolean {
        if (gs_ == null) {
            return (false);
        }
        if ((gs_.lastUpdate_ - this.lastInvSwapTime) < 520) {
            return (false);
        }
        var invSwapPacket:InvSwap = (this.messages.require(INVSWAP) as InvSwap);
        invSwapPacket.time_ = gs_.lastUpdate_;
        invSwapPacket.position_.x_ = p.x_;
        invSwapPacket.position_.y_ = p.y_;
        invSwapPacket.slotObject1_.objectId_ = obj.objectId_;
        invSwapPacket.slotObject1_.slotId_ = _arg_3;
        invSwapPacket.slotObject1_.objectType_ = _arg_4;
        invSwapPacket.slotObject2_.objectId_ = obj2.objectId_;
        invSwapPacket.slotObject2_.slotId_ = _arg_6;
        invSwapPacket.slotObject2_.objectType_ = _arg_7;
        serverConnection.sendMessage(invSwapPacket);
        this.lastInvSwapTime = invSwapPacket.time_;
        var _local_9:int = obj.equipment_[_arg_3];
        obj.equipment_[_arg_3] = obj2.equipment_[_arg_6];
        obj2.equipment_[_arg_6] = _local_9;
        SoundEffectLibrary.play("inventory_move_item");
        if (p == this.gs_.map.player_) {
            p.recalcAllEnemyHighestDps();
        }
        return (true);
    }

    override public function invSwapPotion(_arg_1:Player, _arg_2:GameObject, _arg_3:int, _arg_4:int, _arg_5:GameObject, _arg_6:int, _arg_7:int):Boolean {
        if (!gs_) {
            return (false);
        }
        if ((this.gs_.lastUpdate_ - this.lastInvSwapTime) < 520) {
            return (false);
        }
        var invSwapPacket:InvSwap = (this.messages.require(INVSWAP) as InvSwap);
        invSwapPacket.time_ = gs_.lastUpdate_;
        invSwapPacket.position_.x_ = _arg_1.x_;
        invSwapPacket.position_.y_ = _arg_1.y_;
        invSwapPacket.slotObject1_.objectId_ = _arg_2.objectId_;
        invSwapPacket.slotObject1_.slotId_ = _arg_3;
        invSwapPacket.slotObject1_.objectType_ = _arg_4;
        invSwapPacket.slotObject2_.objectId_ = _arg_5.objectId_;
        invSwapPacket.slotObject2_.slotId_ = _arg_6;
        invSwapPacket.slotObject2_.objectType_ = _arg_7;
        _arg_2.equipment_[_arg_3] = ItemConstants.NO_ITEM;
        if (_arg_4 == PotionInventoryModel.HEALTH_POTION_ID) {
            _arg_1.healthPotionCount_++;
        }
        else {
            if (_arg_4 == PotionInventoryModel.MAGIC_POTION_ID) {
                _arg_1.magicPotionCount_++;
            }
        }
        serverConnection.sendMessage(invSwapPacket);
        this.lastInvSwapTime = invSwapPacket.time_;
        SoundEffectLibrary.play("inventory_move_item");
        if (player == this.gs_.map.player_) {
            player.recalcAllEnemyHighestDps();
        }
        return (true);
    }

    override public function invDrop(_arg_1:GameObject, _arg_2:int, _arg_3:int):void {
        var _local_4:InvDrop = (this.messages.require(INVDROP) as InvDrop);
        _local_4.slotObject_.objectId_ = _arg_1.objectId_;
        _local_4.slotObject_.slotId_ = _arg_2;
        _local_4.slotObject_.objectType_ = _arg_3;
        serverConnection.sendMessage(_local_4);
        if (_arg_2 != PotionInventoryModel.HEALTH_POTION_SLOT && _arg_2 != PotionInventoryModel.MAGIC_POTION_SLOT) {
            _arg_1.equipment_[_arg_2] = ItemConstants.NO_ITEM;
        }
        if (player == this.gs_.map.player_) {
            player.recalcAllEnemyHighestDps();
        }
    }

    override public function useItem(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Number, _arg_7:int):void {
        if (Parameters.data_.fameBlockAbility && _arg_2 == this.playerId_ && _arg_3 == 1) {
            this.player.textNotification("Ignored ability use, Mundane enabled", 0xE25F00);
            return;
        }
        if (Parameters.data_.fameBlockThirsty && _arg_2 == this.playerId_ && _arg_3 > 3 && _arg_3 < 254) {
            var _local_9:ObjectProperties = ObjectLibrary.propsLibrary_[this.player.equipment_[_arg_3]];
            if (_local_9 != null && _local_9.isPotion_) {
                this.player.textNotification("Ignored potion use, Thirsty enabled", 0xE25F00);
                return;
            }
        }
        var useItemPacket:UseItem = (this.messages.require(USEITEM) as UseItem);
        useItemPacket.time_ = _arg_1;
        useItemPacket.slotObject_.objectId_ = _arg_2;
        useItemPacket.slotObject_.slotId_ = _arg_3;
        useItemPacket.slotObject_.objectType_ = _arg_4;
        useItemPacket.itemUsePos_.x_ = _arg_5;
        useItemPacket.itemUsePos_.y_ = _arg_6;
        useItemPacket.useType_ = _arg_7;
        serverConnection.sendMessage(useItemPacket);
        if (player == this.gs_.map.player_) {
            player.recalcAllEnemyHighestDps();
        }
    }

    override public function useItem_new(_arg_1:GameObject, _arg_2:int):Boolean {
        var _local_4:XML;
        var _local_3:int = _arg_1.equipment_[_arg_2];
        if (Parameters.data_.fameBlockAbility && _arg_1.objectId_ == this.playerId_ && _arg_2 == 1) {
            this.player.textNotification("Ignored ability use, Mundane enabled", 0xE25F00);
            return (false);
        }
        if (Parameters.data_.fameBlockThirsty && _arg_1.objectId_ == this.playerId_ && _arg_2 > 3 && _arg_2 < 254) {
            var _local_5:ObjectProperties = ObjectLibrary.propsLibrary_[_arg_1.equipment_[_arg_2]];
            if (_local_5 != null && _local_5.isPotion_) {
                this.player.textNotification("Ignored potion use, Thirsty enabled", 0xE25F00);
                return (false);
            }
        }
        if (_arg_1 == null || _arg_1.equipment_ == null) {
            return (false);
        }
        if (((_local_3 >= 0x9000) && (_local_3 < 0xF000))) {
            _local_4 = ObjectLibrary.xmlLibrary_[36863];
        }
        else {
            _local_4 = ObjectLibrary.xmlLibrary_[_local_3];
        }
        if ((_local_4 && !_arg_1.isPaused && _local_4.hasOwnProperty("Consumable")) || _local_4.hasOwnProperty("InvUse")) {
            if (!this.validStatInc(_local_3, _arg_1)) {
                this.addTextLine.dispatch(ChatMessage.make("", (_local_4.attribute("id") + " not consumed. Already at Max.")));
                return (false);
            }
            if (isStatPotion(_local_3)) {
                this.addTextLine.dispatch(ChatMessage.make("", (_local_4.attribute("id") + " Consumed ++")));
            }
            this.applyUseItem(_arg_1, _arg_2, _local_3, _local_4);
            if (_local_4.hasOwnProperty("Key")) {
                SoundEffectLibrary.play("use_key");
            }
            else {
                SoundEffectLibrary.play("use_potion");
            }
            return (true);
        }
        if (this.swapEquip(_arg_1, _arg_2, _local_4)) {
            return (true);
        }
        SoundEffectLibrary.play("error");
        return (false);
    }

    public function swapEquip(_arg_1:GameObject, _arg_2:int, _arg_3:XML):Boolean {
        var type:int;
        var arg:Vector.<int>;
        var counter:int;
        var item:int;
        if ((((_arg_3) && (!(_arg_1.isPaused))) && (_arg_3.hasOwnProperty("SlotType")))) {
            type = int(_arg_3.SlotType);
            arg = _arg_1.slotTypes_.slice(0, 4);
            counter = 0;
            for each (item in arg) {
                if (item == type) {
                    this.swapItems(_arg_1, counter, _arg_2);
                    return (true);
                }
                counter++;
            }
        }
        return (false);
    }

    public function swapItems(_arg_1:GameObject, _arg_2:int, _arg_3:int):void {
        var _local_4:Vector.<int> = _arg_1.equipment_;
        this.invSwap((_arg_1 as Player), _arg_1, _arg_2, _local_4[_arg_2], _arg_1, _arg_3, _local_4[_arg_3]);
    }

    private function validStatInc(itemId:int, itemOwner:GameObject):Boolean {
        var p:Player;
        try {
            if ((itemOwner is Player)) {
                p = (itemOwner as Player);
            }
            else {
                p = this.player;
            }
            if (((((((((((((itemId == 2591) || (itemId == 5465)) || (itemId == 9064)) || (itemId == 9729)) && (p.attackMax_ == (p.attack_ - p.attackBoost_))) || (((((itemId == 2592) || (itemId == 5466)) || (itemId == 9065)) || (itemId == 9727)) && (p.defenseMax_ == (p.defense_ - p.defenseBoost_)))) || (((((itemId == 2593) || (itemId == 5467)) || (itemId == 9066)) || (itemId == 9726)) && (p.speedMax_ == (p.speed_ - p.speedBoost_)))) || (((((itemId == 2612) || (itemId == 5468)) || (itemId == 9067)) || (itemId == 9724)) && (p.vitalityMax_ == (p.vitality_ - p.vitalityBoost_)))) || (((((itemId == 2613) || (itemId == 5469)) || (itemId == 9068)) || (itemId == 9725)) && (p.wisdomMax_ == (p.wisdom_ - p.wisdomBoost_)))) || (((((itemId == 2636) || (itemId == 5470)) || (itemId == 9069)) || (itemId == 0x2600)) && (p.dexterityMax_ == (p.dexterity_ - p.dexterityBoost_)))) || (((((itemId == 2793) || (itemId == 5471)) || (itemId == 9070)) || (itemId == 9731)) && (p.maxHPMax_ == (p.maxHP_ - p.maxHPBoost_)))) || (((((itemId == 2794) || (itemId == 5472)) || (itemId == 9071)) || (itemId == 9730)) && (p.maxMPMax_ == (p.maxMP_ - p.maxMPBoost_))))) {
                return (false);
            }
        }
        catch (err:Error) {
            logger.error("PROBLEM IN STAT INC " + err.getStackTrace());
        }
        return (true);
    }

    private function applyUseItem(_arg_1:GameObject, _arg_2:int, _arg_3:int, _arg_4:XML):void {
        var _local_5:UseItem = (this.messages.require(USEITEM) as UseItem);
        _local_5.time_ = getTimer();
        _local_5.slotObject_.objectId_ = _arg_1.objectId_;
        _local_5.slotObject_.slotId_ = _arg_2;
        _local_5.slotObject_.objectType_ = _arg_3;
        _local_5.itemUsePos_.x_ = 0;
        _local_5.itemUsePos_.y_ = 0;
        serverConnection.sendMessage(_local_5);
        if (_arg_4.hasOwnProperty("Consumable")) {
            _arg_1.equipment_[_arg_2] = -1;
        }
    }

    override public function setCondition(_arg_1:uint, _arg_2:Number):void {
        var _local_3:SetCondition = (this.messages.require(SETCONDITION) as SetCondition);
        _local_3.conditionEffect_ = _arg_1;
        _local_3.conditionDuration_ = _arg_2;
        serverConnection.sendMessage(_local_3);
    }

    public function move(tickId:int, p:Player):void {
        var moveRec:int;
        var counter:int;
        var pX:Number = -1;
        var pY:Number = -1;
        if (((p) && (!(p.isPaused)))) {
            pX = p.x_;
            pY = p.y_;
        }
        var movePacket:Move = (this.messages.require(MOVE) as Move);
        movePacket.tickId_ = tickId;
        movePacket.time_ = gs_.lastUpdate_;
        movePacket.newPosition_.x_ = pX;
        movePacket.newPosition_.y_ = pY;
        var _local_6:int = gs_.moveRecords_.lastClearTime_;
        movePacket.records_.length = 0;
        if (((_local_6 >= 0) && ((movePacket.time_ - _local_6) > 125))) {
            moveRec = Math.min(10, gs_.moveRecords_.records_.length);
            counter = 0;
            while (counter < moveRec) {
                if (gs_.moveRecords_.records_[counter].time_ >= (movePacket.time_ - 25)) break;
                movePacket.records_.push(gs_.moveRecords_.records_[counter]);
                counter++;
            }
        }
        gs_.moveRecords_.clear(movePacket.time_);
        serverConnection.sendMessage(movePacket);
        ((p) && (p.onMove()));
    }

    override public function teleport(_arg_1:int):void {
        if (Parameters.data_.fameBlockTP) {
            this.player.textNotification("Ignored teleport, Boots on the Ground enabled", 0xE25F00);
            return;
        }
        var _local_2:Teleport = (this.messages.require(TELEPORT) as Teleport);
        _local_2.objectId_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function usePortal(_arg_1:int):void {
        if (Parameters.usingPortal) {
            Parameters.portalID = _arg_1;
        }
        var _local_2:UsePortal = (this.messages.require(USEPORTAL) as UsePortal);
        _local_2.objectId_ = _arg_1;
        serverConnection.sendMessage(_local_2);
        this.checkDavyKeyRemoval();
        if (Parameters.fameBot) {
            var _local_3:Portal = (this.gs_.map.goDict_[_arg_1] as Portal);
            if (_local_3 && _local_3.getName().indexOf("NexusPortal") != -1) {
                Parameters.fameBotPortalId = _arg_1;
                Parameters.fameBotPortal = _local_3;
                Parameters.fameBotPortalPoint = new Point((RandomUtil.plusMinus(0.5) + _local_3.x_), (RandomUtil.plusMinus(0.5) + _local_3.y_));
                this.player.textNotification("Fame Train Realm now set!");
                Parameters.fameBot = true;
                Parameters.fameBotWatchingPortal = false;
            }
        }
    }

    private function checkDavyKeyRemoval():void {
        if (gs_.map && gs_.map.name_ == "Davy Jones' Locker") {
            ShowHideKeyUISignal.instance.dispatch();
        }
    }

    override public function buy(sellableObjectId:int, quantity:int):void {
        var sObj:SellableObject;
        var converted:Boolean;
        if (outstandingBuy_ != null) {
            return;
        }
        sObj = gs_.map.goDict_[sellableObjectId];
        if (sObj == null) {
            return;
        }
        converted = false;
        if (sObj.currency_ == Currency.GOLD) {
            converted = (gs_.model.getConverted() || this.player.credits_ > 100 || sObj.price_ > this.player.credits_);
        }
        if (sObj.soldObjectName() == TextKey.VAULT_CHEST) {
            this.openDialog.dispatch(new PurchaseConfirmationDialog(function ():void {
                buyConfirmation(sObj, converted, sellableObjectId, quantity);
            }));
        }
        else {
            this.buyConfirmation(sObj, converted, sellableObjectId, quantity);
        }
    }

    private function buyConfirmation(_arg_1:SellableObject, _arg_2:Boolean, _arg_3:int, _arg_4:int):void {
        outstandingBuy_ = new OutstandingBuy(_arg_1.soldObjectInternalName(), _arg_1.price_, _arg_1.currency_, _arg_2);
        var _local_5:Buy = (this.messages.require(BUY) as Buy);
        _local_5.objectId_ = _arg_3;
        _local_5.quantity_ = _arg_4;
        serverConnection.sendMessage(_local_5);
    }

    public function gotoAck(_arg_1:int):void {
        var _local_2:GotoAck = (this.messages.require(GOTOACK) as GotoAck);
        _local_2.time_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function editAccountList(_arg_1:int, _arg_2:Boolean, _arg_3:int):void {
        var _local_4:EditAccountList = (this.messages.require(EDITACCOUNTLIST) as EditAccountList);
        _local_4.accountListId_ = _arg_1;
        _local_4.add_ = _arg_2;
        _local_4.objectId_ = _arg_3;
        serverConnection.sendMessage(_local_4);
    }

    override public function chooseName(_arg_1:String):void {
        var _local_2:ChooseName = (this.messages.require(CHOOSENAME) as ChooseName);
        _local_2.name_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function createGuild(_arg_1:String):void {
        var _local_2:CreateGuild = (this.messages.require(CREATEGUILD) as CreateGuild);
        _local_2.name_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function guildRemove(_arg_1:String):void {
        var _local_2:GuildRemove = (this.messages.require(GUILDREMOVE) as GuildRemove);
        _local_2.name_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function guildInvite(_arg_1:String):void {
        var _local_2:GuildInvite = (this.messages.require(GUILDINVITE) as GuildInvite);
        _local_2.name_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function requestTrade(_arg_1:String):void {
        var _local_2:RequestTrade = (this.messages.require(REQUESTTRADE) as RequestTrade);
        _local_2.name_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function changeTrade(_arg_1:Vector.<Boolean>):void {
        var _local_2:ChangeTrade = (this.messages.require(CHANGETRADE) as ChangeTrade);
        _local_2.offer_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function acceptTrade(_arg_1:Vector.<Boolean>, _arg_2:Vector.<Boolean>):void {
        var _local_3:AcceptTrade = (this.messages.require(ACCEPTTRADE) as AcceptTrade);
        _local_3.myOffer_ = _arg_1;
        _local_3.yourOffer_ = _arg_2;
        serverConnection.sendMessage(_local_3);
    }

    override public function cancelTrade():void {
        serverConnection.sendMessage(this.messages.require(CANCELTRADE));
    }

    override public function checkCredits():void {
        serverConnection.sendMessage(this.messages.require(CHECKCREDITS));
    }

    override public function escape():void {
        if (this.playerId_ == -1) {
            return;
        }
        if (gs_.map && gs_.map.name_ == "Arena") {
            serverConnection.sendMessage(this.messages.require(ACCEPTARENADEATH));
        }
        else {
            serverConnection.sendMessage(this.messages.require(ESCAPE));
            this.checkDavyKeyRemoval();
        }
    }

    override public function gotoQuestRoom():void {
        serverConnection.sendMessage(this.messages.require(QUESTROOMMSG));
    }

    override public function joinGuild(_arg_1:String):void {
        var _local_2:JoinGuild = (this.messages.require(JOINGUILD) as JoinGuild);
        _local_2.guildName_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    override public function changeGuildRank(_arg_1:String, _arg_2:int):void {
        var _local_3:ChangeGuildRank = (this.messages.require(CHANGEGUILDRANK) as ChangeGuildRank);
        _local_3.name_ = _arg_1;
        _local_3.guildRank_ = _arg_2;
        serverConnection.sendMessage(_local_3);
    }

    override public function changePetSkin(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local_4:ChangePetSkin = (this.messages.require(PETCHANGESKINMSG) as ChangePetSkin);
        _local_4.petId = _arg_1;
        _local_4.skinType = _arg_2;
        _local_4.currency = _arg_3;
        serverConnection.sendMessage(_local_4);
    }

    private function rsaEncrypt(_arg_1:String):String {
        var _local_2:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
        var _local_3:ByteArray = new ByteArray();
        _local_3.writeUTFBytes(_arg_1);
        var _local_4:ByteArray = new ByteArray();
        _local_2.encrypt(_local_3, _local_4, _local_3.length);
        return (Base64.encodeByteArray(_local_4));
    }

    private function onConnected():void {
        var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
        this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME, TextKey.CHAT_CONNECTED));
        this.encryptConnection();
        var hello:Hello = (this.messages.require(HELLO) as Hello);
        hello.buildVersion_ = Parameters.data_.gameVersion;
        hello.gameId_ = gameId_;
        if (hello.gameId_ == -2) {
            if (Parameters.data_.disableNexus) {
                hello.gameId_ = -5;
            }
        }
        if (CurrentCharacterRect.vaultSelect) {
            hello.gameId_ = Parameters.VAULT_GAMEID;
            CurrentCharacterRect.vaultSelect = false;
        }
        if (Parameters.dailyCalendar1RunOnce) {
            hello.gameId_ = Parameters.DAILYQUESTROOM_GAMEID;
            Parameters.dailyCalendar1RunOnce = false;
        }
        hello.guid_ = this.rsaEncrypt(account.getUserId());
        hello.password_ = this.rsaEncrypt(account.getPassword());
        hello.secret_ = this.rsaEncrypt(account.getSecret());
        hello.keyTime_ = keyTime_;
        hello.key_.length = 0;
        (key_ != null && hello.key_.writeBytes(key_));
        hello.mapJSON_ = ((mapJSON_ == null) ? "" : mapJSON_);
        hello.entrytag_ = account.getEntryTag();
        hello.gameNet = account.gameNetwork();
        hello.gameNetUserId = account.gameNetworkUserId();
        hello.playPlatform = account.playPlatform();
        hello.platformToken = account.getPlatformToken();
        hello.userToken = account.getToken();
        serverConnection.sendMessage(hello);
    }

    private function onCreateSuccess(_arg_1:CreateSuccess):void {
        this.playerId_ = _arg_1.objectId_;
        charId_ = _arg_1.charId_;
        gs_.initialize();
        createCharacter_ = false;
        Parameters.lockRecon = false;
    }

    private function onDamage(dmg:Damage):void {
        var bulId:int;
        var objIdBool:Boolean;
        var absMap:AbstractMap = gs_.map;
        var proj:Projectile;
        if (!Parameters.ssmode && Parameters.lowCPUMode) {
            if (dmg.objectId_ != this.player.objectId_ || dmg.targetId_ != this.player.objectId_) {
                return;
            }
        }
        if (((dmg.objectId_ >= 0) && (dmg.bulletId_ > 0))) {
            bulId = Projectile.findObjId(dmg.objectId_, dmg.bulletId_);
            proj = (absMap.boDict_[bulId] as Projectile);
            if (((!(proj == null)) && (!(proj.projProps_.multiHit_)))) {
                absMap.removeObj(bulId);
            }
        }
        var gameObj:GameObject = absMap.goDict_[dmg.targetId_];
        if (gameObj != null) {
            objIdBool = (dmg.objectId_ == this.player.objectId_);
            gameObj.damage(objIdBool, dmg.damageAmount_, dmg.effects_, dmg.kill_, proj, dmg.armorPierce_);
        }
    }

    private function onServerPlayerShoot(_arg_1:ServerPlayerShoot):void {
        var ownId:* = (_arg_1.ownerId_ == this.playerId_);
        var gObj:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        if (gObj == null || gObj.dead_) {
            if (ownId) {
                this.shootAck(-1);
            }
            return;
        }
        if (gObj.objectId_ != this.playerId_ && Parameters.data_.disableAllyShoot) {
            return;
        }
        var proj:Projectile = (FreeList.newObject(Projectile) as Projectile);
        var p:Player = (gObj as Player);
        if (p != null) {
            proj.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_, p.projectileIdSetOverrideNew, p.projectileIdSetOverrideOld);
        }
        else {
            proj.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_);
        }
        proj.setDamage(_arg_1.damage_);
        gs_.map.addObj(proj, _arg_1.startingPos_.x_, _arg_1.startingPos_.y_);
        if (ownId) {
            this.shootAck(gs_.lastUpdate_);
            if (!proj.update(proj.startTime_, 0)) {
                gs_.map.removeObj(proj.objectId_);
            }
        }
    }

    private function onAllyShoot(_arg_1:AllyShoot):void {
        var gameObj:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        if (((gameObj == null) || (gameObj.dead_))) {
            return;
        }
        if (Parameters.data_.disableAllyShoot == 1) {
            return;
        }
        gameObj.setAttack(_arg_1.containerType_, _arg_1.angle_);
        if (Parameters.data_.disableAllyShoot == 2) {
            return;
        }
        var proj:Projectile = (FreeList.newObject(Projectile) as Projectile);
        var p:Player = (gameObj as Player);
        if (p != null) {
            proj.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_, p.projectileIdSetOverrideNew, p.projectileIdSetOverrideOld);
        }
        else {
            proj.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_);
        }
        gs_.map.addObj(proj, gameObj.x_, gameObj.y_);
    }

    private function onReskinUnlock(_arg_1:ReskinUnlock):void {
        var _local_2:String;
        var _local_3:CharacterSkin;
        var _local_4:PetsModel;
        if (_arg_1.isPetSkin == 0) {
            for (_local_2 in this.model.player.lockedSlot) {
                if (this.model.player.lockedSlot[_local_2] == _arg_1.skinID) {
                    this.model.player.lockedSlot[_local_2] = 0;
                }
            }
            _local_3 = this.classesModel.getCharacterClass(this.model.player.objectType_).skins.getSkin(_arg_1.skinID);
            _local_3.setState(CharacterSkinState.OWNED);
        }
        else {
            _local_4 = StaticInjectorContext.getInjector().getInstance(PetsModel);
            _local_4.unlockSkin(_arg_1.skinID);
        }
    }

    private function onEnemyShoot(_arg_1:EnemyShoot):void {
        var proj:Projectile;
        var calcAngle:Number;
        var gameObj:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        if (((gameObj == null) || (gameObj.dead_))) {
            this.shootAck(-1);
            return;
        }
        if (Parameters.suicideMode) {
            _arg_1.startingPos_.x_ = player.x_;
            _arg_1.startingPos_.y_ = player.y_;
        }
        var counter:int;
        while (counter < _arg_1.numShots_) {
            proj = (FreeList.newObject(Projectile) as Projectile);
            calcAngle = (_arg_1.angle_ + (_arg_1.angleInc_ * counter));
            proj.reset(gameObj.objectType_, _arg_1.bulletType_, _arg_1.ownerId_, ((_arg_1.bulletId_ + counter) % 0x0100), calcAngle, gs_.lastUpdate_);
            proj.setDamage(_arg_1.damage_);
            gs_.map.addObj(proj, _arg_1.startingPos_.x_, _arg_1.startingPos_.y_);
            counter++;
        }
        this.shootAck(gs_.lastUpdate_);
        gameObj.setAttack(gameObj.objectType_, (_arg_1.angle_ + (_arg_1.angleInc_ * ((_arg_1.numShots_ - 1) / 2))));
    }

    private function onTradeRequested(_arg_1:TradeRequested):void {
        if (Parameters.autoAcceptTrades || Parameters.receivingPots) {
            this.playerText(("/trade " + _arg_1.name_));
            return;
        }
        if (!Parameters.data_.chatTrade) {
            return;
        }
        if (Parameters.data_.tradeWithFriends && !this.socialModel.isMyFriend(_arg_1.name_)) {
            return;
        }
        if (Parameters.data_.showTradePopup) {
            gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(gs_, _arg_1.name_));
        }
        this.addTextLine.dispatch(ChatMessage.make("", (_arg_1.name_ + " wants to " + 'trade with you.  Type "/trade ' + _arg_1.name_ + '" to trade.')));
    }

    private function onTradeStart(_arg_1:TradeStart):void {
        if (Parameters.givingPotions) {
            this.changeTrade(Parameters.potionsToTrade);
            this.acceptTrade(Parameters.potionsToTrade, Parameters.emptyOffer);
            Parameters.givingPotions = false;
        }
        gs_.hudView.startTrade(gs_, _arg_1);
    }

    private function onTradeChanged(_arg_1:TradeChanged):void {
        if (Parameters.receivingPots) {
            this.acceptTrade(Parameters.emptyOffer, _arg_1.offer_);
            Parameters.receivingPots = false;
        }
        gs_.hudView.tradeChanged(_arg_1);
    }

    private function onTradeDone(_arg_1:TradeDone):void {
        var _local_3:Object;
        var _local_4:Object;
        gs_.hudView.tradeDone();
        var _local_2:String = "";
        try {
            _local_4 = JSON.parse(_arg_1.description_);
            _local_2 = _local_4.key;
            _local_3 = _local_4.tokens;
        }
        catch (e:Error) {
        }
        this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, _local_2, -1, -1, "", false, _local_3));
        if (Parameters.autoDrink && _arg_1.code_ == 0) {
            Parameters.watchInv = true;
        }
    }

    private function onTradeAccepted(_arg_1:TradeAccepted):void {
        gs_.hudView.tradeAccepted(_arg_1);
        if (Parameters.autoAcceptTrades || Parameters.receivingPots) {
            acceptTrade(_arg_1.myOffer_, _arg_1.yourOffer_);
        }
    }

    private function addObject(objData:ObjectData):void {
        var absMap:AbstractMap = gs_.map;
        var gameObj:GameObject = ObjectLibrary.getObjectFromType(objData.objectType_);
        if (gameObj == null) {
            return;
        }
        var objStatData:ObjectStatusData = objData.status_;
        gameObj.setObjectId(objStatData.objectId_);
        absMap.addObj(gameObj, objStatData.pos_.x_, objStatData.pos_.y_);
        if ((gameObj is Player)) {
            this.handleNewPlayer((gameObj as Player), absMap);
        }
        this.processObjectStatus(objStatData, 0, -1);
        if (gameObj.props_.isEnemy_) {
            if (((((!(gameObj.dead_)) && (!((gameObj.props_.isCube_) && (Parameters.data_.fameBlockCubes)))) && (!((!(gameObj.props_.isGod_)) && (Parameters.data_.fameBlockGodsOnly)))) && (!(gameObj.condition_[0] & 0xA00000)))) {
                absMap.vulnEnemyDict_.push(gameObj);
            }
        }
        else {
            if (gameObj.props_.isPlayer_) {
                if (!gameObj.isPaused && !gameObj.isInvincible && !gameObj.isStasis && !gameObj.dead_) {
                    absMap.vulnPlayerDict_.push(gameObj);
                }
                if (gameObj.objectId_ == this.playerId_) {
                    if (!Parameters.ssmode && this.gs_.map.isVault) {
                        gameObj.x_ = 44.5;
                        gameObj.y_ = 70.5000001;
                    }
                }
            }
        }
        if ((((gameObj.props_.static_) && (gameObj.props_.occupySquare_)) && (!(gameObj.props_.noMiniMap_)))) {
            this.updateGameObjectTileSignal.dispatch(new UpdateGameObjectTileVO(gameObj.x_, gameObj.y_, gameObj));
        }
        switch (gameObj.objectType_) {
            case 3368:
            case 32694:
            case 29003:
            case 29021:
            case 29039:
                player.questMob1 = gameObj;
                break;
            case 3366:
            case 32692:
            case 29341:
                player.questMob2 = gameObj;
                break;
            case 3367:
            case 32693:
            case 29342:
                player.questMob3 = gameObj;
                break;
            case 29466:
            case 29563:
            case 29564:
                player.questMob1 = null;
                player.questMob2 = null;
                player.questMob3 = null;
                break;
        }
    }

    private function handleNewPlayer(p:Player, _arg_2:AbstractMap):void {
        this.setPlayerSkinTemplate(p, 0);
        if (p.objectId_ == this.playerId_) {
            this.player = p;
            this.model.player = p;
            _arg_2.player_ = p;
            p.relMoveVec_ = new Point(0, 0);
            p.conMoveVec = new Point(0, 0);
            gs_.setFocus(p);
            p.createSocket();
            this.setGameFocus.dispatch(this.playerId_.toString());
        }
    }

    private function onUpdate(update:Update):void {
        var counter:int;
        var gTileData:GroundTileData;
        var msg:Message = this.messages.require(UPDATEACK);
        serverConnection.sendMessage(msg);
        counter = 0;
        while (counter < update.tiles_.length) {
            gTileData = update.tiles_[counter];
            gs_.map.setGroundTile(gTileData.x_, gTileData.y_, gTileData.type_);
            this.updateGroundTileSignal.dispatch(new UpdateGroundTileVO(gTileData.x_, gTileData.y_, gTileData.type_));
            counter++;
        }
        counter = 0;
        while (counter < update.newObjs_.length) {
            this.addObject(update.newObjs_[counter]);
            counter++;
        }
        counter = 0;
        while (counter < update.drops_.length) {
            gs_.map.removeObj(update.drops_[counter]);
            counter++;
        }
        gs_.map.calcVulnerables();
    }

    private function onNotification(_arg_1:Notification):void {
        var _local_3:LineBuilder;
        var _local_2:GameObject = gs_.map.goDict_[_arg_1.objectId_];
        if (_local_2 != null) {
            _local_3 = LineBuilder.fromJSON(_arg_1.message);
            if (!Parameters.ssmode && Parameters.data_.ignoreStatusText) {
                if (_local_3.key == "server.no_effect") {
                    return;
                }
            }
            if (_local_2 == this.player) {
                if (_local_3.key == "server.quest_complete") {
                    gs_.map.quest_.completed();
                }
                if (_local_3.key == "server.plus_symbol" && _arg_1.color_ == 0xFF00) {
                    this.player.addHealth(_local_3.tokens.amount);
                }
                this.makeNotification(_local_3, _local_2, _arg_1.color_, 1000);
            }
            else {
                if (_local_2.props_.isEnemy_ || !Parameters.data_.noAllyNotifications) {
                    this.makeNotification(_local_3, _local_2, _arg_1.color_, 1000);
                }
            }
        }
    }

    private function makeNotification(_arg_1:LineBuilder, _arg_2:GameObject, _arg_3:uint, _arg_4:int):void {
        var _local_5:CharacterStatusText = new CharacterStatusText(_arg_2, _arg_3, _arg_4);
        _local_5.setStringBuilder(_arg_1);
        gs_.map.mapOverlay_.addStatusText(_local_5);
    }

    private function onGlobalNotification(_arg_1:GlobalNotification):void {
        switch (_arg_1.text) {
            case "yellow":
                ShowKeySignal.instance.dispatch(Key.YELLOW);
                return;
            case "red":
                ShowKeySignal.instance.dispatch(Key.RED);
                return;
            case "green":
                ShowKeySignal.instance.dispatch(Key.GREEN);
                return;
            case "purple":
                ShowKeySignal.instance.dispatch(Key.PURPLE);
                return;
            case "showKeyUI":
                ShowHideKeyUISignal.instance.dispatch();
                return;
            case "giftChestOccupied":
                this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_GIFT);
                return;
            case "giftChestEmpty":
                this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_NO_GIFT);
                return;
            case "beginnersPackage":
                return;
        }
    }

    private function onNewTick(nTick:NewTick):void {
        var objStatData:ObjectStatusData;
        var counter:int = 0;
        var bool:Boolean;
        if (jitterWatcher_ != null) {
            jitterWatcher_.record();
        }
        this.move(nTick.tickId_, this.player);
        for each (objStatData in nTick.statuses_) {
            this.processObjectStatus(objStatData, nTick.tickTime_, nTick.tickId_);
        }
        lastTickId_ = nTick.tickId_;
        this.gs_.map.calcVulnerables();
        if (Parameters.usingPortal) {
            while (counter < Parameters.portalSpamRate) {
                usePortal(Parameters.portalID);
                counter++;
            }
        }
        if (Parameters.watchInv) {
            counter = 4;
            while (counter < 12) {
                if (player.equipment_[counter] != -1) {
                    if (player.shouldDrink(player.getPotType(player.equipment_[counter]))) {
                        useItem(gs_.lastUpdate_, player.objectId_, counter, player.equipment_[counter], player.x_, player.y_, 1);
                        bool = true;
                    }
                }
                counter++;
            }
            if (bool) {
                Parameters.watchInv = false;
            }
        }
        if (Parameters.fameBot) {
            Parameters.famePointOffset = ((Parameters.data_.famePointOffset /** Math.random()*/) - (Parameters.data_.famePointOffset * 0.5));
        }
    }

    private function canShowEffect(_arg_1:GameObject):Boolean {
        if (_arg_1 != null) {
            return (true);
        }
        var _local_2:Boolean = (_arg_1.objectId_ == this.playerId_);
        if (!_local_2 && _arg_1.props_.isPlayer_ && Parameters.data_.disableAllyShoot) {
            return (false);
        }
        return (true);
    }

    private function onShowEffect(showEff:ShowEffect):void {
        var oAbsMap:AbstractMap = gs_.map;
        var oGameObj:GameObject = oAbsMap.goDict_[showEff.targetObjectId_];
        var oParticleEff:ParticleEffect;
        var oPoint:Point;
        var object:GameObject = oAbsMap.goDict_[showEff.targetObjectId_];
        var oCalcEffPos:uint;
        if (object != null) {
            if (object.objectType_ == 799 && showEff.color_ == 0xFF0000) {
                var _local_7:int = (object as Player).calcSealHeal();
                if (_local_7 != 0) {
                    player.addSealHealth(_local_7);
                }
            }
            else {
                if (showEff.effectType_ == 12 && showEff.color_ == 0xFF0088) {
                    Parameters.mystics.push(object.name_ + " " + getTimer());
                }
            }
            if (!Parameters.ssmode) {
                if (object.props_.isPlayer_ && object.objectId_ != this.playerId_ && Parameters.data_.alphaOnOthers) {
                    return;
                }
            }
        }
        if (!Parameters.ssmode) {
            if (Parameters.lowCPUMode) {
                return;
            }
            if (Parameters.data_.liteParticle) {
                if (!(showEff.effectType_ == 4 || showEff.effectType_ == 12 || showEff.effectType_ == 16 || showEff.effectType_ == 15)) {
                    return;
                }
            }
        }
        if (Parameters.data_.noParticlesMaster && (showEff.effectType_ == ShowEffect.HEAL_EFFECT_TYPE || showEff.effectType_ == ShowEffect.TELEPORT_EFFECT_TYPE || showEff.effectType_ == ShowEffect.STREAM_EFFECT_TYPE || showEff.effectType_ == ShowEffect.POISON_EFFECT_TYPE || showEff.effectType_ == ShowEffect.LINE_EFFECT_TYPE || showEff.effectType_ == ShowEffect.FLOW_EFFECT_TYPE || showEff.effectType_ == ShowEffect.COLLAPSE_EFFECT_TYPE || showEff.effectType_ == ShowEffect.CONEBLAST_EFFECT_TYPE || showEff.effectType_ == ShowEffect.NOVA_NO_AOE_EFFECT_TYPE)) {
            return;
        }
        switch (showEff.effectType_) {
            case ShowEffect.HEAL_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oAbsMap.addObj(new HealEffect(oGameObj, showEff.color_), oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.TELEPORT_EFFECT_TYPE:
                oAbsMap.addObj(new TeleportEffect(), showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.STREAM_EFFECT_TYPE:
                oParticleEff = new StreamEffect(showEff.pos1_, showEff.pos2_, showEff.color_);
                oAbsMap.addObj(oParticleEff, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.THROW_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                oPoint = ((oGameObj != null) ? new Point(oGameObj.x_, oGameObj.y_) : showEff.pos2_.toPoint());
                if (oGameObj != null && !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new ThrowEffect(oPoint, showEff.pos1_.toPoint(), showEff.color_, (showEff.duration_ * 1000));
                oAbsMap.addObj(oParticleEff, oPoint.x, oPoint.y);
                return;
            case ShowEffect.NOVA_EFFECT_TYPE:
            case ShowEffect.NOVA_NO_AOE_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new NovaEffect(oGameObj, showEff.pos1_.x_, showEff.color_);
                oAbsMap.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.POISON_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new PoisonEffect(oGameObj, showEff.color_);
                oAbsMap.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.LINE_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new LineEffect(oGameObj, showEff.pos1_, showEff.color_);
                oAbsMap.addObj(oParticleEff, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.BURST_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new BurstEffect(oGameObj, showEff.pos1_, showEff.pos2_, showEff.color_);
                oAbsMap.addObj(oParticleEff, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.FLOW_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new FlowEffect(showEff.pos1_, oGameObj, showEff.color_);
                oAbsMap.addObj(oParticleEff, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.RING_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new RingEffect(oGameObj, showEff.pos1_.x_, showEff.color_);
                oAbsMap.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.LIGHTNING_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new LightningEffect(oGameObj, showEff.pos1_, showEff.color_, showEff.pos2_.x_);
                oAbsMap.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.COLLAPSE_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new CollapseEffect(oGameObj, showEff.pos1_, showEff.pos2_, showEff.color_);
                oAbsMap.addObj(oParticleEff, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.CONEBLAST_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new ConeBlastEffect(oGameObj, showEff.pos1_, showEff.pos2_.x_, showEff.color_);
                oAbsMap.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.JITTER_EFFECT_TYPE:
                gs_.camera_.startJitter();
                return;
            case ShowEffect.FLASH_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oGameObj.flash_ = new FlashDescription(getTimer(), showEff.color_, showEff.pos1_.x_, showEff.pos1_.y_);
                return;
            case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
                oPoint = showEff.pos1_.toPoint();
                if (oGameObj != null && !this.canShowEffect(oGameObj)) {
                    break;
                }
                oParticleEff = new ThrowProjectileEffect(showEff.color_, showEff.pos2_.toPoint(), showEff.pos1_.toPoint(), (showEff.duration_ * 1000));
                oAbsMap.addObj(oParticleEff, oPoint.x, oPoint.y);
                return;
            case ShowEffect.SHOCKER_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                if (oGameObj && oGameObj.shockEffect) {
                    oGameObj.shockEffect.destroy();
                }
                oParticleEff = new ShockerEffect(oGameObj);
                oGameObj.shockEffect = ShockerEffect(oParticleEff);
                gs_.map.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
            case ShowEffect.SHOCKEE_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                if (!oGameObj.hasShock) {
                    oParticleEff = new ShockeeEffect(oGameObj);
                    gs_.map.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                }
                return;
            case ShowEffect.RISING_FURY_EFFECT_TYPE:
                oGameObj = oAbsMap.goDict_[showEff.targetObjectId_];
                if (oGameObj == null || !this.canShowEffect(oGameObj)) {
                    break;
                }
                oCalcEffPos = (showEff.pos1_.x_ * 1000);
                oParticleEff = new RisingFuryEffect(oGameObj, oCalcEffPos);
                gs_.map.addObj(oParticleEff, oGameObj.x_, oGameObj.y_);
                return;
        }
    }

    private function onGoto(_arg_1:Goto):void {
        this.gotoAck(gs_.lastUpdate_);
        var _local_2:GameObject = gs_.map.goDict_[_arg_1.objectId_];
        if (_local_2 == null) {
            return;
        }
        _local_2.onGoto(_arg_1.pos_.x_, _arg_1.pos_.y_, gs_.lastUpdate_);
    }

    public function updateGameObject(_arg_1:GameObject, _arg_2:Vector.<StatData>, _arg_3:Boolean, _arg_4:Boolean):void {
        var sData:StatData;
        var sValue:int;
        var sEquip:int;
        var calcSlot:int;
        var bool:Boolean;
        var p:Player = (_arg_1 as Player);
        var uMerchant:Merchant = (_arg_1 as Merchant);
        var uPet:Pet = (_arg_1 as Pet);
        if (uPet) {
            this.petUpdater.updatePet(uPet, _arg_2);
            if (gs_.map.isPetYard) {
                this.petUpdater.updatePetVOs(uPet, _arg_2);
            }
            _arg_1.updateStatuses();
            return;
        }
        for each (sData in _arg_2) {
            sValue = sData.statValue_;
            switch (sData.statType_) {
                case StatData.MAX_HP_STAT:
                    p.maxHpChanged(sValue);
                    _arg_1.maxHP_ = sValue;
                    p.calcHealthPercent();
                    break;
                case StatData.HP_STAT:
                    if (_arg_3) {
                        if (_arg_4) {
                            p.clientHp = sValue;
                            p.maxHpChanged(sValue);
                        }
                        p.hp2 = sValue;
                    }
                    _arg_1.hp_ = sValue;
                    if (((((_arg_1.dead_) && (sValue > 1)) && (_arg_1.props_.isEnemy_)) && (++_arg_1.deadCounter_ >= 2))) {
                        _arg_1.dead_ = false;
                    }
                    break;
                case StatData.SIZE_STAT:
                    if (sEquip) {
                        if (Parameters.data_.showSkins) {
                            _arg_1.size_ = sValue;
                        }
                        if (((_arg_1 == player) && (Parameters.data_.nsetSkin[0] == "playerskins16"))) {
                            _arg_1.size_ = 70;
                        }
                        break;
                    }
                    if (((Parameters.data_.sizer) && (!(Parameters.ssmode)))) {
                        _arg_1.size_ = ((sValue < 100) ? sValue : 100);
                    } else if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.pSize && !Parameters.ssmode) {
                        _arg_1.size_ = Parameters.data_.playerSize;
                    }
                    else {
                        _arg_1.size_ = sValue;
                    }
                    break;
                case StatData.MAX_MP_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.maxMP_ = 5000;
                    } else
                        p.maxMP_ = sValue;
                    break;
                case StatData.MP_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.mp_ = 5000;
                    } else
                        p.mp_ = sValue;
                    break;
                case StatData.NEXT_LEVEL_EXP_STAT:
                    p.nextLevelExp_ = sValue;
                    break;
                case StatData.EXP_STAT:
                    if (!Parameters.ssmode && p != player && Parameters.data_.hackerMode) {
                        p.exp_ = 1337;
                    } else
                        p.exp_ = sValue;
                    break;
                case StatData.LEVEL_STAT:
                    _arg_1.level_ = sValue;
                    break;
                case StatData.ATTACK_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.attack_ = 5000;
                    } else
                        p.attack_ = sValue;
                    break;
                case StatData.DEFENSE_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.defense_ = 5000;
                    } else
                        _arg_1.defense_ = sValue;
                    break;
                case StatData.SPEED_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.speed_ = 5000;
                    } else
                        p.speed_ = sValue;
                    break;
                case StatData.DEXTERITY_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.dexterity_ = 5000;
                    } else
                        p.dexterity_ = sValue;
                    break;
                case StatData.VITALITY_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.vitality_ = 5000;
                    } else
                        p.vitality_ = sValue;
                    break;
                case StatData.WISDOM_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        p.wisdom_ = 5000;
                    } else
                        p.wisdom_ = sValue;
                    break;
                case StatData.CONDITION_STAT:
                    _arg_1.condition_[ConditionEffect.CE_FIRST_BATCH] = sValue;
                    _arg_1.updateStatuses();
                    break;
                case StatData.INVENTORY_0_STAT:
                case StatData.INVENTORY_1_STAT:
                case StatData.INVENTORY_2_STAT:
                case StatData.INVENTORY_3_STAT:
                case StatData.INVENTORY_4_STAT:
                case StatData.INVENTORY_5_STAT:
                case StatData.INVENTORY_6_STAT:
                case StatData.INVENTORY_7_STAT:
                case StatData.INVENTORY_8_STAT:
                case StatData.INVENTORY_9_STAT:
                case StatData.INVENTORY_10_STAT:
                case StatData.INVENTORY_11_STAT:
                    sEquip = (sData.statType_ - StatData.INVENTORY_0_STAT);
                    if (sValue != -1) {
                        _arg_1.lockedSlot[sEquip] = 0;
                    }
                    _arg_1.equipment_[sEquip] = sValue;
                    break;
                case StatData.NUM_STARS_STAT:
                    if (!Parameters.ssmode && p != player && Parameters.data_.hackerMode) {
                        p.numStars_ = 1337;
                    } else
                        p.numStars_ = sValue;
                    break;
                case StatData.NAME_STAT:
                    if ((!(_arg_1.objectId_ == this.playerId_)) && (_arg_1.props_.isPlayer_) && Parameters.data_.hackerMode && !Parameters.ssmode) {
                        _arg_1.name_ = "1337";
                    } else if (_arg_1.name_ != sData.strStatValue_) {
                        _arg_1.name_ = sData.strStatValue_;
                        _arg_1.nameBitmapData_ = null;
                    }
                    break;
                case StatData.TEX1_STAT:
                    if (p == player) {
                        Parameters.PlayerTex1 = sValue;
                    }
                    if (!Parameters.data_.showDyes && !Parameters.ssmode || sValue <= 0) {
                        _arg_1.setTex1(0);
                    }
                    else {
                        _arg_1.setTex1(sValue);
                    }
                    if (!Parameters.ssmode && p == player && Parameters.data_.setTex1 != -1) {
                        _arg_1.setTex1(Parameters.data_.setTex1);
                    }
                    break;
                case StatData.TEX2_STAT:
                    if (p == player) {
                        Parameters.PlayerTex2 = sValue;
                    }
                    if (!Parameters.data_.showDyes && !Parameters.ssmode || sValue <= 0) {
                        _arg_1.setTex2(0);
                    }
                    else {
                        _arg_1.setTex2(sValue);
                    }
                    if (!Parameters.ssmode && p == player && Parameters.data_.setTex2 != -1) {
                        _arg_1.setTex1(Parameters.data_.setTex2);
                    }
                    break;
                case StatData.MERCHANDISE_TYPE_STAT:
                    uMerchant.setMerchandiseType(sValue);
                    break;
                case StatData.CREDITS_STAT:
                    if (!Parameters.ssmode && Parameters.data_.hackerMode) {
                        p.setCredits(1337)
                    } else
                        p.setCredits(sValue);
                    break;
                case StatData.MERCHANDISE_PRICE_STAT:
                    (_arg_1 as SellableObject).setPrice(sValue);
                    break;
                case StatData.ACTIVE_STAT:
                    (_arg_1 as Portal).active_ = sValue != 0;
                    if (Parameters.fameBot && Parameters.fameBotPortalId == _arg_1.objectId_ && (PointUtil.distanceSquaredXY(this.player.x_, this.player.y_, _arg_1.x_, _arg_1.y_) <= 1)) {
                        if (sValue != 0) {
                            usePortal(_arg_1.objectId_);
                        }
                    }
                    break;
                case StatData.ACCOUNT_ID_STAT:
                    p.accountId_ = sData.strStatValue_;
                    break;
                case StatData.FAME_STAT:
                    if (!Parameters.ssmode && Parameters.data_.hackerMode) {
                        p.setFame(1337)
                    } else
                        p.setFame(sValue);
                    break;
                case StatData.FORTUNE_TOKEN_STAT:
                    p.setTokens(sValue);
                    break;
                case StatData.SUPPORTER_POINTS_STAT:
                    if (p != null) {
                        p.supporterPoints = sValue;
                        p.clearTextureCache();
                        if (p.objectId_ == this.playerId_) {
                            StaticInjectorContext.getInjector().getInstance(SupporterCampaignModel).updatePoints(sValue);
                        }
                    }
                    break;
                case StatData.SUPPORTER_STAT:
                    if (p != null) {
                        p.setSupporterFlag(sValue);
                    }
                    break;
                case StatData.MERCHANDISE_CURRENCY_STAT:
                    (_arg_1 as SellableObject).setCurrency(sValue);
                    break;
                case StatData.CONNECT_STAT:
                    _arg_1.connectType_ = sValue;
                    break;
                case StatData.MERCHANDISE_COUNT_STAT:
                    uMerchant.count_ = sValue;
                    uMerchant.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_MINS_LEFT_STAT:
                    uMerchant.minsLeft_ = sValue;
                    uMerchant.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_DISCOUNT_STAT:
                    uMerchant.discount_ = sValue;
                    uMerchant.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_RANK_REQ_STAT:
                    (_arg_1 as SellableObject).setRankReq(sValue);
                    break;
                case StatData.MAX_HP_BOOST_STAT:
                    if (_arg_3) {
                        bool = true;
                    }
                    p.maxHPBoost_ = sValue;
                    break;
                case StatData.MAX_MP_BOOST_STAT:
                    p.maxMPBoost_ = sValue;
                    break;
                case StatData.ATTACK_BOOST_STAT:
                    p.attackBoost_ = sValue;
                    break;
                case StatData.DEFENSE_BOOST_STAT:
                    p.defenseBoost_ = sValue;
                    break;
                case StatData.SPEED_BOOST_STAT:
                    p.speedBoost_ = sValue;
                    break;
                case StatData.VITALITY_BOOST_STAT:
                    p.vitalityBoost_ = sValue;
                    break;
                case StatData.WISDOM_BOOST_STAT:
                    p.wisdomBoost_ = sValue;
                    break;
                case StatData.DEXTERITY_BOOST_STAT:
                    p.dexterityBoost_ = sValue;
                    break;
                case StatData.OWNER_ACCOUNT_ID_STAT:
                    (_arg_1 as Container).setOwnerId(sData.strStatValue_);
                    break;
                case StatData.RANK_REQUIRED_STAT:
                    (_arg_1 as NameChanger).setRankRequired(sValue);
                    break;
                case StatData.NAME_CHOSEN_STAT:
                    p.nameChosen_ = (!(sValue == 0));
                    _arg_1.nameBitmapData_ = null;
                    break;
                case StatData.CURR_FAME_STAT:
                    if (!Parameters.ssmode && Parameters.data_.hackerMode) {
                        p.currFame_ = 505050;
                    } else
                        p.currFame_ = sValue;
                    break;
                case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                    p.nextClassQuestFame_ = sValue;
                    break;
                case StatData.LEGENDARY_RANK_STAT:
                    p.legendaryRank_ = sValue;
                    break;
                case StatData.SINK_LEVEL_STAT:
                    if (!_arg_3) {
                        p.sinkLevel_ = sValue;
                    }
                    break;
                case StatData.ALT_TEXTURE_STAT:
                    _arg_1.setAltTexture(sValue);
                    break;
                case StatData.GUILD_NAME_STAT:
                    if (!Parameters.ssmode && p != player && Parameters.data_.hackerMode) {
                        p.setGuildName("1337");
                    } else
                        p.setGuildName(sData.strStatValue_);
                    break;
                case StatData.GUILD_RANK_STAT:
                    p.guildRank_ = sValue;
                    break;
                case StatData.BREATH_STAT:
                    p.breath_ = sValue;
                    break;
                case StatData.XP_BOOSTED_STAT:
                    p.xpBoost_ = sValue;
                    break;
                case StatData.XP_TIMER_STAT:
                    p.xpTimer = (sValue * TO_MILLISECONDS);
                    break;
                case StatData.LD_TIMER_STAT:
                    p.dropBoost = (sValue * TO_MILLISECONDS);
                    break;
                case StatData.LT_TIMER_STAT:
                    p.tierBoost = (sValue * TO_MILLISECONDS);
                    break;
                case StatData.HEALTH_POTION_STACK_STAT:
                    p.healthPotionCount_ = sValue;
                    break;
                case StatData.MAGIC_POTION_STACK_STAT:
                    p.magicPotionCount_ = sValue;
                    break;
                case StatData.TEXTURE_STAT:
                    if (p != null) {
                        if (p == player) {
                            Parameters.playerSkin = sValue;
                        }
                        if (!Parameters.data_.showSkins) {
                            break;
                        }
                        (p.skinId != sValue && sValue >= 0 && this.setPlayerSkinTemplate(p, sValue));
                        if (p == player && Parameters.data_.nsetSkin[1] != -1 && !Parameters.ssmode) {
                            player.skin = AnimatedChars.getAnimatedChar(Parameters.data_.nsetSkin[0], Parameters.data_.nsetSkin[1]);
                        }
                    }
                    else {
                        if (_arg_1.objectType_ == 1813 && sValue > 0) {
                            _arg_1.setTexture(sValue);
                        }
                    }
                    break;
                case StatData.HASBACKPACK_STAT:
                    (_arg_1 as Player).hasBackpack_ = Boolean(sValue);
                    if (_arg_3) {
                        this.updateBackpackTab.dispatch(Boolean(sValue));
                    }
                    break;
                case StatData.BACKPACK_0_STAT:
                case StatData.BACKPACK_1_STAT:
                case StatData.BACKPACK_2_STAT:
                case StatData.BACKPACK_3_STAT:
                case StatData.BACKPACK_4_STAT:
                case StatData.BACKPACK_5_STAT:
                case StatData.BACKPACK_6_STAT:
                case StatData.BACKPACK_7_STAT:
                    calcSlot = (((sData.statType_ - StatData.BACKPACK_0_STAT) + GeneralConstants.NUM_EQUIPMENT_SLOTS) + GeneralConstants.NUM_INVENTORY_SLOTS);
                    (_arg_1 as Player).equipment_[calcSlot] = sValue;
                    break;
                case StatData.NEW_CON_STAT:
                    _arg_1.condition_[ConditionEffect.CE_SECOND_BATCH] = sValue;
                    _arg_1.updateStatuses();
                    break;
            }
        }
        if (_arg_3) {
            if (bool) {
                p.triggerHealBuffer();
            }
            if (Parameters.data_.AutoSyncClientHP && Math.abs(p.clientHp - p.hp_) > 90) {
                if (p.ticksHPLastOff++ > 3) {
                    p.ticksHPLastOff = 0;
                    p.clientHp = p.hp_;
                }
            }
        }
    }

    override public function setPlayerSkinTemplate(_arg_1:Player, _arg_2:int):void {
        var _local_3:Reskin = (this.messages.require(RESKIN) as Reskin);
        _local_3.skinID = _arg_2;
        _local_3.player = _arg_1;
        _local_3.consume();
    }

    private function processObjectStatus(objStatData:ObjectStatusData, _arg_2:int, _arg_3:int):void {
        var pLevel:int;
        var pExp:int;
        var pSkinId:int;
        var pCurrFame:int;
        var pCharClass:CharacterClass;
        var pXML:XML;
        var pColor:String;
        var pBulType:String;
        var pEquip:int;
        var pObjProp:ObjectProperties;
        var pProjProp:ProjectileProperties;
        var pNewUnlockArr:Array;
        var pAbsMap:AbstractMap = gs_.map;
        var pGameObj:GameObject = pAbsMap.goDict_[objStatData.objectId_];
        if (pGameObj == null) {
            return;
        }
        var boolID:Boolean = (objStatData.objectId_ == this.playerId_);
        if (_arg_2 != 0) {
            if (!boolID) {
                pGameObj.onTickPos(objStatData.pos_.x_, objStatData.pos_.y_, _arg_2, _arg_3);
            }
            else {
                pGameObj.tickPosition_.x = objStatData.pos_.x_;
                pGameObj.tickPosition_.y = objStatData.pos_.y_;
            }
        }
        var p:Player = (pGameObj as Player);
        if (p != null) {
            pLevel = p.level_;
            pExp = p.exp_;
            pSkinId = p.skinId;
            pCurrFame = p.currFame_;
        }
        this.updateGameObject(pGameObj, objStatData.stats_, boolID, _arg_2 == 0);
        if (p) {
            if (boolID) {
                pCharClass = this.classesModel.getCharacterClass(p.objectType_);
                if (pCharClass.getMaxLevelAchieved() < p.level_) {
                    pCharClass.setMaxLevelAchieved(p.level_);
                }
            }
            if (p.skinId != pSkinId) {
                if (ObjectLibrary.skinSetXMLDataLibrary_[p.skinId] != null) {
                    pXML = (ObjectLibrary.skinSetXMLDataLibrary_[p.skinId] as XML);
                    pColor = pXML.attribute("color");
                    pBulType = pXML.attribute("bulletType");
                    if (pLevel != -1 && pColor.length > 0) {
                        p.levelUpParticleEffect(parseInt(pColor));
                    }
                    if (pBulType.length > 0) {
                        p.projectileIdSetOverrideNew = pBulType;
                        pEquip = p.equipment_[0];
                        pObjProp = ObjectLibrary.propsLibrary_[pEquip];
                        pProjProp = pObjProp.projectiles_[0];
                        p.projectileIdSetOverrideOld = pProjProp.objectId_;
                    }
                }
                else {
                    if (ObjectLibrary.skinSetXMLDataLibrary_[p.skinId] == null) {
                        p.projectileIdSetOverrideNew = "";
                        p.projectileIdSetOverrideOld = "";
                    }
                }
            }
            if (pLevel != -1 && p.level_ > pLevel) {
                if (boolID) {
                    pNewUnlockArr = gs_.model.getNewUnlocks(p.objectType_, p.level_);
                    p.handleLevelUp(pNewUnlockArr.length != 0);
                    if (pNewUnlockArr.length > 0) {
                        this.newClassUnlockSignal.dispatch(pNewUnlockArr);
                    }
                }
                else {
                    if (!Parameters.data_.noAllyNotifications) {
                        p.levelUpEffect(TextKey.PLAYER_LEVELUP);
                    }
                }
            }
            else {
                if (pLevel != -1 && p.exp_ > pExp) {
                    if (boolID || !Parameters.data_.noAllyNotifications) {
                        p.handleExpUp((p.exp_ - pExp));
                    }
                }
            }
            if (Parameters.data_.showFameGain && pCurrFame != -1 && p.currFame_ > pCurrFame) {
                if (boolID) {
                    p.updateFame(p.currFame_ - pCurrFame);
                }
            }
            if (pCurrFame == -1 && p.currFame_ > pCurrFame) {
                if (boolID) {
                    Parameters.fpmGain++;
                    if (Parameters.data_.showFameGain) {
                        p.updateFame(p.currFame_ - pCurrFame);
                    }
                }
            }
            this.socialModel.updateFriendVO(p.getName(), p);
        }
    }

    private function onInvResult(_arg_1:InvResult):void {
        if (_arg_1.result_ != 0) {
            this.handleInvFailure();
        }
    }

    private function handleInvFailure():void {
        SoundEffectLibrary.play("error");
        gs_.hudView.interactPanel.redraw();
    }

    private function onReconnect(_arg_1:Reconnect):void {
        var _local_2:Server = new Server().setName(_arg_1.name_).setAddress(((_arg_1.host_ != "") ? _arg_1.host_ : server_.address)).setPort(((_arg_1.host_ != "") ? _arg_1.port_ : server_.port));
        var _local_3:int = _arg_1.gameId_;
        var _local_4:Boolean = createCharacter_;
        var _local_5:int = charId_;
        var _local_6:int = _arg_1.keyTime_;
        var _local_7:ByteArray = _arg_1.key_;
        isFromArena_ = _arg_1.isFromArena_;
        if (_arg_1.stats_) {
            this.statsTracker.setBinaryStringData(_local_5, _arg_1.stats_);
        }
        if (_local_3 == -2) {
            if (Parameters.data_.disableNexus) {
                _local_3 = -5;
            }
        }
        var _local_8:ReconnectEvent = new ReconnectEvent(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, isFromArena_);
        if (Parameters.fameBot && _arg_1.name_ == "Oryx's Castle") {
            if (Parameters.data_.fameOryx) {
                this.gs_.dispatchEvent(Parameters.reconNexus);
            }
            else {
                Parameters.fameBot = false;
            }
        }
        if (_local_8.server_.name.substr(0, 12) == "NexusPortal.") {
            if (Parameters.realmJoining) {
                if (_local_8.server_.name.substr(12).toLowerCase().indexOf(Parameters.realmName) == -1) {
                    this.gs_.dispatchEvent(new ReconnectEvent(Parameters.reconNexus.server_, Parameters.RANDOM_REALM_GAMEID, false, this.charId_, -1, null, false));
                    return;
                }
                Parameters.realmJoining = false;
            }
            Parameters.reconRealm = _local_8;
        }
        gs_.dispatchEvent(_local_8);
    }

    private function onPing(ping:Ping):void {
        var pong:Pong = (this.messages.require(PONG) as Pong);
        pong.serial_ = ping.serial_;
        pong.time_ = getTimer();
        serverConnection.sendMessage(pong);
        if (Parameters.fameBot) {
            Parameters.famePoint.x = (Parameters.famePointOffset /** RandomUtil.randomRange(0.8, 1.2)*/);
            Parameters.famePoint.y = (Parameters.famePointOffset /** RandomUtil.randomRange(0.8, 1.2)*/);
        }
        if (Parameters.data_.mapHack) {
            if (Parameters.needsMapCheck == 1) {
                if (this.gs_.hudView.miniMap.checkForMap(AssetLoader.realmMaps)) {
                    Parameters.needsMapCheck = 0;
                }
            }
        }
    }

    public static function parsePackets(_arg_1:XML = null):void {
        var _local_1:String;
        var _local_2:XML = (_arg_1 == null ? XML(new packets()) : _arg_1);
        var counter:int = 0;
        for (_local_1 in _local_2.Packet) {
            GameServerConnection[_local_2.Packet.PacketName[_local_1]] = parseInt(_local_2.Packet.PacketID[_local_1]);
            counter++;
        }
    }

    private function parseXML(_arg_1:String):void {
        var _local_2:XML = XML(_arg_1);
        GroundLibrary.parseFromXML(_local_2);
        ObjectLibrary.parseFromXML(_local_2);
    }

    private function setupReconnects(_arg_1:String):void {
        if (_arg_1 == "Nexus") {
            Parameters.reconNexus = new ReconnectEvent(new Server().setName("Nexus").setAddress(this.server_.address).setPort(this.server_.port), Parameters.NEXUS_GAMEID, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconNexus == null) {
            Parameters.reconNexus = new ReconnectEvent(new Server().setName("Nexus").setAddress(this.server_.address).setPort(this.server_.port), Parameters.NEXUS_GAMEID, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconVault == null) {
            Parameters.reconVault = new ReconnectEvent(new Server().setName("Vault").setAddress(this.server_.address).setPort(this.server_.port), Parameters.VAULT_GAMEID, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconTutor == null) {
            Parameters.reconTutor = new ReconnectEvent(new Server().setName("Tutorial").setAddress(this.server_.address).setPort(this.server_.port), Parameters.TUTORIAL_GAMEID, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconDaily == null) {
            Parameters.reconDaily = new ReconnectEvent(new Server().setName("Daily Quest Room").setAddress(this.server_.address).setPort(this.server_.port), Parameters.DAILYQUESTROOM_GAMEID, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconNexus) {
            Parameters.reconNexus.charId_ = this.charId_;
        }
        if (Parameters.reconVault) {
            Parameters.reconVault.charId_ = this.charId_;
        }
        if (Parameters.reconRealm) {
            Parameters.reconRealm.charId_ = this.charId_;
        }
        if (Parameters.reconDung) {
            Parameters.reconDung.charId_ = this.charId_;
        }
        if (Parameters.reconTutor) {
            Parameters.reconTutor.charId_ = this.charId_;
        }
        if (Parameters.reconDaily) {
            Parameters.reconDaily.charId_ = this.charId_;
        }
    }

    private function onMapInfo(_arg_1:MapInfo):void {
        var _local_2:String;
        var _local_3:String;
        Parameters.realmJoining = false;
        this.setupReconnects(_arg_1.name_);
        for each (_local_2 in _arg_1.clientXML_) {
            this.parseXML(_local_2);
        }
        for each (_local_3 in _arg_1.extraXML_) {
            this.parseXML(_local_3);
        }
        changeMapSignal.dispatch();
        this.closeDialogs.dispatch();
        gs_.applyMapInfo(_arg_1);
        Parameters.suicideMode = false;
        Parameters.suicideAT = -1;
        this.rand_ = new Random(_arg_1.fp_);
        if (Parameters.data_.famebotContinue == 0) {
            Parameters.fameBot = false;
        }
        if (Parameters.needToRecalcDesireables) {
            Parameters.setAutolootDesireables();
            Parameters.needToRecalcDesireables = false;
        }
        if (_arg_1.name_ == "Realm of the Mad God" && !Parameters.ssmode) {
            Parameters.mystics.length = 0;
        }
        Parameters.fameWaitStartTime = 0;
        Parameters.fameWaitNTTime = 0;
        Parameters.fameWalkSleep_toFountainOrHall = 0;
        Parameters.fameWalkSleep_toRealms = 0;
        Parameters.fameWalkSleep2 = 0;
        Parameters.fameWalkSleepStart = 0;
        Parameters.questFollow = false;
        Parameters.VHS = 0;
        if (createCharacter_) {
            this.create();
        } else {
            this.load();
        }
        Parameters.ignoredShotCount = 0;
        Parameters.dmgCounter.length = 0;
        Parameters.needsMapCheck = gs_.map.needsMapHack(_arg_1.name_);
    }

    private function onPic(_arg_1:Pic):void {
        gs_.addChild(new PicView(_arg_1.bitmapData_));
    }

    private function onDeath(_arg_1:Death):void {
        this.death = _arg_1;
        var _local_2:BitmapData = new BitmapData(gs_.stage.stageWidth, gs_.stage.stageHeight);
        _local_2.draw(gs_);
        _arg_1.background = _local_2;
        if (!gs_.isEditor) {
            this.handleDeath.dispatch(_arg_1);
        }
        this.checkDavyKeyRemoval();
        Parameters.Cache_CHARLIST_valid = false;
        Parameters.suicideMode = false;
        Parameters.suicideAT = -1;
        Parameters.fameBot = false;
    }

    private function onBuyResult(_arg_1:BuyResult):void {
        outstandingBuy_ = null;
        this.handleBuyResultType(_arg_1);
    }

    private function handleBuyResultType(_arg_1:BuyResult):void {
        var _local_2:ChatMessage;
        switch (_arg_1.result_) {
            case BuyResult.UNKNOWN_ERROR_BRID:
                _local_2 = ChatMessage.make(Parameters.SERVER_CHAT_NAME, _arg_1.resultString_);
                this.addTextLine.dispatch(_local_2);
                return;
            case BuyResult.NOT_ENOUGH_GOLD_BRID:
                this.openDialog.dispatch(new NotEnoughGoldDialog());
                return;
            case BuyResult.NOT_ENOUGH_FAME_BRID:
                this.openDialog.dispatch(new NotEnoughFameDialog());
                return;
            default:
                this.handleDefaultResult(_arg_1);
        }
    }

    private function handleDefaultResult(_arg_1:BuyResult):void {
        var _local_2:LineBuilder = LineBuilder.fromJSON(_arg_1.resultString_);
        var _local_3:Boolean = ((_arg_1.result_ == BuyResult.SUCCESS_BRID) || (_arg_1.result_ == BuyResult.PET_FEED_SUCCESS_BRID));
        var _local_4:ChatMessage = ChatMessage.make(((_local_3) ? Parameters.SERVER_CHAT_NAME : Parameters.ERROR_CHAT_NAME), _local_2.key);
        _local_4.tokens = _local_2.tokens;
        this.addTextLine.dispatch(_local_4);
    }

    private function onAccountList(_arg_1:AccountList):void {
        if (_arg_1.accountListId_ == 0) {
            if (_arg_1.lockAction_ != -1) {
                if (_arg_1.lockAction_ == 1) {
                    gs_.map.party_.setStars(_arg_1);
                }
                else {
                    gs_.map.party_.removeStars(_arg_1);
                }
            }
            else {
                gs_.map.party_.setStars(_arg_1);
            }
        }
        else {
            if (_arg_1.accountListId_ == 1) {
                gs_.map.party_.setIgnores(_arg_1);
            }
        }
    }

    private function onQuestObjId(_arg_1:QuestObjId):void {
        gs_.map.quest_.setObject(_arg_1.objectId_);
    }

    private function onAoe(_arg_1:Aoe):void {
        var _local_4:int;
        var _local_5:Vector.<uint>;
        if (this.player == null) {
            this.aoeAck(gs_.lastUpdate_, 0, 0);
            return;
        }
        var _local_2:AOEEffect = new AOEEffect(_arg_1.pos_.toPoint(), _arg_1.radius_, _arg_1.color_);
        gs_.map.addObj(_local_2, _arg_1.pos_.x_, _arg_1.pos_.y_);
        if (((this.player.isInvincible) || (this.player.isPaused))) {
            this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
            return;
        }
        var _local_3:Boolean = (this.player.distTo(_arg_1.pos_) < _arg_1.radius_);
        if (_local_3) {
            _local_4 = GameObject.damageWithDefense(_arg_1.damage_, this.player.defense_, false, this.player.condition_);
            _local_5 = null;
            if (_arg_1.effect_ != 0) {
                _local_5 = new Vector.<uint>();
                _local_5.push(_arg_1.effect_);
            }
            if (this.player.subtractDamage(_local_4)) {
                return;
            }
            this.player.damage(true, _local_4, _local_5, false, null);
        }
        this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
    }

    private function onNameResult(_arg_1:NameResult):void {
        gs_.dispatchEvent(new NameResultEvent(_arg_1));
    }

    private function onGuildResult(_arg_1:GuildResult):void {
        var _local_2:LineBuilder;
        if (_arg_1.lineBuilderJSON == "") {
            gs_.dispatchEvent(new GuildResultEvent(_arg_1.success_, "", {}));
        }
        else {
            _local_2 = LineBuilder.fromJSON(_arg_1.lineBuilderJSON);
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local_2.key, -1, -1, "", false, _local_2.tokens));
            gs_.dispatchEvent(new GuildResultEvent(_arg_1.success_, _local_2.key, _local_2.tokens));
        }
    }

    private function onClientStat(_arg_1:ClientStat):void {
        var _local_2:Account = StaticInjectorContext.getInjector().getInstance(Account);
        if (!Parameters.ssmode && Parameters.data_.showClientStat) {
            if (!Parameters.usingPortal) {
                this.addTextLine.dispatch(ChatMessage.make(("#" + _arg_1.name_), _arg_1.value_.toString()));
                _local_2 = StaticInjectorContext.getInjector().getInstance(Account);
                _local_2.reportIntStat(_arg_1.name_, _arg_1.value_);
            }
        }
    }

    private function onFile(_arg_1:File):void {
        new FileReference().save(_arg_1.file_, _arg_1.filename_);
    }

    private function onInvitedToGuild(_arg_1:InvitedToGuild):void {
        if (Parameters.data_.showGuildInvitePopup) {
            gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(gs_, _arg_1.name_, _arg_1.guildName_));
        }
        this.addTextLine.dispatch(ChatMessage.make("", ("You have been invited by " + _arg_1.name_ + " to join the guild " + _arg_1.guildName_ + '.\n  If you wish to join type "/join ' + _arg_1.guildName_ + '"')));
    }

    private function onPlaySound(_arg_1:PlaySound):void {
        var _local_2:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        ((_local_2) && (_local_2.playSound(_arg_1.soundId_)));
    }

    private function onImminentArenaWave(_arg_1:ImminentArenaWave):void {
        this.imminentWave.dispatch(_arg_1.currentRuntime);
    }

    private function onArenaDeath(_arg_1:ArenaDeath):void {
        this.addTextLine.dispatch(ChatMessage.make("ArenaDeath", ("Cost: " + _arg_1.cost)));
        this.currentArenaRun.costOfContinue = _arg_1.cost;
        this.openDialog.dispatch(new ContinueOrQuitDialog(_arg_1.cost, false));
        this.arenaDeath.dispatch();
    }

    private function onVerifyEmail(_arg_1:VerifyEmail):void {
        TitleView.queueEmailConfirmation = true;
        if (gs_ != null) {
            gs_.closed.dispatch();
        }
        var _local_2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
        if (_local_2 != null) {
            _local_2.dispatch();
        }
    }

    private function onPasswordPrompt(_arg_1:PasswordPrompt):void {
        if (_arg_1.cleanPasswordStatus == 3) {
            TitleView.queuePasswordPromptFull = true;
        }
        else {
            if (_arg_1.cleanPasswordStatus == 2) {
                TitleView.queuePasswordPrompt = true;
            }
            else {
                if (_arg_1.cleanPasswordStatus == 4) {
                    TitleView.queueRegistrationPrompt = true;
                }
            }
        }
        if (gs_ != null) {
            gs_.closed.dispatch();
        }
        var _local_2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
        if (_local_2 != null) {
            _local_2.dispatch();
        }
    }

    override public function questFetch():void {
        serverConnection.sendMessage(this.messages.require(QUESTFETCHASK));
    }

    private function onQuestFetchResponse(_arg_1:QuestFetchResponse):void {
        this.questFetchComplete.dispatch(_arg_1);
        if (Parameters.dailyCalendar2RunOnce) {
            this.gs_.showDailyLoginCalendar();
            Parameters.dailyCalendar2RunOnce = false;
            this.escape();
        }
    }

    private function onQuestRedeemResponse(_arg_1:QuestRedeemResponse):void {
        this.questRedeemComplete.dispatch(_arg_1);
    }

    override public function questRedeem(_arg_1:String, _arg_2:Vector.<SlotObjectData>, _arg_3:int = -1):void {
        var _local_4:QuestRedeem = (this.messages.require(QUESTREDEEM) as QuestRedeem);
        _local_4.questID = _arg_1;
        _local_4.item = _arg_3;
        _local_4.slots = _arg_2;
        serverConnection.sendMessage(_local_4);
    }

    override public function keyInfoRequest(_arg_1:int):void {
        var _local_2:KeyInfoRequest = (this.messages.require(KEYINFOREQUEST) as KeyInfoRequest);
        _local_2.itemType_ = _arg_1;
        serverConnection.sendMessage(_local_2);
    }

    private function onKeyInfoResponse(_arg_1:KeyInfoResponse):void {
        this.keyInfoResponse.dispatch(_arg_1);
    }

    private function onLoginRewardResponse(_arg_1:ClaimDailyRewardResponse):void {
        this.claimDailyRewardResponse.dispatch(_arg_1);
    }

    private function onChatToken(_arg_1:ChatToken):void
    {
        this.chatServerModel.chatToken = _arg_1.token_;
        this.chatServerModel.port = _arg_1.port_;
        this.chatServerModel.server = _arg_1.host_;
        this.addChatServerConnectionListeners();
        this.loginToChatServer();
    }

    private function addChatServerConnectionListeners():void
    {
        this.chatServerConnection.chatConnected.add(this.onChatConnected);
        this.chatServerConnection.chatClosed.add(this.onChatClosed);
        this.chatServerConnection.chatError.add(this.onChatError);
    }

    private function removeChatServerConnectionListeners():void
    {
        this.chatServerConnection.chatConnected.remove(this.onChatConnected);
        this.chatServerConnection.chatClosed.remove(this.onChatClosed);
        this.chatServerConnection.chatError.remove(this.onChatError);
    }

    private function loginToChatServer():void
    {
        this.chatServerConnection.connect(this.chatServerModel.server, this.chatServerModel.port);
    }

    private function onChatConnected():void
    {
        var _local_1:ChatHello = (this.messages.require(CHATHELLOMSG) as ChatHello);
        _local_1.accountId = this.rsaEncrypt(this.player.accountId_);
        _local_1.token = this.chatServerModel.chatToken;
        this.chatServerConnection.sendMessage(_local_1);
        if (this.chatServerConnection.isChatConnected())
        {
            this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME, "Chat Server connected"));
            this._isReconnecting = false;
        }
        else
        {
            this.chatServerConnection.isConnecting = false;
        }
    }

    private function onChatClosed():void
    {
        if (((!(this.chatServerConnection.isChatConnected())) && (this._numberOfReconnectAttempts < MAX_RECONNECT_ATTEMPTS)))
        {
            this._numberOfReconnectAttempts++;
            if (((serverConnection.isConnected()) && (!(this._isReconnecting))))
            {
                this._isReconnecting = true;
                this.removeChatServerConnectionListeners();
                this.chatServerConnection.dispose();
                this.chatServerConnection = null;
                this.chatServerConnection = this.injector.getInstance(ChatSocketServer);
                if (Parameters.ENABLE_ENCRYPTION)
                {
                    this.setChatEncryption();
                }
                this.chatServerConnection.isConnecting = true;
                this.addChatServerConnectionListeners();
                this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Chat Connection closed!  Reconnecting..."));
                this.chatReconnectTimer(10);
            }
        }
        else
        {
            this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Chat Connection closed!  Unable to reconnect - Please restart game!"));
        }
    }

    private function setChatEncryption():void
    {
        this.chatServerConnection.setOutgoingCipher(Crypto.getCipher("rc4", MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(0, 26))));
        this.chatServerConnection.setIncomingCipher(Crypto.getCipher("rc4", MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(26))));
    }

    private function onChatError(_arg_1:String):void
    {
        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _arg_1));
    }

    private function chatReconnectTimer(_arg_1:int):void
    {
        if (!this._chatReconnectionTimer)
        {
            this._chatReconnectionTimer = new Timer((_arg_1 * 1000), 1);
        }
        else
        {
            this._chatReconnectionTimer.delay = (_arg_1 * 1000);
        }
        this._chatReconnectionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onChatRetryTimer);
        this._chatReconnectionTimer.start();
    }

    private function onChatRetryTimer(_arg_1:TimerEvent):void
    {
        this._chatReconnectionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onChatRetryTimer);
        this.loginToChatServer();
    }

    private function onRealmHeroesResponse(_arg_1:RealmHeroesResponse):void
    {
        this.realmHeroesSignal.dispatch(_arg_1.numberOfRealmHeroes);
    }

    override public function petUpgradeRequest(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int):void {
        var petUpgradeReqPacket:PetUpgradeRequest = (this.messages.require(PETUPGRADEREQUEST) as PetUpgradeRequest);
        petUpgradeReqPacket.objectId = _arg_5;
        petUpgradeReqPacket.paymentTransType = _arg_1;
        petUpgradeReqPacket.petTransType = _arg_2;
        petUpgradeReqPacket.PIDOne = _arg_3;
        petUpgradeReqPacket.PIDTwo = _arg_4;
        petUpgradeReqPacket.slotsObject = new Vector.<SlotObjectData>();
        petUpgradeReqPacket.slotsObject.push(new SlotObjectData());
        petUpgradeReqPacket.slotsObject[0].objectId_ = this.playerId_;
        petUpgradeReqPacket.slotsObject[0].slotId_ = _arg_6;
        if (this.player.equipment_.length >= _arg_6) {
            petUpgradeReqPacket.slotsObject[0].objectType_ = this.player.equipment_[_arg_6];
        }
        else {
            petUpgradeReqPacket.slotsObject[0].objectType_ = -1;
        }
        this.serverConnection.sendMessage(petUpgradeReqPacket);
    }

    private function onClosed():void {
        var _local_2:HideMapLoadingSignal;
        if (this.playerId_ != -1) {
            this.logger.error("Closerino");
            gs_.closed.dispatch();
        }
        else {
            if (this.retryConnection_) {
                if (this.delayBeforeReconnect < 10) {
                    if (this.delayBeforeReconnect == 6) {
                        _local_2 = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
                        _local_2.dispatch();
                    }
                    this.retry(this.delayBeforeReconnect++);
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Connection failed!  Retrying..."));
                }
                else {
                    gs_.closed.dispatch();
                }
            }
        }
    }

    private function retry(_arg_1:int):void {
        this.retryTimer_ = new Timer((_arg_1 * 1000), 1);
        this.retryTimer_.addEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimer);
        this.retryTimer_.start();
    }

    private function onRetryTimer(_arg_1:TimerEvent):void {
        serverConnection.connect(server_.address, server_.port);
    }

    private function onError(_arg_1:String):void {
        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _arg_1));
    }

    private function onFailure(_arg_1:Failure):void {
        if (LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_).hasOwnProperty("is dead") || _arg_1.errorDescription_.hasOwnProperty("is dead")) {
            Parameters.Cache_CHARLIST_valid = false;
        }
        if (Parameters.fameBot || _arg_1.errorDescription_.indexOf("server.realm_full") != -1) {
            return;
        }
        switch (_arg_1.errorId_) {
            case Failure.INCORRECT_VERSION:
                this.handleIncorrectVersionFailure(_arg_1);
                return;
            case Failure.BAD_KEY:
                this.handleBadKeyFailure(_arg_1);
                return;
            case Failure.INVALID_TELEPORT_TARGET:
                this.handleInvalidTeleportTarget(_arg_1);
                return;
            case Failure.EMAIL_VERIFICATION_NEEDED:
                this.handleEmailVerificationNeeded(_arg_1);
                return;
            case Failure.TELEPORT_REALM_BLOCK:
                this.handleRealmTeleportBlock(_arg_1);
                return;
            default:
                this.handleDefaultFailure(_arg_1);
        }
    }

    private function handleEmailVerificationNeeded(_arg_1:Failure):void {
        this.retryConnection_ = false;
        gs_.closed.dispatch();
    }

    private function handleRealmTeleportBlock(_arg_1:Failure):void {
        this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, ("You need to wait at least " + _arg_1.errorDescription_ + " seconds before a non guild member teleport.")));
        this.player.nextTeleportAt_ = (getTimer() + (int(_arg_1.errorDescription_) * 1000));
    }

    private function handleInvalidTeleportTarget(_arg_1:Failure):void {
        var _local_2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local_2 == "") {
            _local_2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local_2));
        this.player.nextTeleportAt_ = 0;
    }

    private function handleBadKeyFailure(_arg_1:Failure):void {
        var _local_2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local_2 == "") {
            _local_2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local_2));
        this.retryConnection_ = false;
        gs_.closed.dispatch();
    }

    private function handleIncorrectVersionFailure(_arg_1:Failure):void {
        Parameters.data_.gameVersion = _arg_1.errorDescription_;
        Parameters.save();
        var _local_2:Dialog = new Dialog(TextKey.CLIENT_UPDATE_TITLE, "", TextKey.CLIENT_UPDATE_LEFT_BUTTON, null);
        _local_2.setTextParams(TextKey.CLIENT_UPDATE_DESCRIPTION, {
            "client": Parameters.data_.gameVersion,
            "server": _arg_1.errorDescription_
        });
        _local_2.addEventListener(Dialog.LEFT_BUTTON, this.onDoClientUpdate);
        gs_.stage.addChild(_local_2);
        this.retryConnection_ = false;
    }

    private function handleDefaultFailure(_arg_1:Failure):void {
        var _local_2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local_2 == "") {
            _local_2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, _local_2));
        if (Parameters.fameBot) {
            if (_local_2.indexOf("Lost connection") != -1) {
                if (Parameters.reconRealm != null) {
                    this.gs_.dispatchEvent(Parameters.reconRealm);
                }
            }
        }
    }

    private function onDoClientUpdate(_arg_1:Event):void {
        var _local_2:Dialog = (_arg_1.currentTarget as Dialog);
        _local_2.parent.removeChild(_local_2);
        gs_.closed.dispatch();
    }

    override public function isConnected():Boolean {
        return (serverConnection.isConnected());
    }

    override public function reskin(_arg_1:Player, _arg_2:int):void {
        var _local_3:Reskin = (this.messages.require(RESKIN) as Reskin);
        _local_3.skinID = _arg_2;
        _local_3.player = _arg_1;
        serverConnection.sendMessage(_local_3);
    }


}
}//package kabam.rotmg.messaging.impl

