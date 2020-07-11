String APP = '20200621';

String SERVER = 'http://x.xxx.xxx/xxxx';

String PUSH = r'''
{
    "flag": "关",
    "force": "是",
    "info": "抱歉，当前版本飞鱼已停用，请关注公众号“乂乂又又”，回复“飞鱼”，获取最新版本！",
    "about": "飞鱼是本人兴趣爱好之作，发布纯粹是开源分享、仅供学习交流。本软件不得用于商业用途或从事违反中国人民共和国相关法律所禁止的活动，本人对于用户擅自使用本软件从事违法活动不承担任何责任（包括但不限于刑事责任、行政责任、民事责任）。若您继续使用本软件则表明您已完全阅读理解并同意上述约定，否则请立即关闭并卸载本软件。 想要了解更多信息，请关注我的公众号：乂乂又又。"
}
''';

String PLAYER = r'''
{
    "server": "https://www.dplayer.tv/dp/",
    "title": "title",
    "m3u8": "url",
    "public": "是"
}
''';

String SITES = r'''
[{
        "name": "OK",
        "server": "http://www.apiokzy.com/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)</a>",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "http://cj.okzy.tv/inc/api.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    },
    {
        "name": "永久",
        "server": "http://www.yongjiuzy.vip/",
        "title": "<td class=\"l\"><a href=\".*?\" target=\"_blank\">(.*?)<font",
        "link": "<td class=\"l\"><a href=\"(.*?html)\"",
        "desp": "<!--简介开始-->(.*?)<!--简介结束-->",
        "xml": "http://cj.yongjiuzyw.com/inc/api.php",
        "item": "",
        "m3u8": "name=\"copy_sel\" value=\"(.*?\\.m3u8?)\" checked=\"\">",
        "cover": "<!--图片开始--><img src=\"(.*?)\"/><!--图片结束-->"
    },
    {
        "name": "最大",
        "server": "http://www.zuidazy5.com/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)<",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "http://www.zdziyuan.com/inc/api_zuidam3u8.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    },
    {
        "name": "酷播",
        "server": "http://kubozy.co/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)</a>",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "http://api.kbzyapi.com/inc/api.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    },
    {
        "name": "最新",
        "server": "http://www.zuixinzy.net/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)</a>",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "http://api.zuixinapi.com/inc/api.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    },
    {
        "name": "卧龙",
        "server": "http://www.apiokzy.com/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)</a>",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "http://cj.wlzy.tv/inc/api_mac_m3u8.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    },
    {
        "name": "麻花",
        "server": "http://www.mahuazy.net/",
        "title": "<span class=\"xing_vb4\">.*?target=\"_blank\">(.*?)</a>",
        "link": "<span class=\"xing_vb4\"><a href=\"(.*?)\"",
        "desp": "<div class=\"vodplayinfo\">(.*?)</div>",
        "xml": "https://www.mhapi123.com/inc/api_all.php",
        "item": "",
        "m3u8": "name=\"copy_sel.*>(.*\\$http.*?m3u8)",
        "cover": "<img class=\"lazy\" src=\"(.*?)\" alt"
    }
]
''';

String MOVIES = '''
[{
        "title": "你的婚礼",
        "desp": "她喜欢他，他爱她，他们最终没能在一起。都说，爱错了是青春，爱对了是爱情。而最后都不及一句，谢谢你，让我认识你，成全了我自己。",
        "cover": "https://img3.doubanio.com/view/photo/l/public/p2528205132.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://sohu.com-v-sohu.com/20180927/13039_830bbefc/index.m3u8"
        }]
    },
    {
        "title": "升级",
        "desp": "赛博朋克复古风格、人体生化改造的概念、眩晕急促的动作戏运镜（非常想知道这些镜头是如何实现的）和血腥不留情的复仇故事结合得很酷炫，在有限的成本与格局下也保持住了较高的完成度。支持一下雷导，脱离了温子仁以后总算有一部属于自己的代表作了，不过找Jamie的那场戏出现了《电锯惊魂》的彩蛋不知道大家发现没有...",
        "cover": "https://img9.doubanio.com/view/photo/l/public/p2531034314.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://sina.com-h-sina.com/20180816/10398_6a054900/index.m3u8"
        }]
    },
    {
        "title": "星际穿越",
        "desp": "时间可以伸缩和折叠，唯独不能倒退。你的鹤发或许是我的童颜，而我一次呼吸能抵过你此生的岁月",
        "cover": "https://img1.doubanio.com/view/photo/l/public/p2207216219.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://youku.com-youku.com/20180101/0ZIlTs7o/index.m3u8"
        }]
    },
    {
        "title": "兰戈",
        "desp": "水準極高的動畫片 用動畫模式向象徵美國的西部牛仔魂致敬，更是一絕。 一條公路，劃出夢想與現實的兩面，追逐夢想，需要的是信仰、信念，最重要的是要相信自己！",
        "cover": "https://img3.doubanio.com/view/photo/l/public/p1000880652.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://vip.okokbo.com/20171228/R7rd0pHN/index.m3u8"
        }]
    }, 
    {
        "title": "釜山行",
        "desp": "一切灾难皆人性，唉，最后那一枪要是开了，就是神作了。",
        "cover": "https://img1.doubanio.com/view/photo/l/public/p2360940399.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://tudou.com-l-tudou.com/20180417/8646_050146f2/index.m3u8"
        }]
    },
    {
        "title": "爆裂鼓手",
        "desp": "燃！爆！了！相信每个练过乐器，或者在艺术表演方面付出过汗水的人都能找到深刻的共鸣，那种对严师又敬又怕，想汲取他们的能量却感受被逼至悬崖的窒息感，想在技术上完美再完美一点却发现音乐远不止这些的惊喜与恐惧... 片子就像里面的爵士乐，是肾上腺素爆发的血汗结晶，它不完美却无可取代",
        "cover": "https://img3.doubanio.com/view/photo/l/public/p2220776342.webp",
        "playlist": [{
            "name": "HD高清",
            "m3u8": "http://ifeng.com-v-ifeng.com/20180719/23051_f0a70139/index.m3u8"
        }]
    }
]
''';
