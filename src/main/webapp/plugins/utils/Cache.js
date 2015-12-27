/**
 * Created by 浩 on 2015-12-14 0014.
 */

define(function (require, exports, module) {
    var store = $.AMUI.store;

    if (!store.enabled) {
        alert('Local storage is not supported by your browser. Please disable "Private Mode", or upgrade to a modern browser.');
        return;
    }
});


