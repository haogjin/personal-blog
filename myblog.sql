/*
Navicat MySQL Data Transfer

Source Server         : myblog
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : myblog

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2018-06-06 11:59:20
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` varchar(32) DEFAULT NULL,
  `user_name` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `directionId` varchar(20) NOT NULL,
  `categoryId` varchar(20) NOT NULL,
  `content` longtext NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `open_count` bigint(20) DEFAULT '0',
  `summary` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES ('36', '98bcc97948fa11e8b37f6045cb5f24c6', 'Aimee', '微信小程序仿豆瓣电影页面demo（1）--底部导航tab切换', '10000', '1000', '大家好，决定在这里码码字，写写文章啦，希望和大家一起交流分享~\n\n最近在学习微信小程序，在这里记录下学习到的知识点，欢迎大家指正~\n\n![](http://upload-images.jianshu.io/upload_images/10954635-f14e982c9670a2cc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n## 一、项目最终效果展示\n\n![](http://upload-images.jianshu.io/upload_images/10954635-32a4817d04d91e71.gif?imageMogr2/auto-orient/strip)\n\ngithub地址：https://github.com/haogjin/Douban-Movie/tree/master\n\n注：\n1. 这里主要展示\"热映\"界面效果，其中\"找片\"和\"我的\"界面效果没有展示，\"找片\"的效果与\"热映\"基本技术操作是一样的。\n2. 主要知识点：flex布局、可滚动视图组件scroll-view、自定义组件（调用及传值）。\n\n## 二、开始开发项目\n\n#### 环境搭建\n\n创建自己的第一个小程序只需要2步即可：1.申请账号，2.安装开发者工具。\n这里就不多说啦，传送门：https://mp.weixin.qq.com/debug/wxadoc/dev/ \n\n#### 项目结构说明\n\n整体项目结构：\n\n![](http://upload-images.jianshu.io/upload_images/10954635-8695e939816a2c18.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n说明（这里只做简要说明，具体在后面讲解）：\n>1. conponents--自定义组件文件夹\n>2. images--图片文件夹\n>3. pages--页面文件夹  所有的页面都放在pages文件夹下，每个页面包括 .js（js文件）、  .wxml（页面模板文件，相当于h5的html文件） 、 .wxss（页面样式文件，相当于h5的css文件）、  .json文件（页面配置文件）；pages文件夹下的index（首页）和logs（日志）文件夹是搭建环境时自动生成的，但本项目没使用到这个页面，请知悉。\n>4. styles--公共样式文件夹\n>5. utils--公共js文件 \n>6. app.js--项目入口文件\n>7. app.json--小程序全局配置文件\n>8. app.wxss--全局样式文件 如果有共同使用的样式文件可以写在这个文件里，当然也可以自己创建样式文件进行引用。\n>9. project.config.json--工具配置 每个项目的根目录都会生成一个 project.config.json，用于保存当前项目的所有配置，保证载入项目的时候同步开发项目时的个性化配置。\n\n#### 开始开发\n一、实现底部tab页\n一共包含3个tab页：热映、找片、我的。\n1.在pages文件夹下建立home、finding、user文件夹，并分别创建相应文件。\n\n![](http://upload-images.jianshu.io/upload_images/10954635-c2e5852cc50dbd08.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n2.在app.json文件中配置新建的三个文件的路径。\n\n![](http://upload-images.jianshu.io/upload_images/10954635-06bb0d3b3fc18cea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n说明：\n  1)所有新增的页面都必须在pages里面注册，否则无法显示，建议新建一个页面立即在pages里面注册，以免忘记。这里pages是一个数组，第一个元素即为当前显示的页面。\n  2)在app.json文件的pages中注册后的相应.js文件需要定义相应的Page:\n```\nPage({\n  data: {\n\n  },\n  onLoad: function (options) {\n\n  },\n  onReady: function () {\n\n  },\n  onShow: function () {\n\n  },\n  onHide: function () {\n\n  },\n  onUnload: function () {\n\n  }\n  //.....\n})\n```\n可以参照环境搭建好之后生成的index.js代码，在其中可以定义属性和事件，具体后续会讲解。\n\n3)window字段说明：用于配置小程序所有页面的顶部背景颜色，文字颜色等，这里用到的属性说明：\n> backgroundTextStyle ： 下拉背景字体、loading 图的样式，仅支持 dark/light\n> navigationBarBackgroundColor ：导航栏背景色\n> navigationBarTitleText：导航栏标题\n> navigationBarTextStyle：导航栏标题颜色，仅支持 black/white\n\n注：注册保存后相应文件夹就会自动生成对应页面的.json文件，可以对当前页面进行局部配置，当然也可以手动新建。\n3. 在app.json中配置tab\n\n```javascript\n \"tabBar\": {\n    \"backgroundColor\": \"#dfdfdf\",\n    \"color\": \"#8a8a8a\",\n    \"selectedColor\": \"#000000\",\n    \"list\": [\n      {\n        \"text\": \"热映\",\n        \"iconPath\": \"images/ing.png\",\n        \"selectedIconPath\": \"images/ing-active.png\",\n        \"pagePath\": \"pages/home/home\"\n      },\n      {\n        \"text\": \"找片\",\n        \"iconPath\": \"images/find.png\",\n        \"selectedIconPath\": \"images/find-active.png\",\n        \"pagePath\": \"pages/finding/finding\"\n      },\n      {\n        \"text\": \"我的\",\n        \"iconPath\": \"images/user.png\",\n        \"selectedIconPath\": \"images/user-active.png\",\n        \"pagePath\": \"pages/user/user\"\n      }\n    ]\n  }\n```\n说明：\n>1. 三个tab项需要放置于list数组中。\n>2. color表示文本颜色，selectedColor表示选中文本的颜色。\n>3. iconPath表示位于text上方的图标路径，selectedIconPath表示选中tab的图标路径。\n>4. 图标库推荐： [*Icon**font*-阿里巴巴矢量图标库](https://www.sogou.com/link?url=DSOYnZeCC_okpKbDOhLALe0Qj-_pT8Br)\n\n\n完整的app.json文件：（\"debug\":true表示开启调试模式）\n```javascript\n{\n  \"pages\":[\n    \"pages/home/home\",\n    \"pages/finding/finding\", \n    \"pages/user/user\", \n    \"pages/index/index\",\n    \"pages/logs/logs\"\n  ],\n  \"window\":{\n    \"backgroundTextStyle\":\"light\",\n    \"navigationBarBackgroundColor\": \"#dfdfdf\",\n    \"navigationBarTitleText\": \"豆瓣电影\",\n    \"navigationBarTextStyle\":\"black\"\n  },\n  \"tabBar\": {\n    \"backgroundColor\": \"#dfdfdf\",\n    \"color\": \"#8a8a8a\",\n    \"selectedColor\": \"#000000\",\n    \"list\": [\n      {\n        \"text\": \"热映\",\n        \"iconPath\": \"images/ing.png\",\n        \"selectedIconPath\": \"images/ing-active.png\",\n        \"pagePath\": \"pages/home/home\"\n      },\n      {\n        \"text\": \"找片\",\n        \"iconPath\": \"images/find.png\",\n        \"selectedIconPath\": \"images/find-active.png\",\n        \"pagePath\": \"pages/finding/finding\"\n      },\n      {\n        \"text\": \"我的\",\n        \"iconPath\": \"images/user.png\",\n        \"selectedIconPath\": \"images/user-active.png\",\n        \"pagePath\": \"pages/user/user\"\n      }\n    ]\n  },\n  \"debug\":true\n}\n```\n到这里tab页面切换就完成啦，是不是很简单~~~\n\n为了验证正确性，分别编辑home.wxml、finding.wxml、user.wxml文件：\n```\n/* <view>标签表示视图容器，相当于<div>标签 */\n/* home.wxml */\n<view class=\"fa fa-book\">热映界面</view>\n\n/* finding.wxml */\n<view class=\"fa fa-eye\">找片界面</view>\n\n/* user.wxml */\n<view class=\"fa fa-user\">用户界面</view>\n```\n其中 class=\"fa fa-user\" 表示引入font Awesome图标，引入方法：https://www.jianshu.com/p/936e3f09e217。\n当然也是可以引用iconfont字体的，看个人选择~\n\n对应的界面：\n\n![home.png](http://upload-images.jianshu.io/upload_images/10954635-d2134613ea396e03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n![finding.png](http://upload-images.jianshu.io/upload_images/10954635-8998f23e4d66f5a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n![user.png](http://upload-images.jianshu.io/upload_images/10954635-71c8ca8895277f58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n当然也可以加入各种样式，方式与h5基本没区别。\n\n今天就先到这里啦~\n\n接着会抓取豆瓣电影数据展示电影正在热映和即将上映列表及详情，如果文中有什么不对的或者需要注意的地方欢迎大家指正，一起分享交流~\n接下文 微信小程序仿豆瓣电影页面demo（2）--实现\"正在热映\"与\"即将上映\"切换：\n https://www.jianshu.com/p/0eff6f592d53\n\n\n版权声明：本文为作者原创文章，未经允许不得转载。如需转载，请联系作者并标明出处及原链接！', '2018-04-24 17:59:27', '2018-06-06 09:30:55', '1', '主要介绍怎么实现底部导航切换');
INSERT INTO `articles` VALUES ('37', '9a91945d48fa11e8b37f6045cb5f24c6', 'Aimee', '微信小程序仿豆瓣电影页面demo（2）--实现\"正在热映\"与\"即将上映\"tab切换', '10000', '1000', '\n![](https://upload-images.jianshu.io/upload_images/10954635-1dc8b8780c7349b0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n接着上文继续~（上文地址：https://www.jianshu.com/p/64c2ca4f1d92）\n要完成的页面效果：\n![tab切换.gif](http://upload-images.jianshu.io/upload_images/10954635-af24ee468fe81f8d.gif?imageMogr2/auto-orient/strip)\n\n\n####一、 \"正在热映\"与\"即将上映\"tab切换\n1. 编辑home.wxml文件：\n```\n <view class=\"page\">\n  <view class=\"nav\">\n    <view class=\"{{homeSelected?\'current\':\'default\'}}\" bindtap=\"handleHomeSelected\">正在热映</view>\n    <view class=\"{{comingSelected?\'current\':\'default\'}}\" bindtap=\"handleComingSelected\">即将上映</view>\n  </view>\n  <view class=\"{{homeSelected?\'show\':\'hidden\'}}\">\n   <view class=\"nav-text\">正在热映</view>\n  </view>\n  <view class=\"{{comingSelected?\'show\':\'hidden\'}}\">\n   <view class=\"nav-text\">即将</view>\n  </view> \n</view> \n```\n通过bindtap绑定点击事件控制显示与隐藏，tap表示手指触摸后马上离开， 绑定事件的key以bind或catch开头，然后跟上事件的类型，如bindtap、catchtap等，区别在于bind事件绑定不会阻止冒泡事件向上冒泡，catch事件绑定可以阻止冒泡事件向上冒泡，可以自己写个小demo测试下。微信小程序事件详见官方文档：https://mp.weixin.qq.com/debug/wxadoc/dev/framework/view/wxml/event.html\n2. 编辑home.js文件\n```\nPage({\n  data: {\n    homeSelected:true,\n    comingSelected:false\n  },\n  handleHomeSelected(e){\n    this.setData({\n      homeSelected: true,\n      comingSelected: false\n    })\n  },\n  handleComingSelected(e) {\n    this.setData({\n      homeSelected: false,\n      comingSelected: true\n    })\n  }\n})		\n```\n在data中定义homeSelected与comingSelected属性，初始化homeSelected为true(即选中正在热映)；绑定事件中通过this.setData({ //... })方式改变data当中的值，与react写法相似。\n3. 编辑home.wxss样式文件\n```\n.nav{\n  width:100%;\n  height:80rpx;\n  display:flex;\n  position:fixed;\n  top:0;\n  left:0;\n  background-color: #ffffff;\n  z-index: 999;\n}\n.default,.current{\n  height:100%;\n  line-height:80rpx;\n  width:50%;\n  text-align:center;\n  border-bottom:1px solid #dfdfdf; \n}\n.current{\n   border-bottom:2px solid #000000;\n}\n.show{\n  display:block;\n}\n.hidden{\n  display:none;\n}\n.nav-text{\n  margin-top:80rpx;\n}\n```\nrpx单位是微信小程序中css的尺寸单位，rpx可以根据屏幕宽度进行自适应。规定屏幕宽为750rpx。比如在 iPhone6 上，屏幕宽度为375px，共有750个物理像素，则750rpx = 375px = 750物理像素，1px = 2rpx;\n采用flex布局，由于电影列表会向下翻页，tab导航设置position:fixed;固定布局， \"正在热映\"与\"即将上映\"宽度各占50%。\n\n未完待续，接着会调用豆瓣接口获取电影列表~\n如果文中有什么不对的或者需要注意的地方欢迎大家指正，一起分享交流~\n接下文 微信小程序仿豆瓣电影页面demo（3）--获取电影列表：\nhttps://www.jianshu.com/p/4734a162ccff\n\n本文著作权归作者所有，如需转载，请联系本人并标明出处及原链接。\n\n\n', '2018-04-24 17:59:54', '2018-06-06 09:31:15', '2', '实现页面\"正在热映\"与\"即将上映\"tab切换');
INSERT INTO `articles` VALUES ('38', '9c508a2148fa11e8b37f6045cb5f24c6', 'Aimee', '微信小程序仿豆瓣电影页面demo（3）--获取电影列表（自定义组件及传值）', '10000', '1000', '![](https://upload-images.jianshu.io/upload_images/10954635-1dc8b8780c7349b0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n接着上文继续~（上文地址：https://www.jianshu.com/p/0eff6f592d53）\n分析：\"正在热映\"和\"即将上映\"的电影列样式基本一致，只是数据不一致，因此考虑以自定义组件的方式实现一个共同页面，供二者使用。\n####自定义组件\n1. 创建components文件夹，创建新的页面movieList，如下图所示：\n![](https://upload-images.jianshu.io/upload_images/10954635-42bb506c2897e8b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n由于movieList是一个组件，需要在movieList.json中配置如下代码：\n```\n{\n  \"component\": true\n}\n```\n2. movieList组件是用于home页面中的，在home.json中注册这个组件，代码如下：\n```\n{\n  \"usingComponents\": {\n    \"movieList\": \"../../components/movieList/movieList\"\n  }\n}\n```\n3. 配置完以上之后就可以在home页面调用了，home.wxml代码如下：\n```\n <view class=\"page\">\n  <view class=\"nav\">\n    <view class=\"{{homeSelected?\'current\':\'default\'}}\" bindtap=\"handleHomeSelected\">正在热映</view>\n    <view class=\"{{comingSelected?\'current\':\'default\'}}\" bindtap=\"handleComingSelected\">即将上映</view>\n  </view>\n  <view class=\"{{homeSelected?\'show\':\'hidden\'}}\">\n    <!-- 正在热映 -->\n     <movieList id=\"movieList\" sendValue=\"{{movieType}}\"></movieList> \n  </view>\n  <view class=\"{{comingSelected?\'show\':\'hidden\'}}\">\n      <!-- 即将上映 -->\n     <movieList id=\"movieComingList\" sendValue=\"{{movieType}}\"></movieList>   \n  </view> \n</view> \n```\nid代表唯一标志值，可以取到这个组件；value表示传到movieList页面的参数key，名称可以自定义\n4. 组件中的方法、属性使用以及获取传递过来的参数\n```\nComponent({\n  properties: {\n    \'sendValue\':{ //与home.wxml中的key值对应\n      type: String, //必填，属性类型，包括：String, Number, Boolean, Object, Array, null（表示任意类型）\n      value: \"\" , //属性初始值\n      observer: function (newVal, oldVal) { //属性值被更改时的响应函数\n         //...\n      }\n    }\n  },\n  data: {\n    //...\n  },\n  methods: {\n    //...\n  }\n})\n```\n获取传递过来的参数：this.properties.sendValue\n####获取电影列表\n1. 编辑movieList.wxml\n```\n <view class=\"page\">\n  <block wx:if=\"{{showLoading}}\">\n      <view class=\"page-loading\">\n        <image class=\"loading-img\" src=\"../../images/loading.gif\" />\n        <text>玩命加载中...</text>\n      </view>\n    </block>\n  <block wx:else>\n    <scroll-view style=\"height:1100px;\" scroll-y=\"{{true}}\" scroll-top=\"0\" \n    bindscrolltolower=\"handleScrollToLower\">\n      <block wx:for=\"{{list}}\" wx:key=\"{{index}}\">\n        <view class=\"list\" data-id=\"{{item.id}}\" bindtap=\"handleRedirect\">\n          <view class=\"left\">\n            <image src=\"{{item.images.large}}\" />\n          </view>\n          <view class=\"middle\">\n            <view class=\"row row-title\">\n              {{item.original_title}}\n            </view>\n            <view class=\"row row-content\">\n              评分：{{item.rating.average}}\n            </view>\n            <view class=\"row row-content\">\n              导演：<view wx:for=\"{{item.directors}}\" wx:for-item=\"directors\" wx:key=\"{{index}}\">\n                {{directors.name}}\n              </view>\n            </view>\n            <view class=\"row row-content\">\n              主演：<view wx:for=\"{{item.casts}}\" wx:for-item=\"casts\" wx:key=\"{{index}}\">\n                {{casts.name}} <text wx:if=\"{{index+1-item.casts.length < 0}}\">/</text>\n              </view>\n            </view>  \n          </view>\n          <view class=\"right right-content\">\n            <text>{{item.reviews_count}}人看过</text>\n            <button class=\"right-content-btn\" bindtap=\"handleBuyTicket\">购票</button>   \n          </view>\n        </view>\n      </block>\n      \n      <block wx:if=\"{{showMore}}\">\n        <view class=\"page-loading\">\n            <image class=\"loading-img\" src=\"../../images/loading.gif\" />\n            <text>玩命加载中...</text>\n          </view>\n      </block>\n      <block wx:else>\n        <view class=\"page-loading\">\n           <text>没有更多内容了</text> \n        </view>\n      </block>\n    </scroll-view>\n  </block>    \n </view>\n ```\n2. 编写样式文件movieList.wxss\n\n\"正在热映\"和\"即将上映\"的样式相同，创建一个styles文件夹，再创建公共样式文件movieLayout.wxss，代码如下：\n```\n.list{\n  display:flex;\n  border-bottom: 1px solid #dfdfdf;\n}\n.left{\n  width:25%;\n  margin-left:20rpx\n}\n.left image{\n  width:100%;\n  height:280rpx;\n}\n.middle{\n  width:55%; \n  margin-right:20rpx \n}\n.right{\n  width:20%;\n}\n.left,.middle,.right{\n  height:280rpx;\n  margin-bottom:20rpx;\n  margin-top:20rpx;\n}\n.row{\n   width:100%; \n   margin:0 5rpx 5rpx 15rpx;  \n}\n.row-title{\n  font-size:15px;\n  font-weight: bold;\n}\n.row-content,.right-content,.right-content-btn{\n   font-size:12px;\n}\n.row view{\n  display: inline-block;\n  padding-right:5rpx;\n}\n.right-content{\n    color:#F76D61;\n    margin-right:10rpx;\n}\n.right-content-btn{\n  border: 1px solid #F76D61;\n  color:#F76D61;\n  margin-top:20rpx;\n  margin-left:0;\n  width:130rpx;\n  height:55rpx;\n  line-height:55rpx;\n  background-color: #ffffff;\n}\n\n```\n\n在movieList.wxss文件中引入公共样式movieLayout.wxss：\n```\n@import \"../../styles/movieLayout\";\n\n.page{\n  margin-top:80rpx;\n  height:100%;\n}\n.page-loading{\n  display:flex;\n  text-align: center;\n  justify-content: center;\n  align-items: center;\n  padding-top:10rpx;\n}\n.page-loading .loading-img{\n  margin-right:5rpx;\n  width:30rpx;\n  height:30rpx;\n}\n.sv{\n  height:1000rpx;\n}\n```\n3. 编写样式文件movieList.js\n\n这里需要访问接口获取数据， 在utils文件夹下建立api.js，封装访问接口的方法，获取数据，代码如下：\n```\nvar API_URL = \'http://t.yushu.im/v2/movie\';\n\nfunction fetchApi(type,params){\n  return new Promise((resolve,reject)=>{\n    wx.request({\n      url: `${API_URL}/${type}`, //模板字符串\n      data: params,\n      header: {\n        \'content-type\': \'application/json\' \n      },\n      success: resolve,\n      fail: reject\n    })\n  })\n}\n\n//http://t.yushu.im//v2/movie/in_theaters?start=0&count=20\nmodule.exports = {\n  //获取电影列表\n  getList(type,start=0,count=20){\n    return fetchApi(type, {\"start\": start*count,\"count\":count})\n      .then(res=>res.data)\n  },\n  //获取电影详情\n  getDetail(id){\n    return fetchApi(\"/subject/\"+id)\n      .then(res=>res.data)\n  }\n}\n```\nmovieList.js代码：\n```\nvar api = require(\'../../utils/api\')\n\nComponent({\n  properties: {\n    \'sendValue\':{\n      type: String, //必填，目前接受的类型包括：String, Number, Boolean, Object, Array, null（表示任意类型）\n      value: \"\" , \n      observer: function (newVal, oldVal) {\n        this.setData({\n          list: [],//电影列表\n          start: 0\n        })\n      }\n    }\n  },\n  data: {\n    start: 0,\n    list: [],\n    showLoading: true,\n    showMore: true\n  },\n  methods: {\n    loadData(start) {\n      console.log(this.properties.sendValue) \n      //http://t.yushu.im/v2/movie/in_theaters?start=0&count=20\n      api.getList(this.properties.sendValue, start)\n        .then(res => {\n          if (res.subjects.length > 0) {\n            this.setData({\n              list: this.data.list.concat(res.subjects),//连接前面一页的数据\n              showLoading: false,\n              showMore: true,\n              start: start + 1 //页数递增\n            })\n          } else {\n            this.setData({\n              showMore: false\n            })\n          }\n        })\n    },\n    handleScrollToLower(e) {\n      //如果没有更多的数据就不再加载\n      if (!this.data.showMore) {\n        return;\n      }\n      this.loadData(this.data.start);\n    },\n    handleRedirect(e) {\n      var id = e.currentTarget.dataset.id;\n      //电影详情页面跳转并传入当前id值 下一篇文章会详细讲解 这里的代码现在可以注释\n      wx.navigateTo({\n        url: \'../../pages/detail/detail?id=\' + id,\n      })\n    },\n    handleBuyTicket(e){\n      console.log(\"点击了购票按钮\");\n    },\n  }\n})\n```\n4. 在home.wxml中引入movieList.wxml组件，并在home.js中调用加载列表数据的方法。\n\nhome.wxml：\n```\n <view class=\"page\">\n  <view class=\"nav\">\n    <view class=\"{{homeSelected?\'current\':\'default\'}}\" bindtap=\"handleHomeSelected\">正在热映</view>\n    <view class=\"{{comingSelected?\'current\':\'default\'}}\" bindtap=\"handleComingSelected\">即将上映</view>\n  </view>\n  <view class=\"{{homeSelected?\'show\':\'hidden\'}}\">\n     <!-- 正在热映 -->\n     <movieList id=\"movieList\" sendValue=\"{{movieType}}\"></movieList> \n  </view>\n  <view class=\"{{comingSelected?\'show\':\'hidden\'}}\">\n     <!-- 即将上映 -->\n     <movieList id=\"movieComingList\" sendValue=\"{{movieType}}\"></movieList>   \n  </view> \n</view>  \n```\nhome.js：\n```\nvar api = require(\'../../utils/api\')\n\nPage({\n  data: {\n    homeSelected:true,\n    comingSelected:false,\n    movieType:\'\' //传到movieList.wxml组件的参数\n  },\n  //转发页面\n  onShareAppMessage(res) {\n    if (res.from === \'button\') {\n      // 来自页面内转发按钮\n      console.log(res.target)\n    }\n    return {\n      title: \'来自豆瓣电影\',\n      path: \'/pages/index/index\',\n      success: function (res) {\n        console.log(\'转发成功\')\n      },\n      fail: function (res) {\n        console.log(\'转发失败\')\n      }\n    }\n  },\n  handleHomeSelected(e){\n    this.setData({\n      homeSelected: true,\n      comingSelected: false,\n      movieType: \'in_theaters\'\n    })\n    //调用movieList子组件的方法\n    this.movieList = this.selectComponent(\"#movieList\");\n    this.movieList.loadData(0);//起始页为0\n  },\n  handleComingSelected(e) {\n    this.setData({\n      homeSelected: false,\n      comingSelected: true,\n      movieType: \'coming_soon\'\n    })\n    this.movieList = this.selectComponent(\"#movieComingList\");\n    this.movieList.loadData(0);\n  },\n  onReady: function () {\n    this.handleHomeSelected();\n  }	\n```\n到这里电影列表获取就完成啦~\n最后还剩一个获取电影详情的页面，其中主要会涉及到横向滚动组件的使用，下一篇继续~\n如果文中有什么不对的或者需要注意的地方欢迎大家指正，一起分享交流~\n\n本文著作权归作者所有，如需转载，请联系本人并标明出处及原链接。', '2018-04-24 18:00:26', '2018-06-06 09:27:23', '0', '主要介绍怎么自定义组件及传值');
INSERT INTO `articles` VALUES ('39', '9e1a1a8048fa11e8b37f6045cb5f24c6', 'Aimee', '微信小程序仿豆瓣电影页面demo（4）--电影详情页', '10000', '1000', '![](http://upload-images.jianshu.io/upload_images/10954635-f14e982c9670a2cc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n接着上文继续~（上文地址：https://www.jianshu.com/p/4734a162ccff）\n####项目效果\n![detail.gif](https://upload-images.jianshu.io/upload_images/10954635-e89ede3174b16b45.gif?imageMogr2/auto-orient/strip)\n\n\n1. detail.wxml文件：\n```\n<view class=\"page\">\n    <view class=\"list\">\n          <view class=\"left\" style=\"width:40%;height:420rpx\">\n            <image src=\"{{detailList.images.large}}\" style=\"height:420rpx\" />\n          </view>\n          <view class=\"right\" style=\"width:60%;height:420rpx\">\n            <view class=\"row\">\n              <text style=\"font-size:20px;\">{{detailList.original_title}} </text>{{detailList.year}}\n            </view>\n            <view class=\"row\">\n              评分：{{detailList.rating.average}}\n            </view>\n            <view class=\"row\">\n              导演：<view wx:for=\"{{detailList.directors}}\" wx:for-item=\"directors\" wx:key=\"{{index}}\">\n                {{directors.name}}\n              </view>\n            </view>\n            <view class=\"row\">\n              主演：<view wx:for=\"{{detailList.casts}}\" wx:for-item=\"casts\" wx:key=\"{{index}}\">\n                {{casts.name}}\n              </view>\n            </view>  \n          </view>\n    </view>\n    <view class=\"story\">\n      <text class=\"story-title\">剧情简介</text>\n      <view class=\"story-detail\">{{detailList.summary}}</view>\n    </view>\n    <view class=\"cast\">\n      <text class=\"cast-title\">影人</text>\n      <scroll-view scroll-left=\"0\" scroll-x class=\"scroll\">\n        <block  wx:for=\"{{detailList.casts}}\" wx:key=\"{{index}}\">\n          <view class=\"cast-detail\">\n              <image src=\"{{item.avatars.large}}\" />\n              <text class=\"cast-name\" >{{item.name}}</text>          \n          </view>\n        </block>\n      </scroll-view>    \n    </view> \n</view>\n```\n2. detail.wxss文件：\n```\n@import \"../../styles/movieLayout\"; /* 引入公共样式文件 ，具体样式代码请查看之前的文章 */\n.story,.cast{\n  margin:16rpx\n}\n.story-title,.cast-title{\n  font-size:12px;\n  color:#726F6F;\n}\n.story-detail{\n  text-indent:2em;\n  margin-top:10rpx;\n}\n\n.scroll{\n  display: flex;\n  white-space: nowrap;  \n  width:100%;\n}\n.cast-detail{\n   display: inline-block; \n}\n.cast-detail image{\n  margin-top:10rpx;\n  display: block;  /* 将名字放在图片下面 */\n  height:300rpx;\n  width:130px;\n  padding-right: 10rpx;\n}\n.cast-detail text{\n  display: block; \n}\n\n```\n3. detail.js文件：\n```\nvar api = require(\'../../utils/api\');\nPage({\n  data: {\n    detailList:{}\n  },\n  onLoad: function (options) {\n    var id = options.id;//获取传递过来的参数\n    api.getDetail(id)\n      .then(res=>{\n        //console.log(res)\n        this.setData({\n          detailList:res\n        })\n      })\n  }\n})		\n```\n\n到这里为止，仿豆瓣电影demo基本完成啦~\n如果文中有什么不对的或者需要注意的地方欢迎大家指正，一起分享交流~\n\n本文著作权归作者所有，如需转载，请联系本人并标明出处及原链接。\n\n', '2018-04-24 18:00:44', '2018-06-06 09:26:14', '4', '电影详情页的介绍，主要包含scroll-view的使用');
INSERT INTO `articles` VALUES ('40', 'a02adc4b48fa11e8b37f6045cb5f24c6', 'Aimee', '关于webpack的一些配置（内含一些报错的解决，比如项目在IE下运行为空白页面）', '10000', '1000', '\n\n##### 1. 编译完成后自动打开浏览器\n\n方法一：（实际上比较麻烦）\n\nwebpack.dev.conf.js中：\n```\nconst OpenBrowserPlugin = require(\'open-browser-webpack-plugin\');\n\nplugins: [\n  new OpenBrowserPlugin({url: \'http://localhost:8080\'}),\n]\n```\n方法二：\nindex.js中配置  autoOpenBrowser:true\n\n![](https://upload-images.jianshu.io/upload_images/10954635-23f34cb623ff5b7e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n![](https://upload-images.jianshu.io/upload_images/10954635-f77b0694563a7187.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n\n##### 2. 设置开发过程中才输出log日志\nwebpack.dev.conf.js中：\n```\nplugins: [\n  new webpack.DefinePlugin({\n     IS_DEV: JSON.stringify(true),\n  }),\n]\n```\n生产环境webpack.dev.prod.js中：\n```\nplugins: [\n  new webpack.DefinePlugin({\n     IS_DEV: JSON.stringify(false),\n  }),\n]\n```\n使用：\n```\nif( IS_DEV){\n  console.log(\'xxx\')\n}\n```\n##### 3. 配置scss\n\nvue提供了初始化的webpack模板，其中使用了vue-loader。vue-loader默认只支持sass, 要是想要使用scss，必须安装node-sass和sass-loader：\ncnpm install node-sass sass-loader --save--dev\nwebpack.base.conf.js中：\n```\n{\n  test: /\\.vue$/,\n  loader: \'vue-loader\',\n  options: {\n    loaders: {\n      \'scss\': \'style-loader!css-loader!sass-loader\'\n      /* scss: [\'vue-style-loader\',\'css\', \'sass\'].join(\'!\')*/\n    }\n  }\n},\n```\n然后在.vue格式的模板中，style 标签中添加 lang=\'scss\' 就可以了。\n\n##### 4.配置px转rem\ncnpm install postcss-px2rem --save--dev\nvue-loader.conf.js中：\n```\npostcss:[\n    require(\'postcss-px2rem\')({\n    remUnit:10\n  })\n],\n```\n![](https://upload-images.jianshu.io/upload_images/10954635-25eb1af7210b106d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n##### 5. IE下运行项目为空白页面\n报错原因：IE浏览器没有内置Promise对象，实际几乎所有的ES6新增方法在IE都不能用。\n解决方法：\n1.安装babel Polyfill依赖：npm install --save babel-polyfill\n2.修改build/webpack.base.config.js的entry配置：\n\n![](https://upload-images.jianshu.io/upload_images/10954635-487854630a132bd5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n未完待续~\n\n\n本文著作权归作者所有，如需转载，请联系本人并标明出处及原链接。', '2018-04-25 15:01:00', '2018-06-06 09:22:08', '7', '主要介绍webpack的一些配置方法');
INSERT INTO `articles` VALUES ('41', 'a1bbddf248fa11e8b37f6045cb5f24c6', 'Aimee', 'es6 Promise用法', '10000', '1000', 'Promise是一个异步操作，分为三种状态：Pending（进行中）、Resolved（已完成，又称 Fulfilled ）和Rejected（已失败）。\n\n##### 特点：\n一旦状态改变，就不会再变，任何时候都可以得到这个结果。\n与事件（ Event ）的区别：事件错过了的话再去监听，是得不到结果的。\n\n##### 缺点：\n1.无法取消Promise，一旦新建它就会立即执行，无法中途取消；\n2.如果不设置回调函数，Promise内部抛出的错误，不会反应到外部；\n3.当处于Pending状态时，无法得知目前进展到哪一个阶段（刚刚开始还是即将完成）。\n\n##### 用法：\n```\nvar promise = new Promise((resolve,reject)=>{\n  // ... \n  if (/* 异步操作成功 */){\n    resolve(res);\n  } else {\n    reject(error);\n  }\n})\n\n//Promise 实例生成以后，可以用then方法分别指定Resolved状态和Reject状态的回调函数。\nvar promise = new Promise((resolve,reject)=>{\n  // ... \n}).then(res=>{\n     //成功\n     resolve(res);\n  }, err=>{\n    //失败\n     reject(err);\n  })\n```\nresolve函数表示状态从 “ 未完成 ” 变为 “ 成功 ” ，在异步操作成功时调用，并将异步操作的结果作为参数传递出去。\nreject函数表示状态从 “ 未完成 ” 变为 “ 失败 ”，在异步操作失败时调用，并将异步操作的错误作为参数传递出去。\n\n##### 例子：\naxios与Promise异步调用接口获取数据：\n```\nimport axios from \'axios\';\nimport qs from \'qs\';\nlet instance = axios.create({\n  baseURL: \'\',  // 基础url前缀\n  timeout: 10000 \n});\nfunction fetchApi(url){\n  return new Promise((resolve,reject)=>{\n    let param = {\n      //...\n    }\n    let config = {\n       headers: {\'Content-Type\': \"multipart/form-data\"}\n    };\n    instance.post(url, qs.stringify(param), config)\n      .then(response => {\n        resolve(response.data);\n      }, err => {\n        reject(err);\n      })\n      .catch((error) => {\n        reject(error)\n      })\n  })\n}\nfunction login() {\n    return fetchApi(\'/login\')\n}\nlogin();\n\n```\njquery  ajax访问后台接口获取数据：\n```\n $.ajax({\n    type: \'post\',\n    url: \'/login\',\n    data: {\n        //传递到后台的参数 没有则不写\n        user_name: name,\n        password: password\n    },\n    dataType: \'json\',\n    success(res) {\n        if(res.msgCode == 0){\n            //alert(\'登录成功!\');\n            window.location.href = \'/\';\n        }else{\n            alert(\"错误码：\" + res.msgCode + \"，\" + res.msg);\n            window.location.href = \'/\';\n        }\n    },\n    error(err) {\n        alert(\'登录失败!错误信息：\'+ err);\n        return;\n    }\n});\n```\n原生ajax范文后台接口获取数据：\n```\nvar XHR=null;  \nvar url = \'\'; \nif (window.XMLHttpRequest) {  \n    // 非IE内核  \n    XHR = new XMLHttpRequest();  \n} else if (window.ActiveXObject) {  \n    // IE内核,这里早期IE的版本写法不同,具体可以查询下  \n    XHR = new ActiveXObject(\"Microsoft.XMLHTTP\");  \n} else {  \n    XHR = null;  \n}  \nif(XHR){  \n    XHR.open(\"GET\", url);  \n    XHR.onreadystatechange = function () {  \n        // readyState值说明  \n        // 0,初始化,XHR对象已经创建,还未执行open  \n        // 1,载入,已经调用open方法,但是还没发送请求  \n        // 2,载入完成,请求已经发送完成  \n        // 3,交互,可以接收到部分数据  \n        if (XHR.readyState == 4 && XHR.status == 200) {  \n            // 这里可以对返回的内容做处理  \n            // 一般会返回JSON或XML数据格式  \n            console.log(XHR.responseText);  \n            // 主动释放,JS本身也会回收的  \n            XHR = null;  \n        }  \n    };  \n    XHR.send();  \n}  \n```\n\n##### 方法：\n###### Promise.prototype.then()\nthen方法返回的是一个新的 Promise 实例（注意，不是原来那个 Promise 实例）。因此可以采用链式写法，即then方法后面再调用另一个then方法。\n```\nlogin(param).then(function(post) {\n   return param;\n   }).then(res=> {\n      console.log(\"Resolved: \", res);\n   }, err=>{\n      console.log(\"Rejected: \", err);\n});\n```\n第二个then方法指定的回调函数会等待这个新的 Promise 对象状态发生变化。如果变为 Resolved打印res，如果状态变为 Rejected打印err。\n###### Promise.prototype.catch()\n1.如果异步操作抛出错误，状态就会变为Rejected，就会调用catch方法指定的回调函数，处理这个错误。\n2.then方法指定的回调函数如果运行中抛出错误，也会被catch方法捕获。\n3.Promise 对象的错误具有 “ 冒泡 ” 性质，会一直向后传递，直到被捕获为止。也就是说，错误总是会被下一个catch语句捕获。\n4.reject方法的作用，等同于抛出错误\n```\nvar promise = new Promise((resolve, reject)=> {\ntry {\n  throw new Error(\'test\');\n} catch(err) {\n  reject(err);\n}\n});\n// 等同于\nvar promise = new Promise((resolve, reject)=> {\n  reject(new Error(\'test\'));\n});\n```\n###### Promise.all()\n接受一个数组作为参数,用于将多个 Promise 实例，包装成一个新的 Promise 实例。\n```\nvar p = Promise.all([p1, p2, p3]);\n```\np的状态由p1、p2、p3决定:\n1.只有p1、p2、p3的状态都变成已完成，p的状态才会变成已完成，此时p1、p2、p3的返回值组成一个数组，传递给p的回调函数。\n2.只要p1、p2、p3之中有一个被拒绝，p的状态就变成拒绝，此时第一个被reject的实例的返回值，会传递给p的回调函数。\n\n###### Promise.race()\n同样是将多个 Promise 实例，包装成一个新的 Promise 实例\n区别：哪个结果获得的快，就返回那个结果，不管结果本身是成功状态还是失败状态。\n```\nvar p = Promise.race([p1,p2,p3]);\n```\n###### Promise.resolve()\n将现有对象转为 Promise 对象\n```\nPromise.resolve(\'foo\')\n// 等价于\nnew Promise(resolve => resolve(\'foo\'))\n```\n###### Promise.reject()\n返回一个新的 Promise 实例，该实例的状态为rejected。\n```\nvar p = Promise.reject(\' 出错了 \');\n// 等同于\nvar p = new Promise((resolve, reject) => reject(\' 出错了 \'))\np.then(null, function (s){\n  console.log(s)\n});\n\n```', '2018-04-25 15:10:31', '2018-06-06 09:17:20', '27', '介绍promise的优缺点及用法，Promise是一个异步操作，分为三种状态：Pending（进行中）、Resolved（已完成，又称 Fulfilled ）和Rejected（已失败）。介绍如何通过promise异步请求接口、Promise.all()、Promise.race()、Promise.resolve()、Promise.reject()Promise.prototype.then()、Promise.prototype.catch()、等方法');
INSERT INTO `articles` VALUES ('43', 'e353dbd1692911e88c096045cb5f24c6', 'Aimee', 'vue.js+ElementUI实现换肤功能', '10000', '1001', '\n![下载.png](http://localhost:8080/下载.png)\n灵活换肤\n[灵活换肤](https://segmentfault.com/a/1190000009762198#articleHeader2)(https://segmentfault.com/a/1190000009762198#articleHeader2)\n[demo源码]( https://github.com/ElementUI/theme-preview)（https://github.com/ElementUI/theme-preview）\n注：不兼容ie、360浏览器。\n\n改为固定几种方式换肤：\n1. [github Issue说明](https://github.com/ElemeFE/element/issues/3054)(https://github.com/ElemeFE/element/issues/3054)\n2. [demo](http://localhost:2018/#/index/readme)(http://localhost:2018/#/index/readme)\n[源码](https://github.com/lss5270/vue-admin-spa)(https://github.com/lss5270/vue-admin-spa)\n\n2. http://blog.csdn.net/young_Emily/article/details/78591261\nhttps://github.com/ElemeFE/element/issues/3054\n\n二者的主要思想类似：\n先用主题工具生成几种主题色，放在一个文件夹中调用\n\n方式2还用到了gulp工具，注意下载时要全局下载，而且要增加环境变量\n[gulp学习链接](https://www.gulpjs.com.cn/docs/getting-started/)\ncnpm install -g gulp\n环境变量：\nC:\\Program Files (x86)\\nodejs\\node_global\n主要是用gulp工具给每个样式文件新增一个class,然后对应调用', '2018-06-06 09:35:24', '2018-06-06 09:41:24', '9', '总结换肤的两种方式');
INSERT INTO `articles` VALUES ('49', 'c8f76086693911e88c096045cb5f24c6', 'Aimee', 'js', '10000', '1000', '\n![login.jpg](./0)', '2018-06-06 11:29:12', null, '0', 'sss');
INSERT INTO `articles` VALUES ('50', '36d6d11d693a11e88c096045cb5f24c6', 'Aimee', 'js', '10000', '1000', '![loginbackground.jpg](http://localhost:8080/login-background.jpg)', '2018-06-06 11:32:16', null, '0', 'js');

-- ----------------------------
-- Table structure for article_type
-- ----------------------------
DROP TABLE IF EXISTS `article_type`;
CREATE TABLE `article_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `directionName` varchar(20) NOT NULL,
  `categoryName` varchar(20) NOT NULL,
  `directionId` varchar(20) NOT NULL,
  `categoryId` varchar(20) NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_type
-- ----------------------------
INSERT INTO `article_type` VALUES ('1', '前端', 'javascript', '10000', '1000');
INSERT INTO `article_type` VALUES ('2', '前端', 'vue.js', '10000', '1001');
INSERT INTO `article_type` VALUES ('3', '前端', 'html', '10000', '1002');
INSERT INTO `article_type` VALUES ('4', '前端', 'css', '10000', '1003');
INSERT INTO `article_type` VALUES ('5', '后端', 'node.js', '20000', '2000');
INSERT INTO `article_type` VALUES ('6', '后端', 'java', '20000', '2001');
INSERT INTO `article_type` VALUES ('7', '服务器', 'nginx', '30000', '3000');
INSERT INTO `article_type` VALUES ('8', '服务器', 'tomcat', '30000', '3001');

-- ----------------------------
-- Table structure for article_visit
-- ----------------------------
DROP TABLE IF EXISTS `article_visit`;
CREATE TABLE `article_visit` (
  `visit_count` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_visit
-- ----------------------------

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增id',
  `menu_id` varchar(32) NOT NULL COMMENT '菜单id',
  `parent` varchar(32) DEFAULT NULL COMMENT '父节点',
  `title` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL COMMENT '菜单名称',
  `path` varchar(200) DEFAULT NULL COMMENT '菜单url',
  `icon` varchar(200) DEFAULT NULL COMMENT '菜单图标',
  `type` varchar(32) DEFAULT NULL,
  `identifier` varchar(32) DEFAULT NULL COMMENT '操作标识',
  `orders` int(2) DEFAULT NULL COMMENT '排序号',
  `status` int(1) DEFAULT NULL COMMENT '状态 1正常 2禁用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8 COMMENT='菜单功能';

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('319', '01834a6649c711e8b37f6045cb5f24c6', '', '个人信息', 'homepage', '/homepage', 'person', '', 'Main', '1', '1', '2018-04-27 11:03:29', '2018-05-11 10:52:07');
INSERT INTO `menu` VALUES ('320', 'e6e15c0a49c811e8b37f6045cb5f24c6', '01834a6649c711e8b37f6045cb5f24c6', '个人信息', 'homepage_index', 'index', '', 'homepage', 'personhomepage/homepage', '1', '1', '2018-04-27 11:17:03', '2018-05-11 10:40:25');
INSERT INTO `menu` VALUES ('321', 'd7075ed049cb11e8b37f6045cb5f24c6', '', '前端', 'frontend', '/frontend', 'pin', '', 'Main', '2', '1', '2018-04-27 11:38:05', null);
INSERT INTO `menu` VALUES ('322', '27f881d649cc11e8b37f6045cb5f24c6', 'd7075ed049cb11e8b37f6045cb5f24c6', 'javascript', 'frontend-javascript', 'javascript', '', 'frontend', '', '1', '1', '2018-04-27 11:40:21', '2018-05-11 11:15:32');
INSERT INTO `menu` VALUES ('323', '5866128949cc11e8b37f6045cb5f24c6', 'd7075ed049cb11e8b37f6045cb5f24c6', 'vue.js', 'frontend-vue.js', 'vue.js', '', 'frontend', '', '2', '1', '2018-04-27 11:41:42', '2018-05-07 14:58:30');
INSERT INTO `menu` VALUES ('324', 'a6a32b9a49cc11e8b37f6045cb5f24c6', '', '后端', 'backend', '/backend', 'pin', '', 'Main', '3', '1', '2018-04-27 11:43:53', '2018-05-03 18:00:01');
INSERT INTO `menu` VALUES ('325', 'f840a1b749cc11e8b37f6045cb5f24c6', 'a6a32b9a49cc11e8b37f6045cb5f24c6', 'node.js', 'backend-node.js', 'node.js', '', 'backend', '', '1', '1', '2018-04-27 11:46:10', '2018-05-07 14:59:13');
INSERT INTO `menu` VALUES ('326', '03ce737f49cd11e8b37f6045cb5f24c6', 'a6a32b9a49cc11e8b37f6045cb5f24c6', 'java', 'backend-java', 'java', '', 'backend', '', '2', '1', '2018-04-27 11:46:29', '2018-05-07 14:59:18');
INSERT INTO `menu` VALUES ('327', '8d8eb0974e9811e8b7926045cb5f24c6', '', '菜单管理', 'menu', '/menu', 'ios-list', '', 'Main', '6', '1', '2018-05-03 14:09:35', '2018-05-07 14:56:55');
INSERT INTO `menu` VALUES ('328', '9ecae10d4e9811e8b7926045cb5f24c6', '8d8eb0974e9811e8b7926045cb5f24c6', '菜单管理', 'menu_index', 'index', '', 'menu', 'menu/menu-list', '1', '1', '2018-05-03 14:10:04', null);
INSERT INTO `menu` VALUES ('332', '8a257de64eaf11e8b7926045cb5f24c6', '', '服务器', 'server', '/server', 'pin', '', 'Main', '5', '1', '2018-05-03 16:54:08', '2018-05-07 14:57:12');
INSERT INTO `menu` VALUES ('333', '990e80db4eaf11e8b7926045cb5f24c6', '8a257de64eaf11e8b7926045cb5f24c6', 'nginx', 'server-nginx', 'nginx', '', 'server', '', '1', '1', '2018-05-03 16:54:33', '2018-05-07 14:59:23');
INSERT INTO `menu` VALUES ('340', '39f8d6844eb411e8b7926045cb5f24c6', '8a257de64eaf11e8b7926045cb5f24c6', 'tomcat', 'server-tomcat', 'tomcat', '', 'server', '', '2', '1', '2018-05-03 17:27:41', '2018-05-07 14:59:26');
INSERT INTO `menu` VALUES ('342', '5438cb244f3611e8b7926045cb5f24c6', 'd7075ed049cb11e8b37f6045cb5f24c6', 'jquery', 'frontend-jquery', 'jquery', '', 'frontend', '', '1', '1', '2018-05-04 08:58:59', '2018-05-07 14:58:35');
INSERT INTO `menu` VALUES ('365', 'c8650c5251c311e8b7926045cb5f24c6', '', '数据库', 'database', '/database', 'pin', '', 'Main', '4', '1', '2018-05-07 14:56:47', '2018-05-07 14:57:08');
INSERT INTO `menu` VALUES ('366', 'e5c944a351c311e8b7926045cb5f24c6', 'c8650c5251c311e8b7926045cb5f24c6', 'mysql', 'database-mysql', 'mysql', '', 'database', '', '1', '1', '2018-05-07 14:57:36', '2018-05-07 14:59:30');
INSERT INTO `menu` VALUES ('367', 'dfbe6c6551c411e8b7926045cb5f24c6', 'c8650c5251c311e8b7926045cb5f24c6', 'sql server', 'database-sql server', 'sql server', '', 'database', '', '1', '1', '2018-05-07 15:04:36', null);

-- ----------------------------
-- Table structure for project_info
-- ----------------------------
DROP TABLE IF EXISTS `project_info`;
CREATE TABLE `project_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` date NOT NULL,
  `introduction` varchar(50) NOT NULL,
  `url` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of project_info
-- ----------------------------
INSERT INTO `project_info` VALUES ('1', '2018-05-03', 'q', '');
INSERT INTO `project_info` VALUES ('2', '2018-05-11', '1', '');
INSERT INTO `project_info` VALUES ('3', '2018-05-12', '微信小程序仿豆瓣电影', '');
INSERT INTO `project_info` VALUES ('4', '2018-06-06', '个人博客', '');
INSERT INTO `project_info` VALUES ('5', '2018-06-06', 'aaa', '');
INSERT INTO `project_info` VALUES ('6', '2018-06-06', 'js', '');
INSERT INTO `project_info` VALUES ('7', '2018-06-06', '哈哈哈哈', '');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `address` varchar(50) DEFAULT NULL,
  `skill` varchar(50) DEFAULT NULL,
  `introduction` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'Aimee', '111111', '深圳福田区区', 'html、css、javascript、jquery、vue.js、node.js', '热爱生活、热爱互联网、热爱新技术');
