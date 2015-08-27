
/*---------iOS- 启动-----------------------*/
var resized = false;

var checkInit = setInterval(function() {
    if (!resized) {
        initPage();
        clearInterval(checkInit);
    }
},200);



