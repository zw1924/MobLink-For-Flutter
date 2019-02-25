import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:moblink/moblink.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {


  void getMobId(BuildContext context) {
    // 设置参数
    MLSDKScene scene =
        MLSDKScene('/demo/a', {'param1': '123', 'param2': '456'});
    // 传入 scene , 获取 mobid
    Moblink.getMobId(scene, (String mobid, String domain, MLSDKError error) {
      print('QQQ mobid回调');
      if (mobid != null) {
        print('QQQ 得到mobid：' + mobid);
        showAlert(mobid, context);
      }
    });
  }

  void getShortUrl(BuildContext context) {
    MLSDKScene scene =
        MLSDKScene('/demo/b', {'param1': '456', 'param2': '789'});
    Moblink.getMobId(scene, (String mobid, String domain, MLSDKError error) {
      if (mobid != null) {
        print('分享短链:' + domain + mobid);
        showAlert(domain + mobid, context);
      }
    });
  }

  void showAlert(String text, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: new Text("提示"),
                content: new Text(text),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  Widget _creatRow(String methodName, String methodDes, Function method,
      BuildContext context) {
    return new GestureDetector(
      onTap: () {
        method(context);
      },
      child: new Container(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withAlpha(10),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // padding: const EdgeInsets.only(bottom: 2.0),
          children: [
            new Container(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: new Text(
                methodName,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Text(
              methodDes,
              style: new TextStyle(
                color: Colors.grey[500],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Container(
                padding: const EdgeInsets.only(top: 0.33),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //Moblink.listenNativeEvent();

    // 场景还原的回调
    Moblink.restoreScene((MLSDKScene scene) {
      // 根据场景，手动设置跳转
      print('要还原的路径为：' + scene.path);
      showAlert("要还原的路径为：" + scene.path, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('MobLink Plugin'),
      ),
      body: new ListView(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        children: <Widget>[
          _creatRow("生成MobId", "path: /demo/a", getMobId, context),
          _creatRow("生成短链", "path: /demo/b", getShortUrl, context),
        ],
      ),
    );
  }
}
