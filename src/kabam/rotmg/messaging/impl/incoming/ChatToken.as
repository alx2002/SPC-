﻿// Decompiled by AS3 Sorcerer 5.88
// www.as3sorcerer.com

//kabam.rotmg.messaging.impl.incoming.ChatToken

package kabam.rotmg.messaging.impl.incoming
{
    import flash.utils.IDataInput;

    public class ChatToken extends IncomingMessage 
    {

        public var token_:String;
        public var host_:String;
        public var port_:int;

        public function ChatToken(_arg_1:uint, _arg_2:Function)
        {
            super(_arg_1, _arg_2);
        }

        override public function parseFromInput(_arg_1:IDataInput):void
        {
            this.token_ = _arg_1.readUTF();
            this.host_ = _arg_1.readUTF();
            this.port_ = _arg_1.readInt();
        }

        override public function toString():String
        {
            return (formatToString("CHAT_TOKEN", "token_", "host_", "port_"));
        }


    }
}//package kabam.rotmg.messaging.impl.incoming

