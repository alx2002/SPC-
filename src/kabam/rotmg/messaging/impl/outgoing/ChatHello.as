﻿// Decompiled by AS3 Sorcerer 5.88
// www.as3sorcerer.com

//kabam.rotmg.messaging.impl.outgoing.ChatHello

package kabam.rotmg.messaging.impl.outgoing
{
    import flash.utils.IDataOutput;

    public class ChatHello extends OutgoingMessage 
    {

        public var accountId:String;
        public var token:String;

        public function ChatHello(_arg_1:uint, _arg_2:Function)
        {
            super(_arg_1, _arg_2);
        }

        override public function writeToOutput(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.accountId);
            _arg_1.writeUTF(this.token);
        }

        override public function toString():String
        {
            return (formatToString("CHATHELLO", "accountId", "token"));
        }


    }
}//package kabam.rotmg.messaging.impl.outgoing

