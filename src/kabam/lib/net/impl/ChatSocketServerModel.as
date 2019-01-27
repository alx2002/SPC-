﻿// Decompiled by AS3 Sorcerer 5.88
// www.as3sorcerer.com

//kabam.lib.net.impl.ChatSocketServerModel

package kabam.lib.net.impl
{
    public class ChatSocketServerModel 
    {

        private const CONNECTION_DELAY:int = 1000;

        private var _chatToken:String;
        private var _port:int;
        private var _server:String;
        private var _connectDelayMS:int;


        public function get chatToken():String
        {
            return (this._chatToken);
        }

        public function set chatToken(_arg_1:String):void
        {
            this._chatToken = _arg_1;
        }

        public function get port():int
        {
            return (this._port);
        }

        public function set port(_arg_1:int):void
        {
            this._port = _arg_1;
        }

        public function get server():String
        {
            return (this._server);
        }

        public function set server(_arg_1:String):void
        {
            this._server = _arg_1;
        }

        public function get connectDelayMS():int
        {
            return ((this._connectDelayMS == 0) ? this.CONNECTION_DELAY : this._connectDelayMS);
        }

        public function set connectDelayMS(_arg_1:int):void
        {
            this._connectDelayMS = _arg_1;
        }


    }
}//package kabam.lib.net.impl

