import 'dart:convert';

import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/model/site.dart';
import 'package:feiyu/app/tool/http.dart';

import 'package:xml2json/xml2json.dart';

class Search {
  static Future<List<Movie>> api(String keyword, Site site,
          {bool force = true}) async =>
      spiderAPI(keyword, site, force: force);

  static Future<List<Movie>> web(String keyword, Site site,
          {bool force = true}) async =>
      spiderWeb(keyword, site, force: force);

  static Future<List<Movie>> spiderAPI(String keyword, Site site,
      {bool force = true}) async {
    dynamic temp;
    Http http = Http();
    List<Movie> movies = [];
    String text = await http.get(site.xml + "?wd=" + keyword);
    try {
      temp = getUrlsApi(text, site);
    } catch (e) {
      return movies;
    }
    List<String> links = temp['links'];
    List<String> titles = temp['titles'];
    if (links.length < 1) return movies;
    for (var link in links) {
      var title = titles[links.indexOf(link)].trim();
      //严格模式
      if (force && !title.contains(keyword)) continue;
      //获取详情
      text = await http.get(site.xml + '?ac=videolist&ids=' + link);
      try {
        temp = getM3u8sApi(text, site);
      } catch (e) {
        continue;
      }
      List<String> m3u8s = temp['m3u8s'];
      List<String> items = temp['items'];
      String cover = 'http' + (site.server + temp['cover']).split('http').last;
      String desp = temp['desp'];
      List<Playlist> playlists = [];
      for (var m3u8 in m3u8s) {
        playlists.add(Playlist(m3u8: m3u8, name: items[m3u8s.indexOf(m3u8)]));
      }
      movies.add(
          Movie(title: title, cover: cover, desp: desp, playlist: playlists));
    }
    return movies;
  }

  static getM3u8sApi(String text, Site site) {
    String cover, desp;
    List<String> m3u8s, items = [], m3u8x = [];
    var video = jsonDecode(xmlToJson(text))['rss']['list']['video'];
    desp = video['des'];
    cover = video['pic'];
    m3u8s = video['dl']['dd'].split('#');
    for (var m3u8 in m3u8s) {
      if (m3u8.contains(r'$')) {
        items.add(m3u8.split(r'$')[0]);
        m3u8x.add(m3u8.split(r'$')[1]);
      }
    }
    return {"m3u8s": m3u8x, "cover": cover, "desp": desp, "items": items};
  }

  static getUrlsApi(String text, Site site) {
    List<String> titles = [], links = [];
    var json = jsonDecode(xmlToJson(text));
    if (json['rss']['list'] == null) {
      //搜索结果为空
      return {"titles": <String>[], "links": <String>[]};
    }
    var videos = json['rss']['list']['video'];
    if (!(json['rss']['list']['video'] is List)) {
      //只搜到一个
      return {
        "titles": <String>[videos['name'] + '(' + videos['note'] + ')'],
        "links": <String>[videos['id']]
      };
    }
    //搜到多个
    for (var video in videos) {
      titles.add(video['name'] + '(' + video['note'] + ')');
      links.add(video['id']);
    }
    return {"titles": titles, "links": links};
  }

  static String xmlToJson(String xml) {
    var myTransformer = Xml2Json();
    try {
      myTransformer.parse(xml);
    } catch (e) {
      return '{"rss":{"list":null}}';
    }
    return myTransformer.toParker();
  }

  static Future<List<Movie>> spiderWeb(String keyword, Site site,
      {bool force = true}) async {
    Http http = Http();
    List<Movie> movies = [];
    String text = await http.post(site.server + "index.php?m=vod-search",
        data: {"wd": keyword, "submit": "search"});
    dynamic temp = getUrlsWeb(text, site);
    List<String> links = temp['links'];
    List<String> titles = temp['titles'];
    if (links.length < 1 || links.length != titles.length) return movies;
    for (var link in links) {
      var title = titles[links.indexOf(link)].trim();
      //严格模式
      if (force && !title.contains(keyword)) continue;
      //获取详情
      text = await http.get((site.server + link)
          .replaceAll('//?', '/?')
          .replaceAll(site.server * 2, site.server));
      temp = getM3u8sWeb(text, site);
      List<String> m3u8s = temp['m3u8s'];
      List<String> items = temp['items'];
      if (temp['cover'].length < 1 || temp['desp'].length < 1) continue;
      String cover =
          'http' + (site.server + temp['cover'][0]).split('http').last;
      String desp = temp['desp'][0];
      List<Playlist> playlists = [];
      for (var m3u8 in m3u8s) {
        playlists.add(Playlist(m3u8: m3u8, name: items[m3u8s.indexOf(m3u8)]));
      }
      movies.add(
          Movie(title: title, cover: cover, desp: desp, playlist: playlists));
    }
    return movies;
  }

  static getM3u8sWeb(String text, Site site) {
    List<String> cover, m3u8s, desp, items = [], m3u8x = [];
    cover = findAll(text, site.cover);
    m3u8s = findAll(text, site.m3u8);
    // items = findAll(text, site.item);
    desp = findAll(text, site.desp);
    for (var m3u8 in m3u8s) {
      if (m3u8.contains(r'$')) {
        items.add(m3u8.split(r'$')[0]);
        m3u8x.add(m3u8.split(r'$')[1]);
      }
    }
    return {"m3u8s": m3u8x, "cover": cover, "desp": desp, "items": items};
  }

  static getUrlsWeb(String text, Site site) {
    List<String> titles, links;
    titles = findAll(text, site.title);
    links = findAll(text, site.link);
    return {"titles": titles, "links": links};
  }

  static List<String> findAll(String text, String exp) =>
      RegExp(exp).allMatches(text).map<String>((s) {
        if (s.groupCount < 1) return '';
        return s.group(1);
      }).toList();
}
