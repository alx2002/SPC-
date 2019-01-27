//com.company.util.MoreStringUtil

package com.company.util {
import flash.utils.ByteArray;

public class MoreStringUtil {


    public static function hexStringToByteArray(_arg_1:String):ByteArray {
        var _local_2:ByteArray = new ByteArray();
        var _local_3:int;
        while (_local_3 < _arg_1.length) {
            _local_2.writeByte(parseInt(_arg_1.substr(_local_3, 2), 16));
            _local_3 = (_local_3 + 2);
        }
        return (_local_2);
    }

    public static function cmp(_arg_1:String, _arg_2:String):Number {
        return (_arg_1.localeCompare(_arg_2));
    }

    public static function countCharInString(_arg_1:String, _arg_2:String):int {
        var _local_4:uint;
        var _local_3:int;
        _local_4 = 0;
        while (_local_4 < _arg_1.length) {
            if (_arg_1.charAt(_local_4) == _arg_2) {
                _local_3++;
            }
            _local_4++;
        }
        return (_local_3);
    }

    public static function levenshtein(_arg_1:String, _arg_2:String):int {
        var num:int;
        var counter1:int;
        var counter2:int;
        var arr:Array = [];
        while (counter2 <= _arg_1.length) {
            arr[counter2] = [];
            counter1 = 0;
            while (counter1 <= _arg_2.length) {
                if (counter2 != 0) {
                    arr[counter2].push(0);
                }
                else {
                    arr[counter2].push(counter1);
                }
                counter1++;
            }
            arr[counter2][0] = counter2;
            counter2++;
        }
        counter2 = 1;
        while (counter2 <= _arg_1.length) {
            counter1 = 1;
            while (counter1 <= _arg_2.length) {
                if (_arg_1.charAt((counter2 - 1)) == _arg_2.charAt((counter1 - 1))) {
                    num = 0;
                }
                else {
                    num = 1;
                }
                arr[counter2][counter1] = Math.min((arr[(counter2 - 1)][counter1] + 1), (arr[counter2][(counter1 - 1)] + 1), (arr[(counter2 - 1)][(counter1 - 1)] + num));
                counter1++;
            }
            counter2++;
        }
        return (arr[_arg_1.length][_arg_2.length]);
    }


}
}//package com.company.util

