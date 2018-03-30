﻿
(function ($,uni) {
    var pro = {
        //pro文件夹路径
        dir: (function () {
            var path;
            var i = location.href.toLowerCase().indexOf("/clientweb/");
            if (i < 0) path = location.origin;
            else path = location.href.substring(0, i);
            path += "/ClientWeb/pro/";
            return path;
        })(),
        //初始化翻译
        initLanguage: function (lan,suc) {
            var url = pro.dir + "ajax/util.aspx";
            $.get(url, { act: "set_language", language: lan }, function (data, status) {
                if (status == 200) {
                    var rlt = JSON.parse(data);
                    if (rlt.ret == 1) {
                        $.get(url, { act: "get_language" }, function (data, status) {
                            if (status == 200) {
                                var rlt = JSON.parse(data);
                                if (rlt.ret == 1) {
                                    if (rlt.data) {
                                        uni.language = rlt.data;
                                        suc&&suc(rlt);
                                    }
                                }
                                else {
                                    alert(rlt.msg);
                                }
                            }
                            else {
                                alert("connect error");
                            }
                        });
                    }
                    else {
                        alert(rlt.msg);
                    }
                }
                else {
                    alert("connect error");
                }
            });
        },
        //页面翻译
        transPage: function (page) {
            if (!uni.language) return;
            $(".uni_trans,.icon span,.icon-only span,.item-title,.item-text,.item-after,.font-huge,.font-big,.font-normal,.tabbar-label,a.button,button,.navbar-inner .center,.content-block-title,h3,h4,.flag_today", page).each(function () {
                $(this).html(uni.translate($(this).text()));
            });
            $(".uni_ph_trans", page).each(function () {
                $(this).attr(uni.translate($(this).attr("placeholder")));
            });
        },
        //抽取中文翻译
        transPick: function (msg) {
            if (!uni.language) return msg;
            //var reg = /(-|[\u4E00-\u9FA5]|[\uFE30-\uFFA0]|\u3002|\u3010|\u3011)+/g;//中文以及中文标点符号
            //var str = msg;
            //var arr = reg.exec(msg);
            //while (arr && reg.lastIndex <= msg.length) {
            //    str = str.replace(arr[0], uni.translate(arr[0]));
            //    arr = reg.exec(msg);
            //}
            var str = msg;
            var arr = msg.split(/[0-9 ]+/g);
            for (var i = 0; i < arr.length; i++) {
                str = str.replace(arr[i], uni.translate(arr[i]));
            }
            return str;
        },
        //用户对象
        acc: {
            id: null,
            accno: null,
            name: null,
            phone: null,
            email: null,
            ident: null,
            dept: null,
            score: null,
            receive: null
        },
        //全局对象
        global: null,
        locationSignIn: function (callback) {
            uni.getLocation(function (lon, lat) {
                var ret = false;
                if (!uni.isNull(pro.global) && !uni.isNull(lon)) {
                    var coords = pro.global.config.coords || [];
                    var accur = coords[0] || 50;
                    for (var i = 1; i < coords.length; i += 2) {
                        if (coords[i] && coords[i + 1]) {
                            if (uni.getDisance(lon, lat, coords[i], coords[i + 1]) < accur) {
                                ret = true;
                                break;
                            }
                        }
                    }
                }
                callback(ret);
            });
        }
    }
    //html格式化
    pro.htm = {
        getResvRule: function (obj) {
            var remark = $('<div>' + uni.translate('当日开放') + '<span class="open_t"></span>，<span class="limit_t"></span></div>');
            //开放时间
            var open = "";
            if (obj.ops && obj.ops.length > 0) {
                for (var i = 0; i < obj.ops.length; i++) {
                    var op = obj.ops[i];
                    open += op.start + ' - ' + op.end + '，';
                }
                if (open.length > 0) open = open.substr(0, open.length - 1);
            }
            else
                open = obj.openStart + ' - ' + obj.openEnd;
            $(".open_t", remark).html(open);
            //允许时长
            if (obj.max) {
                var min = obj.min ? pro.dt.m2dms(obj.min) : "0";
                $(".limit_t", remark).html(uni.translate('每次需预约') + "<span>" + min + uni.translate(" - ") + pro.dt.m2dms(obj.max) + "</span>");
            }
            return remark.html();
        }
    };
    //日期格式化
    pro.dt = {};
    //分钟转完整时间
    pro.dt.m2dms = function (m) {
        var t = parseInt(m);
        var dy = parseInt(t / 1440);
        var hr = parseInt((t % 1440) / 60);
        var mi = parseInt((t % 1440) % 60);
        return (dy ? dy + uni.translate('天') : "") + (hr ? hr + (dy ? uni.translate('时') : uni.translate('小时')) : "") + (mi ? mi + (hr ? uni.translate('分') : uni.translate('分钟')) : "");
    }
    pro.dt.m2ms = function (m) {
        var t = parseInt(m);
        var ms = parseInt(t / 60) + uni.translate('时');
        ms += parseInt(t % 60) + uni.translate('分');
        return ms;
    }
    //日期数字转日期字符串
    pro.dt.num2date = function (num) {
        num = "" + num;
        var str = "";
        if (num.length == 8) {
            str = num.substring(0, 4) + "-" + num.substring(4, 6) + "-" + num.substring(6);
        }
        return str;
    }
    //日期字符串转日期数字
    pro.dt.date2num = function (dt) {
        if (typeof (dt) == "string")
            return parseInt(dt.replace(/-/g, ""));
        else
            return 0;
    }
    //时间字符串转时间数字
    pro.dt.tm2num = function (tm) {
        if (typeof (tm) == "string")
            return parseInt(tm.replace(/:/g, ""));
        else if (typeof (tm) == "number")
            return tm;
        else
            return 0;
    }
    //时间位补足两位
    pro.dt.timeFull = function (hm) {
        var h, m;
        if (typeof (hm) == "string" && hm.indexOf(":") > 0) {
            var tmp = hm.split(":");
            h = uni.num2Str(tmp[0]);
            m = uni.num2Str(tmp[1]);
        }
        else {
            var num = parseInt(hm);
            h = uni.num2Str(parseInt(hm / 100));
            m = uni.num2Str(hm % 100);
        }
        return h + ":" + m;
    }
    pro.md = {};
    window.pro = pro;

    //拓展方法  app：Framework7实例 
    pro.initExMethods = function (app) {
        var m_view;
        for (var i = 0; i < app.views.length; i++) {
            var view = app.views[i];
            if (view.main) m_view = view;
        }
        if (!app || !m_view) {
            return null;
        }
        //消息窗口
        pro.msgBox = function (msg, fun, title, type) {
            app.alert(pro.transPick(msg), uni.translate(title), fun);
        }
        pro.msgBoxRT = pro.msgBoxR = pro.msgBox;
        pro.confirm = function (msg, ok, cancel, title) {
            app.confirm(pro.transPick(msg), uni.translate(title), ok, cancel);
        }
        pro.notice = function (msg, title, hold) {
            app.addNotification({
                title: uni.translate(title || '消息通知'),
                hold: hold || 1000,
                message: pro.transPick(msg)
            });
        }
        //uni拓展消息窗口
        uni.msgBox = uni.msgBoxR = uni.msgBoxRT = pro.msgBox;
        uni.confirm = pro.confirm;
        //返回
        pro.back = function (pageName, fun, from) {
            var opt = { pageName: pageName, force: true };
            var handle = function (e) {
                if (app.params.pushState) {
                    if (app.pushStateQueue.length > 0 && app.pushStateQueue[0].action !== 'back')
                        app.pushStateQueue = [];
                }
                if (fun) fun(e);
                window.removeEventListener("pageAfterBack", handle);
            };
            window.addEventListener("pageAfterBack", handle);
            m_view.router.back(opt);
        }
        //拓展插件
        //简易状态条 obj来自devResvState
        pro.stateSlider = function (obj, para) {
            var clsHtml = para.showClose ? '<div class="ss-panel" style="width: 100%;"><div class="ss-state-panel"><div class="ss-slider"><div class="ss-bar theme-bg" style="background:#ccc;left:0;right:0"></div></div></div></div>' : '';
            para = para || {};
            //过滤规则
            if (!obj.date) return "";
            if (!obj.open || obj.open.length < 2) {
                if (obj.islong) {
                    //长期显示模式
                    var panel = $("<div class='sb-panel'></div>");
                    var dt = uni.parseDate(obj.date);
                    var minDate = obj.latest ? (new Date()).addDays(parseInt(obj.latest / 1440)) : undefined;
                    var maxDate = obj.earliest ? (new Date()).addDays(parseInt(obj.earliest / 1440)) : undefined;
                    var arr = [];
                    if (obj.ts) {
                        for (var i = 0; i < obj.ts.length; i++) {
                            if (para.start && para.end &&
                                uni.compareDate(para.start, obj.ts[i].start) <= 0 && uni.compareDate(para.end, obj.ts[i].end) >= 0) continue;
                            var st = uni.parseDate(obj.ts[i].start);
                            var en = uni.parseDate(obj.ts[i].end);
                            arr.push({ start: st, end: en });
                        }
                    }
                    for (var i = 0; i < 30; i++) {
                        var ball = $("<span class='sb-ball sb-free' data-date='" + dt.format("yyyy-MM-dd") + "'>" + dt.getDate() + "</span>");
                        if (i == 0) { ball.addClass("sb-active"); ball.css("margin-right", "8px"); }
                        if ((!minDate || uni.compareDate(dt, minDate) >= 0) && (!maxDate || uni.compareDate(dt, maxDate) <= 0)) {
                            for (var j = 0; j < arr.length; j++) {
                                var cls = arr[j];
                                if (uni.compareDate(dt, cls.start) >= 0 && uni.compareDate(dt, cls.end) <= 0) {
                                    ball.removeClass("sb-free");
                                    ball.addClass("sb-busy theme-bg");
                                    break;
                                }
                            }
                        }
                        else {
                            ball.addClass("sb-invaild");
                        }
                        panel.append(ball[0]);
                        dt.addDays(1);
                    }
                    return panel[0].outerHTML;
                }
                else
                    return clsHtml;
            }
            //当日模式
            if (!para.width || (obj.prop & 524288) > 0) return "";//不支持预约
            if (obj.state == "forbid" || (obj.state == "close" && !para.showClose)) {//过滤不开放 禁用按不开放处理
                return clsHtml;
            }
            var now = new Date();
            var date = obj.date;
            var isToday = date == now.format("yyyy-MM-dd");
            var panel = $("<div class='ss-panel'/>");
            var open_start = parseInt(obj.open[0].replace(':', ''), 10);
            var open_end = parseInt(obj.open[1].replace(':', ''), 10);

            //this[0].appendChild(panel[0]);
            //this.htmlExt(panel);
            //标尺表
            var h_start = Math.floor(open_start / 100);
            var h_end = Math.ceil(open_end / 100);
            var width = para.width;
            var di = (h_end - h_start) > 14 ? 2 : 1;//大于12小时则按2小时一格处理
            var diff = Math.ceil((h_end - h_start) / di);
            var cw = parseInt(width / diff);//每格宽度
            var nw = cw / di;//每小时宽度
            width = cw * diff;
            panel.css("width", (width + 1) + "px");//重置面板宽度 需+1px表格边框
            var tbl = $("<div class='ss-tbl'></div>");
            var table = "<table class='ss-table'><tr>";
            for (var i = h_start; i < h_end; i += di) {
                var h = uni.num2Str(i);
                table += "<td class='ss-td " + (now.getHours() > i ? "" : "ss-td-h") + "' data-h='" + i + "' style='width:" + (cw - 1) + "px'>" + h + "</td>";
            }
            table += "</tr></table>";
            tbl.html(table);
            //状态版面
            var sp = $("<div class='ss-state-panel'></div>");
            var sum = (h_end - h_start) * 60;
            var m_left = nw * ((open_start % 100) / 60) + "px";
            var m_right = nw * (((60 - (open_end % 100)) % 60) / 60) + "px";
            sp.css("margin-left", m_left)
            .css("margin-right", m_right);
            //tip与状态条
            //var tips = $('<div class="ss-tips"></div>');sp.append(tips[0]);
            var slider = $("<div class='ss-slider'></div>"); sp.append(slider[0]);
            var arr = obj.ts.concat(obj.cls);
            var begin = uni.str2m(obj.open[0]);
            //var terminal = uni.str2m(obj.open[1]);
            var op_start = date + " " + obj.open[0];
            var op_end = date + " " + obj.open[1];
            //今日过期时间
            if (isToday) {
                var m_start = uni.str2m(obj.open[0]);
                var m_end = now.getHours() * 60 + now.getMinutes();
                var w = nw * ((m_end - m_start) / 60);
                slider.append("<div class='ss-bar theme-bg' style='background:#ccc;left:0;width:" + w + "px'/>");
            }
            //状态条
            for (var i = 0; i < arr.length; i++) {
                var v = arr[i];
                if (!v.start || !v.end) continue;
                if (obj.islong && (uni.compareDate(v.end, op_start) < 0 || uni.compareDate(v.start, op_end) > 0)) continue;//长期预约 过滤当日以外
                if (uni.compareDate(v.end, now, "m") < 0) continue;//过滤今日已过期
                var start;
                var end;
                if (uni.compareDate(op_start, v.start, "m") > 0)//早于开始
                    start = obj.open[0];
                else
                    start = v.start.split(' ')[1];
                if (uni.compareDate(op_end, v.end, "m") < 0)//晚于结束
                    end = obj.open[1];
                else
                    end = v.end.split(' ')[1];
                var m_start = uni.str2m(start);
                var m_end = uni.str2m(end);
                var left = nw * ((m_start - begin) / 60);
                var w = nw * ((m_end - m_start) / 60);
                slider.append("<div class='ss-bar theme-bg' style='left:" + left + "px;width:" + w + "px'/>");
                //tip
                //if (w > 35)//大于35像素显示开始tip
                //    tips.append('<div class="ss-tooltip" style="left: ' + (left - 17) + 'px;"><div class="ss-tooltip-inner">' + start + '</div><div class="ss-tooltip-arrow"></div></div>');
                //if (w > 10)//大于10像素显示结束tip
                //    tips.append('<div class="ss-tooltip" style="left: ' + (left + w - 17) + 'px;"><div class="ss-tooltip-inner">' + end + '</div><div class="ss-tooltip-arrow"></div></div>');
            }
            //初始化 选中条
            if (para.start && para.end) {
                if (para.start.length > 5) para.start = para.start.substr(0, 5);
                if (para.end.length > 5) para.end = para.end.substr(0, 5);
                if (typeof (para.start) == "string") {
                    drawDynBar(para.start, para.end);
                }
                else if (typeof (para.start) == "object" && $(para.start).is("input[type=text],select")) {
                    var $start = $(para.start);
                    var $end = $(para.end);
                    var isSelect = $start.is("select");
                    $start.change(function () {
                        var st = isSelect ? $start.children("option:selected").text() : $start.val();
                        var en = isSelect ? $end.children("option:selected").text() : $end.val();
                        drawDynBar(st, en);
                    });
                    $(para.end).change(function () {
                        var st = isSelect ? $start.children("option:selected").text() : $start.val();
                        var en = isSelect ? $end.children("option:selected").text() : $end.val();
                        drawDynBar(st, en);
                    });
                    $start.trigger("change");
                }
            }
            panel.append(sp[0]);
            panel.append(tbl[0]);
            return panel[0].outerHTML;
            function drawDynBar(start, end) {
                if (!start || !end || start == end) {
                    sp.find(".ss-dyn").remove();
                    return;
                }
                var m_start = uni.str2m(start);
                var m_end = uni.str2m(end);
                var left = nw * ((m_start - begin) / 60);
                var w = nw * ((m_end - m_start) / 60);
                sp.find(".ss-dyn").remove();
                slider.append("<div class='ss-bar theme-bg ss-dyn' data-start='" + start + "' data-end='" + end + "' style='left:" + left + "px;width:" + w + "px'/>");
                //tip
                //if (w > 35)
                //    tips.append('<div class="ss-tooltip ss-dyn" style="left: ' + (left - 17) + 'px;"><div class="ss-tooltip-inner">' + start + '</div><div class="ss-tooltip-arrow"></div></div>');
                //if (w > 10)
                //    tips.append('<div class="ss-tooltip ss-dyn" style="left: ' + (left + w - 17) + 'px;"><div class="ss-tooltip-inner">' + end + '</div><div class="ss-tooltip-arrow"></div></div>');
            }
        };

        //calender 标配
        pro.getCldPara = function () {
            var key = "cld_" + (new Date()).getTime();
            var _para = {
                closeOnSelect: true,
                value: [new Date()],
                weekHeader: false,
                toolbarTemplate:
                '<div class="toolbar calendar-custom-toolbar">' +
                    '<div class="toolbar-inner">' +
                        '<div class="left">' +
                            '<a href="#" class="link icon-only"><i class="icon icon-back"></i></a></div>' +
                        '<div class="center"></div>' +
                        '<div class="right">' +
                            '<a href="#" class="link icon-only"><i class="icon icon-forward"></i></a>' +
                        '</div></div></div>',
                onOpen: function (p) {
                    $('.calendar-custom-toolbar .center', p.container).text(p.currentYear + ', ' + (p.currentMonth + 1));
                    $('.calendar-custom-toolbar .left .link', p.container).on('click', function () {
                        p.prevMonth();
                    });
                    $('.calendar-custom-toolbar .right .link', p.container).on('click', function () {
                        p.nextMonth();
                    });
                },
                onMonthYearChangeStart: function (p) {
                    $('.calendar-custom-toolbar .center', p.container).text(p.currentYear + ', ' + (p.currentMonth + 1));
                }
            }
            return _para;
        };

        //autocomplete
        (function () {
            var _hash = uni.getHash();//多选hash对象
            var _sel;//单选对象
            var _callback;//回调
            app.onPageInit("p-autocomplete", function (page) {
                var query = page.query;
                var con = page.container;
                var result = $(".auto_result", con);
                var selected = $(".auto_selected", con);
                var input = $(".auto_key", con);
                if (_hash) {
                    if (query.owner == "true") {//含自己
                        if (!_hash.get(pro.acc.accno))
                            _hash.set(pro.acc.accno, { "id": pro.acc.accno, "name": pro.acc.name, "label": pro.acc.name});
                    }
                    uploadHash();
                    selected.find(".num_range").html((query.min || uni.translate("无限制")) + "-" + (query.max || uni.translate("无限制")));
                }
                else { selected.hide(); }
                var loader = $('<div class="preloader" style="position: absolute;top: 4px;right: 28px;"></div>');
                var old_tm_out;
                $(".list-block-search", con).on("search", function (e) {
                    if (old_tm_out) clearTimeout(old_tm_out);
                    old_tm_out = setTimeout(function () {
                        query.term = e.detail.query;
                        if (query.term) {
                            loader.insertAfter(input);
                            $.get(pro.dir + "ajax/data/" + query.to, query, function (rlt) {
                                loader.remove();
                                var data = eval("(" + rlt + ")");
                                if (data.length > 0) {
                                    var na = (new Date()).getTime();
                                    var list = app.virtualList($(".auto_result", con)[0], {
                                        items: data,
                                        template: '<li><label class="label-radio item-content" data-id="{{id}}" data-name="{{name}}" data-label="{{label}}">' +
                                    '<div class="item-inner">' +
                                        '<div class="item-title">{{label}}</div></div>' +
                                      '</label></li>'
                                    });
                                }
                                else {
                                    $(".auto_result", con).html("<ul style='text-align:center;padding:10px;'><li>"+uni.translate("未找到任何数据")+"</li></ul>");
                                }
                                $(".auto_result .label-radio", con).click(function () {
                                    var pthis = $(this);
                                    var data = { "id": pthis.data("id"), "name": pthis.data("name"), "label": pthis.data("label") };
                                    if (_hash) {
                                        if (query.max) {//最大值
                                            var max = parseInt(query.max);
                                            if (max <= _hash.size()) {
                                                pro.msgBox("数量不得多于" + max);
                                                return;
                                            }
                                        }
                                        _hash.set(pthis.data("id"), data);
                                        uploadHash();
                                        pro.notice($(".item-title", this).html(), "添加成功");
                                    }
                                    else {
                                        _sel = data;
                                        m_view.router.back();
                                    }
                                });
                            });
                        }
                    }, 500);
                }).on("disableSearch", function () {
                    result.fadeOut();
                }).on("enableSearch", function () {
                    result.html("");
                    result.fadeIn();
                });
                function uploadHash() {
                    var str = "";
                    var arr = _hash.values();
                    var def = false;
                    if (query.min && query.limit == "true") {//最小值
                        var min = parseInt(query.min);
                        if (min >= _hash.size()) {
                            def = true;
                        }
                    }
                    for (var i = 0; i < arr.length; i++) {
                        var my = (query.owner == "true" && arr[i].id == pro.acc.accno);
                        var del = def || my ? "<div class='item-after'>" + my ? "<i class='icon icon-my grey'></i>" : "" + "</div>" : "<div class='item-after'><a href='#' data-id='" + arr[i].id + "' class='item-delete link icon-only'><i class='icon icon-roundclose'></i></a></div>";
                        str += "<li class='li_item'><div class='item-content'><div class='item-inner'><div class='item-title'>"
                            + arr[i].label + "</div>" + del + "</div></div></li>";
                    }
                    selected.find(".cur_num").html(arr.length);
                    selected.find("ul").html(str);
                    $('.item-delete', selected).click(function () {
                        if (uni.isNull(query.min) || _hash.size() > parseInt(query.min)) {
                            _hash.remove($(this).data("id"));
                            selected.find(".cur_num").html(_hash.size());
                            $(this).parents("li.li_item").remove();
                        }
                        else {
                            pro.msgBox("数量不得少于" + query.min);
                        }
                    });
                }
            });
            app.onPageBack("p-autocomplete", function (page) {
                if (_callback) _callback(_hash || _sel, page);
            });
            //Dom拓展
            Dom7.fn.autocomplete = function (callback, hash, query) {
                var pthis = $(this);
                _callback = callback;
                _hash = hash;
                _sel = null;
                pthis.click(function () {
                    m_view.router.loadPage("../a/autocomplete.aspx?to=" + pthis.data("url") + (query ? "&" + $.serializeObject(query) : ""));
                });
            }
            //显示调用
            pro.autocomplete = function (url, callback, hash, query) {
                _callback = callback;
                _hash = hash;
                _sel = null;
                m_view.router.loadPage("../a/autocomplete.aspx?to=" + url + (query ? "&" + $.serializeObject(query) : ""));
            }
        })();
        /*--------------------------ajax-------------------------------------*/

        //ajax相关操作
        pro.j = {
            //访问记录
            history: [],
            //loading开关
            swit: 0,
            //错误信息
            error: {},
            //默认ajax 连接错误回调函数
            _ajaxErr: function (error) {
                this.error = error;
                var msg = "异步连接出现异常";
                if (error.statusText == "timeout" || error.statusText == "")
                    msg = "服务未响应";
                pro.msgBox(msg);
                uni.log(msg + "/status:" + error.statusText, error.responseText);
            },
            //基础ajax方法 get方式
            _get: function (url, data, suc, err) {
                var d = data;
                if (d) {
                    if (typeof (d) === 'object') {
                        d = $.serializeObject(data);
                    }
                    if (d.length > 2000) {//当参数超出url长度限制，转post方式
                        this.post(url, $.parseUrlQuery(d), suc, err);
                        return;
                    }
                    else {
                        url = url + "?" + d;
                    }
                }
                var len = this.history.length;
                if (len > 0) {
                    var last = this.history[len - 1];
                    if (last.act == url && last.ajax_state == "sending") {
                        return;//重复提交 丢弃
                    }
                }
                var sta = { ajax_state: "sending", act: url };
                this.history.push(sta);
                $.ajax({
                    type: "GET",
                    cache: false,
                    timeout: 20000,
                    url: url,
                    dataType: "json",
                    success: suc,
                    error: err,
                    beforeSend: function () {
                        pro.j.swit++;
                        app.showIndicator();
                    },
                    complete: function () {
                        pro.j.swit--;
                        if (pro.j.swit == 0) app.hideIndicator();
                        sta.ajax_state = "complete";
                    }
                });
            },
            //基础ajax方法 post方式
            _post: function (url, data, suc, err) {
                var d = data;
                var len = this.history.length;
                if (len > 0) {
                    var last = this.history[len - 1];
                    if (last.act == d.act && last.ajax_state == "sending") {
                        return;//重复提交 丢弃
                    }
                }
                var sta = { ajax_state: "sending", act: d.act, data: d };
                this.history.push(sta);
                $.ajax({
                    type: "POST",
                    timeout: 20000,
                    url: url,
                    data: d,
                    dataType: "json",
                    success: suc,
                    error: err,
                    beforeSend: function () {
                        pro.j.swit++;
                        app.showIndicator();
                    },
                    complete: function () {
                        pro.j.swit--;
                        if (pro.j.swit == 0) app.hideIndicator();
                        sta.ajax_state = "complete";
                    }
                });
            },
            //post方式 js对象提交
            post: function (url, obj, suc, fail) {
                this._post(url, obj, function (rlt) {
                    pro.j.ckV(rlt, suc, fail);
                }, this._ajaxErr);
            },
            //get方式 js对象提交
            get: function (url, obj, suc, fail) {
                this._get(url, obj, function (rlt) {
                    pro.j.ckV(rlt, suc, fail);
                }, this._ajaxErr);
            },
            //检查返回值
            ckV: function (rlt, suc, fail) {
                if (rlt == undefined) {
                    pro.msgBox("返回了空值！", null, null, "error");
                    return false;
                }
                else {
                    if (rlt.ret == 0) {
                        uni.log(rlt.act, rlt.msg);
                        if (fail == undefined) { pro.msgBox(rlt.msg, null, null, "warning"); }
                        else fail(rlt);
                    }
                    else if (rlt.ret > 0) {
                        if (suc == undefined) { pro.msgBox(rlt.msg, null, null, "success"); }
                        else suc(rlt);
                    }
                    else if (rlt.ret == -1) {//登录超时
                        pro.msgBox(rlt.msg, function () { pro.global.isThirdLogin ? (location.href = "/loginMAll.aspx?op=logout") : app.loginScreen(); }, "", "warning");
                    }
                    return true;
                }
            }
        }
        //登录相关操作
        pro.j.lg = {
            //路径
            p: pro.dir + "ajax/login.aspx",
            _login: function (data, suc, fail) {
                pro.j.get(this.p, data, suc, fail);
            },
            //初始化用户对象
            initAcc: function (suc) {
                this._login({ "act": "init_acc" }, function (rlt) {
                    pro.acc = rlt.data;
                    if (suc) suc(rlt);
                })
            },
            //登录
            login: function (id, pwd, suc, fail, role,aluserid,schoolcode,wxuserid) {
                var data = { "act": "login", "id": id, "pwd": pwd, "role": role, "aliuserid": aluserid, "schoolcode": schoolcode,"wxuserid":wxuserid };
                this._login(data, function (rlt) {
                    if (rlt.ret == 2) {
                        var act = app.modal({
                            title: uni.translate("用户激活"),
                            text: uni.translate("请补充联系信息"),
                            afterText: '<input type="text" name="phone" placeholder="'+uni.translate('手机号')+'" class="phone modal-text-input modal-text-input-double">' +
                                '<input type="text" name="email" placeholder="'+uni.translate('邮箱')+'" class="email modal-text-input modal-text-input-double">',
                            buttons: [{ text: "OK", bold: true, close: false }],
                            onClick: function () {
                                var ph = $(".phone", act).val();
                                var em = $(".email", act).val();
                                if (!ph || $.trim(ph).length < 11 || !uni.ckEmail(em)) {
                                    pro.notice("邮箱/手机号格式有误");
                                    return;
                                };
                                pro.j.lg.act(id, pwd, ph, em, function (rlt2) {
                                    pro.acc = rlt2.data;
                                    app.closeModal(act);
                                    if (suc) suc(rlt2);
                                });
                            }
                        });
                    }
                    else {
                        pro.acc = rlt.data;
                        if (suc) suc(rlt);
                    }
                }, fail);
            },
            //重新登录
            reLogin: function (suc, fail) {
                this.login("@relogin", "", suc, fail);
            },
            //激活并登录
            act: function (id, pwd, phone, email, suc, role) {
                var data = { "act": "act", "id": id, "pwd": pwd, "phone": phone, "email": email, "role": role };
                this._login(data, suc);
            },
            //判断登录
            isLogin: function (suc, fail) {
                this._login({ "act": "is_login" }, suc, fail)
            },
            //帐号是否存在
            isExist: function (id, suc, fail) {
                var data = { "act": "is_exist", "id": id };
                this._login(data, suc, fail);
            },
            //退出登录
            logout: function () {
                var data = { act: "logout" };
                this._login(data, function () {
                    $.cookie("user", null);
                    $.cookie("pwd", null);
                    pro.global.isThirdLogin ? (location.href = "/clientweb/m/a/logout.aspx") : app.loginScreen();
                });
            }
        }
        //账户相关操作
        pro.j.acc = {
            //路径
            p: pro.dir + "ajax/account.aspx",
            accAct: function (acc, suc, fail) {
                pro.j.get(this.p, acc, suc, fail);
            },
            //通过登录名获取账户
            getAccById: function (id, suc) {
                var acc = {};
                acc.act = "get_acc_id";
                acc.id = id;
                this.accAct(acc, suc);
            },
            //通过姓名获取账户
            getAccByName: function (name, suc, ident) {
                var acc = {};
                acc.act = "get_acc_name";
                acc.name = name;
                acc.ident = ident;
                this.accAct(acc, suc);
            },
            //通过标识获取账户
            getAccByAccNo: function (accno, suc) {
                var acc = {};
                acc.act = "get_acc_accno";
                acc.accno = accno;
                this.accAct(acc, function (rlt) {
                    var list = rlt.data;
                    if (list.length > 0) {
                        rlt.data = list[0];
                        suc(rlt);
                    }
                    else {
                        pro.msgBox("未获取到账户");
                    }
                });
            },
            //更新用户信息 主联系方式
            upContact: function (phone, email, suc, para) {
                var acc = para ? uni.getObj(para) : {};
                acc.act = "update_contact";
                acc.phone = phone;
                acc.email = email;
                this.accAct(acc, suc);
            },
            //修改密码
            changePwd: function (old_pwd, pwd1, pwd2, suc) {
                pro.j.lg.login(pro.acc.id, old_pwd, function () {
                    if (pwd1 != pwd2) {
                        pro.msgBox("两次密码不一致");
                        return;
                    }
                    var acc = {};
                    acc.act = "update_pwd";
                    acc.pwd = pwd1;
                    pro.j.acc.accAct(acc, suc);
                });
            }
        }
        //组相关操作
        pro.j.group = {
            //路径
            p: pro.dir + "ajax/group.aspx",
            groupAct: function (g, suc, fail) {
                pro.j.get(this.p, g, suc, fail);
            },
            //获取组信息
            getGroupById: function (group_id, suc) {
                var g = {};
                g.act = "get_g_info";
                g.group_id = group_id;
                this.groupAct(g, function (rlt) {
                    if (rlt.data.length == 1) {
                        rlt.data = rlt.data[0];
                        suc(rlt);
                    }
                    else {
                        pro.msgBox("未找到组");
                    }
                });
            },
            //获取组成员
            getMbs: function (group_id, suc) {
                var g = {};
                g.act = "get_g_mbs";
                g.group_id = group_id;
                this.groupAct(g, suc);
            },
            //添加组成员 可多个 PID
            addMbs: function (group_id, mbs, suc) {
                var g = {};
                g.act = "add_g_mb";
                g.id = mbs;
                g.group_id = group_id;
                this.groupAct(g, suc);
            },
            //添加组成员 可多个 AccNo
            addMbsByAccNo: function (group_id, mbs, suc) {
                var g = {};
                g.act = "add_g_mb_accno";
                g.id = mbs;
                g.group_id = group_id;
                this.groupAct(g, suc);
            },
            //删除组成员
            delMem: function (group_id, id, suc) {
                var g = {};
                g.act = "del_g_mb";
                g.id = id;
                g.group_id = group_id;
                this.groupAct(g, suc);
            },
            //删除组成员byAccNo
            delMemByAccNo: function (group_id, accno, suc) {
                var g = {};
                g.act = "del_g_mb_accno";
                g.group_id = group_id;
                g.accno = accno;
                this.groupAct(g, suc);
            },
            //修改组名
            setGroupName: function (group_id, group_name, suc) {
                var g = {};
                g.act = "set_group_name";
                g.group_id = group_id;
                g.group_name = group_name;
                this.groupAct(g, suc);
            }
        }
        //预约相关操作
        pro.j.rsv = {
            //路径
            p: pro.dir + "ajax/reserve.aspx",
            rsvAct: function (para, suc, fail) {
                pro.j.get(this.p, para, suc, fail);
            },
            //快速预约
            quickResv: function (para, suc) {
                var rsv = para || {};
                rsv.act = "quick_resv";
                this.rsvAct(rsv, suc);
            },
            //获取个人预约
            getMyResv: function (suc, para) {
                var rsv = para || {};
                rsv.act = "get_my_resv";
                this.rsvAct(rsv, suc);
            },
            //删除预约
            delResv: function (id, suc, para) {
                var rsv = para ? uni.getObj(para) : {};
                rsv.act = "del_resv";
                rsv.id = id;
                this.rsvAct(rsv, suc);
            },
            //删除预约组
            delResvGroup: function (id, suc) {
                this.delResv(id, suc, { resv_type: "group" });
            },
            //确定预约生效
            decideResv: function (id, suc) {
                var rsv = {};
                rsv.act = "decide_resv";
                rsv.id = id;
                this.rsvAct(rsv, suc);
            },
            //提前结束预约
            finish: function (id, suc, msg) {
                pro.confirm(msg || "确定要提前结束预约？", function () {
                    var p = {};
                    p.act = "resv_leave";
                    p.type = 2;
                    p.resv_id = id;
                    pro.j.rsv.rsvAct(p, suc, function () {
                        pro.msgBox("操作失败，请确保已开始使用");
                    });
                });
                //pro.confirm(msg || "请确保已使用了系统要求的最短时间，是否继续？", function () {
                //    var rsv = {};
                //    rsv.act = "set_resv";
                //    rsv.resv_id = id;
                //    rsv.cut = "true";
                //    pro.j.rsv.rsvAct(rsv, suc || function () {
                //        pro.msgBox("已提交操作！请检查结束时间。");
                //    });
                //});
            },
            //提交预约
            setResv: function (data, suc) {
                var rsv = data || {};
                rsv.act = "set_resv";
                if (rsv.mb_list && rsv.mb_list.indexOf('&') == 0) {
                    rsv.mb_accno = "true";
                    rsv.mb_list = rsv.mb_list.substr(1);
                }
                pro.j.rsv.rsvAct(rsv, suc);
            },
            //签到
            resvCheckin: function (para, suc) {
                var p = para || {};
                p.act = "resv_checkin";
                pro.j.rsv.rsvAct(p, suc);
            },
            //离开后返回
            resvBack: function (para, suc) {
                var p = para || {};
                p.act = "resv_checkin";
                p.type = 1;
                pro.j.rsv.rsvAct(p, suc);
            },
            //暂时离开
            resvLeave: function (para, suc) {
                var p = para || {};
                p.act = "resv_leave";
                pro.j.rsv.rsvAct(p, suc);
            },
            //延时使用
            resvExtend: function (para, suc) {
                var p = para || {};
                p.act = "resv_extend";
                pro.j.rsv.rsvAct(p, suc);
            }
        }
        pro.j.dev = {
            //路径
            p: pro.dir + "ajax/device.aspx",
            _devAct: function (obj, suc) {
                pro.j.get(this.p, obj, suc);
            },
            //获取设备信息
            getDevById: function (id, suc) {
                var para = { act: "dev_filter", id: id };
                this._devAct(para, function (rlt) {
                    var list = rlt.data.devs;
                    if (list && list.length > 0) {
                        rlt.data = list[0];
                        suc(rlt);
                    }
                    else
                        pro.msgBox("找不到设备", null, null, "warning");
                });
            },
            //获取设备坐标列表
            getDevCoord: function (p, suc) {
                var para = p ? uni.getObj(p) : {};
                para.act = "get_dev_coord";
                this._devAct(para, suc);
            },
            setDevCoord: function (p, data, suc) {
                var para = p ? uni.getObj(p) : {};
                para.data = data;
                para.act = "set_dev_coord";
                pro.j.post(this.p, para, suc);
            },
            //当前设备使用状态
            getUseStat: function (suc, p) {
                var para = p || {};
                para.act = "get_use_stat";
                this._devAct(para, suc);
            },
            //设备筛选
            devFilter: function (fl, suc) {
                fl.act = "dev_filter";
                this._devAct(fl, suc);
            },
            //获取预约状态
            getRsvSta: function (ds, suc) {
                ds.act = "get_rsv_sta";
                this._devAct(ds, suc);
            },
            //获取分类预约状态
            getSortRsvSta: function (ds, suc) {
                ds.act = "get_sort_sta";
                this._devAct(ds, suc);
            }
        }
        //房间相关
        pro.j.rm = {
            //路径
            p: pro.dir + "ajax/room.aspx",
            rmAct: function (obj, suc) {
                pro.j.get(this.p, obj, suc);

            },
            //获取房间状态
            getRmSta: function (para, suc) {
                var ds = para ? uni.getObj(para) : {};
                ds.act = "get_rm_sta";
                this.rmAct(ds, suc);
            },
            //获取房间预约状态
            getRsvSta: function (date, suc, para) {
                var ds = para ? uni.getObj(para) : {};
                ds.date = date;
                ds.act = "get_rsv_sta";
                this.rmAct(ds, suc);
            }
        }
        //其它
        pro.j.util = {
            //路径
            p: pro.dir + "ajax/util.aspx",
            //js对象参数
            utilAct: function (obj, suc) {
                pro.j.get(this.p, obj, suc);
            },
            //初始化语言字典到uni.language
            initLangDic: function (suc) {
                var obj = {};
                obj.act = "get_language";
                pro.j.util.utilAct(obj, function (rlt) {
                    if (rlt.data) {
                        uni.language = rlt.data;
                        if (suc) suc(rlt);
                    }
                });
            },
            //设置语言
            setLanguage: function (language,suc) {
                var obj = {};
                obj.act = "set_language";
                obj.language = language;
                pro.j.util.utilAct(obj, suc);
            },
            setXmlData: function (data, id, type, suc) {
                var para = { act: "set_xml_data" };
                para.data = "\"" + data + "\"";
                para.id = id;
                para.type = type;
                pro.j.get(this.p, para, suc);
            }
        }
        return pro;
    }
})(Dom7, uni);
/*---------------------插件拓展----------------------------*/
//检查表单必填项
Dom7.fn.mustItem = function () {
    var its = $(".must", this);
    for (var i = 0; i < its.length; i++) {
        var pthis = $(its[i]);
        var ipt;
        if (pthis.is("input[type=text],textarea,select")) ipt = pthis;
        else ipt = pthis.find("input[type=text],textarea,select");
        if (ipt.length > 0 && ipt.visible()) {
            if (!ipt.hasClass("allow_null") && (ipt.val()).length == 0) {
                ipt.addClass("must-it").change(function () { $(this).removeClass("must-it"); });
                uni.msgBox(ipt.data("msg") || "还有未填的项目");
                return false;
            }
            if ((ipt.val()).length > 0 && ipt.data("reg")) {
                var reg = ipt.data("reg");
                if (reg == "email") reg = /[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+$/;//邮箱
                else if (reg == "number") reg = /^[0-9]*$/;//数字
                if (!reg.test(ipt.val())) {
                    ipt.addClass("must-it").change(function () { $(this).removeClass("must-it"); });
                    uni.msgBox(ipt.data("ckmsg") || "内容格式不正确");
                    return false;
                }
            }
        }
        pthis.removeClass("must-it");
    };
    return true;
},

//时间选择
(function ($, uni) {
    function toMinute(v) {
        return parseInt(v / 100) * 60 + (v % 100);
    }
    function toTime(v) {
        return parseInt(v / 60) * 100 + (v % 60);
    }
    function toTimeStr(v) {
        v = v + "";
        if (v.length == 3) v = "0" + v;
        return v.substr(v.length - 4, 2) + ":" + v.substr(v.length - 2);
    }
    function timeInt(v) {
        if (v.length > 5)
            v = v.substr(v.length - 5);
        var tmp = v.split(":");
        if (tmp.length < 2) return 0;
        return parseInt(tmp[0], 10) * 100 + parseInt(tmp[1], 10);
    }
    function absMin(v, obj) {
        var diff;
        for (var i in obj) {
            var d = parseInt(i) - v;
            if (diff == undefined) diff = d;
            else if (Math.abs(diff) - Math.abs(d) > 0)
                diff = d;
        }
        return v + (diff || 0);
    }
    function checkInCls(t, cls) {//关闭时间内
        if (cls.length > 0) {
            for (var i = 0; i < cls.length; i++) {
                if (t > cls[i].start && t < cls[i].end)
                    return true;
            }
        }
        return false;
    }
    function checkStartCls(t, cls, min) {//不开放时区的开始时间 作为开始时间选取无意义
        if (cls.length > 0) {
            for (var i = 0; i < cls.length; i++) {
                if (t > cls[i].end && t <= cls[i].start + min)
                    return true;
            }
        }
        return false;
    }
    function findClsEdge(t, cls) {
        var ret = 9999;
        if (cls.length > 0) {
            for (var i = 0; i < cls.length; i++) {
                var start = cls[i].start
                if (t <= start && start < ret)
                    ret = start;
            }
        }
        return ret;
    }

    $.fn.resvTimeClick = function (app, para) {
        if (!para || !uni.isNoNull([
                para.date,//当前日期
                para.openStart,
                para.openEnd,
                para.latest,
                para.earliest,
                para.max,
                para.min
        ])) {
            uni.msgBox("预约规则不完整", null, null, "error");
            uni.log("msg", "预约规则不完整/pro_resvTimeClick");
            return;
        }
        //var hstart = $(this);
        //var hend = $($endTime);
        var p_start = para.start ? (para.start.length > 5 ? para.start.substr(11) : para.start) : 0;//初始化初始传值start
        var p_end = para.end ? (para.end.length > 5 ? para.end.substr(11) : para.end) : 0;//初始化初始传值end
        var open_start = para.openStart ? timeInt(para.openStart) : 0;//开放时间 开始
        var open_end = para.openEnd ? timeInt(para.openEnd) : 2359;//开放时间 结束
        var latest = (para.latest && parseInt(para.latest) < 1440) ? parseInt(para.latest) : 0;//最迟提前
        var earliest = para.earliest ? parseInt(para.earliest) : 1440;//最早提前
        var min = para.min ? parseInt(para.min) : 0;//最少预约时间
        var max = para.max ? parseInt(para.max) : 1440;//最多预约时间
        var unit = para.unit ? parseInt(para.unit) : 10;//时间粒度
        var dft = para.span ? parseInt(para.span) : 0;//初始时间跨度
        var dft_sel = p_start ? timeInt(p_start) : open_start;//初始选中时间
        var old_sel = dft_sel;//保存旧值
        var dft_end = p_end ? timeInt(p_end) : 0;//初始结束时间

        //var fix = para.fix;//选时限制集合 格式{start1:end1,start2:end2...}或{start1:[end1,end2...],start2:[end1,end2...]...}
        var cls = [];
        if (para.cls && para.ts) {
            var temp_cls;
            if (para.allowLong == false)//必须指明不是长期  (临时兼容长期)
                temp_cls = para.cls.concat(para.ts);//关闭时间 繁忙时段  对象数组[{start,end}]
            else
                temp_cls = para.cls;
            for (var i = 0; i < temp_cls.length; i++) {
                var c = {};
                c.start = timeInt(temp_cls[i].start);
                c.end = timeInt(temp_cls[i].end);
                if (para.alter && dft_sel == c.start) continue;//如果是修改 过滤掉当前预约时段
                cls.push(c);
            }
        }
        //if (uni.isEmpty(fix)) fix = null;
        //if (fix) dft_sel = absMin(dft_sel, fix);//存在限制 重置默认值为最接近值

        var input = $(this);
        input.val("");
        var hend = input.hend = [];
        var hstart = input.hstart = [];
        var tmp = input.tmp = [];
        var hd_start = input.siblings(".hd_start");
        if (hd_start.length == 0) {
            hd_start = $("<input type='hidden' name='start' class='hd_start'/>");
            input.before(hd_start);
        }
        else
            hd_start.val("");
        var hd_end = input.siblings(".hd_end");
        if (hd_end.length == 0) {
            hd_end = $("<input type='hidden' name='end' class='hd_end'/>");
            input.before(hd_end);
        }
        else
            hd_end.val("");

        var ustart = open_start;
        var uend = open_end;
        var m_open_start = toMinute(open_start);
        var today = new Date();
        var dt = today.format("yyyy-MM-dd");
        if (dt == para.date) {
            var now = parseInt(today.format("HHmm"));
            var m_now = toMinute(now);
            var sp = m_now - m_open_start;
            if (sp > 0 && now < open_end) {
                var u = m_now % unit;
                if (u > 0)
                    sp = sp - u + unit;
                ustart = toTime(m_open_start + sp);
            }
        }
        var mustart = toMinute(ustart);
        var muend = toMinute(uend);
        var star_muend = muend - min;//开始时间的结束时间应该减去最少预约时长
        var m_dft_sel = toMinute(dft_sel);
        for (var i = mustart; i <= muend; i += unit) {
            var it = toTime(i);
            if (checkInCls(it, cls)) continue;//在关闭时间内
            var m_sp = i - m_dft_sel;
            if (0 <= m_sp && m_sp < unit)
                dft_sel = it;
            var opt = toTimeStr(it);
            if (!checkStartCls(it, cls, min) && i <= star_muend) {//过滤关闭时间的开始时间 过滤限制集合&& (!fix || fix[it]) 
                hstart.push(opt);
            }
            //结束时间集合
            tmp.push(opt);
        }
        if (hstart.length == 0) {
            uni.msgBox("无可用时间，请更改日期");
            return false;
        }
        if (tmp.length == 0) {
            uni.msgBox("缺少结束时间，请检查预约规则");
            return false;
        }
        //初始值
        var initV;
        //开始
        if (timeInt(hstart[0]) > dft_sel) dft_sel = timeInt(hstart[0]);//上界检查
        input.dft_start = toTimeStr(dft_sel);
        analysisEndTimes(input.dft_start);//初始化结束时间集
        //结束
        if (!dft_end) {
            dft_end = toTime(toMinute(dft_sel) + dft);
        }
        var en = toTimeStr(dft_end);
        if (uni.isInArray(en, hend)) input.dft_end = en;
        else input.dft_end = null;
        
        if (p_start && p_end) {//初始带值才赋值
            if (p_start != input.dft_start || p_end != input.dft_end) {//不
                pro.msgBox("由于规则限制，需重新选择预约时间");
            }
            else {
                input.val(input.dft_start + " - " + input.dft_end);
                initV = [input.dft_start, input.dft_end];
                hd_start.val(para.date + " " + input.dft_start);
                hd_end.val(para.date + " " + input.dft_end);
            }
        }

        var vid = this.parent().children(".visual_div");//虚拟显示
        if (this[0].picker) {
            this[0].picker.destroy();
            if (vid.length > 0) {
                vid.html(this.val() || "<span class='grey'>...</span>");
            }
        }
        else {//第一次
            var pthis = this;
            if (vid.length > 0) {
                vid.touchend(function () {
                    pthis.click();
                });
                this.change(function () {
                    vid.html(pthis.val());
                });
                if (pthis.val()) vid.html(pthis.val());
            }
        }
        //实例化控件
        this[0].picker = app.picker({
            input: input,
            toolbarCloseText: uni.translate('确认'),
            value: initV,
            //rotateEffect: true,
            formatValue: function (picker, values) {
                if (values.length == 2)
                    return values[0] + " - " + values[1];
                else
                    return "";
            },
            onChange: function (picker, values) {
                if (values.length == 2) {
                    hd_start.val(para.date + " " + values[0]);
                    var end_date = para.date;
                    hd_end.val(end_date + " " + values[1]);
                }
                else {
                    hd_start.val("");
                    hd_end.val("");
                }
            },
            cols: [
                {
                    values: hstart,
                    onChange: function (picker, value) {
                        analysisEndTimes(value);
                        if (picker.cols[1].replaceValues)
                            picker.cols[1].replaceValues(hend);
                    }
                },
                {
                    values: hend
                }
            ]
        });
        //结束时间
        function analysisEndTimes(value) {
            var val = timeInt(value);
            var h = toMinute(val);
            //若支持长期para.allowLong 将撤销以下三种限制 (临时兼容长期)
            var edge = para.allowLong ? 9999 : findClsEdge(val, cls);//寻找允许时间的边界
            var st = para.allowLong ? open_start : toTime(h + min);//结束时间上限
            var en = para.allowLong ? open_end : toTime(h + uni.backMin([max, toMinute(open_end) - h]));//结束时间下限
            hend = [];
            for (var i = 0; i < tmp.length; i++) {
                var v = timeInt(tmp[i]);
                if (!(v > en || v < st || v > edge))//|| (fix && fix[val] != v)
                    hend.push(tmp[i]);
            }
        }

        ////闪烁
        //function glint() {
        //    input.css("color", "red");
        //    setTimeout(glint2, 250);
        //}
        //function glint2() {
        //    input.css("color", "");
        //}
        //function clearGlint() {
        //    input.css("color", "");
        //    window.clearInterval(glinter);
        //}
    }

    $.fn.initTimePicker = function (app, para) {
        this.addClass("inited");
        var hours = [];
        var minutes = [];
        para.openStart = para.openStart ? pro.dt.tm2num(para.openStart) : 600;
        para.openEnd = para.openEnd ? pro.dt.tm2num(para.openEnd) : 2359;
        var h_start = parseInt(para.openStart / 100);
        var h_end = parseInt(para.openEnd / 100);
        var m_start = para.openStart % 100;
        var m_end = para.openEnd % 100;
        for (var i = h_start; i <= h_end; i++) {
            if (i < 10) hours.push('0' + i);
            else hours.push('' + i);
        }
        var unit = parseInt(para.unit || 10);
        m_start -= (m_start % unit);
        m_end -= (m_end % unit);
        for (var j = 0; j < (60 / unit) ; j++) {
            var v = j * unit;
            if (v < 10) minutes.push('0' + v);
            else minutes.push('' + v);
        }
        if (this[0].picker) {
            this[0].picker.destroy();
        }
        //最小值
        function getMinTime() {
            var hm = 0;
            var now = new Date();
            if (para.dateInput && para.dateInput.val() == now.format('yyyy-MM-dd')) {
                var diff = now.getMinutes() % unit;
                if (diff > 0) now.addMinutes(unit - diff);
                hm = now.getHours() * 100 + now.getMinutes();
            }
            return hm;
        }
        //初值
        var initV;
        if (para.start && para.end) {
            if (para.isAllDay) {//默认全天状态
                para.start = uni.num2Str(h_start) + ":" + uni.num2Str(m_start);
                para.end = uni.num2Str(h_end) + ":" + uni.num2Str(m_end);
                this.val(uni.translate("全天"));
            }
            else {
                var st = para.start.split(':');
                var h1 = st[0];
                var m1 = st[1];
                var en = para.end.split(':');
                var h2 = en[0];
                var m2 = en[1];
                var now = getMinTime();
                if (now > 0) {
                    var minST = parseInt(h1) * 100 + parseInt(m1);
                    var minEN = parseInt(h2) * 100 + parseInt(m2);
                    if (now > minST) {
                        h1 = uni.num2Str(parseInt(now / 100));
                        m1 = uni.num2Str(now % 100);
                    }
                    if (now > minEN) {
                        h2 = h1;
                        m2 = m1;
                    }
                    para.start = h1 + ":" + m1;
                    para.end = h2 + ":" + m2;
                }
                this.val(para.start + " - " + para.end);
            }
            initV = [h1, ':', m1, '-', h2, ':', m2];
            if (uni.isNull(para.timeInput)) {
                para.startInput.val(para.start);
                para.endInput.val(para.end);
            }
            else {
                para.timeInput.val(this.val());
            }
        }
        //实例化控件
        this[0].picker = app.picker({
            input: this[0],
            toolbarCloseText: uni.translate('确认'),
            value: initV,
            onOpen: function (p) {
            },
            onClose: function () {
                if (para.onClose) para.onClose();
            },
            formatValue: function (picker, values) {
                if (values.length == 7)
                    return values[0] + ":" + values[2] + " - " + values[4] + ":" + values[6];
                else
                    return "";
            },
            onChange: function (picker, values) {
                if (values.length == 7) {
                    //
                    var h1 = parseInt(values[0]);
                    var m1 = parseInt(values[2]);
                    var h2 = parseInt(values[4]);
                    var m2 = parseInt(values[6]);
                    var now = getMinTime();
                    if (now > para.openStart && (h1 * 100 + m1) < now) {
                        h1 = parseInt(now / 100);
                        m1 = now % 100;
                        picker.cols[0].setValue(uni.num2Str(h1));
                        picker.cols[2].setValue(uni.num2Str(m1));
                    }
                    if ((h1 * 100 + m1) < para.openStart) {
                        m1 = m_start;
                        picker.cols[2].setValue(uni.num2Str(m1));
                    }
                    else if ((h1 * 100 + m1) > para.openEnd) {
                        m1 = m_end;
                        picker.cols[2].setValue(uni.num2Str(m1));
                    }
                    if ((h2 * 100 + m2) > para.openEnd) {
                        m2 = m_end;
                        picker.cols[6].setValue(uni.num2Str(m2));
                    }
                    if ((h2 * 100 + m2) < (h1 * 100 + m1)) {
                        h2 = h1;
                        m2 = m1;
                        picker.cols[4].setValue(uni.num2Str(h2));
                        picker.cols[6].setValue(uni.num2Str(m2));
                    }
                    //
                    var z_start = pro.dt.timeFull(h1 + ':' + m1);
                    var z_end = pro.dt.timeFull(h2 + ":" + m2);
                    if (uni.isNull(para.timeInput)) {
                        para.startInput.val(z_start);
                        para.endInput.val(z_end);
                    }
                    else {
                        para.timeInput.val(z_start + "-" + z_end);
                    }
                    var end_date = para.date;
                }
                else {
                    if (uni.isNull(para.timeInput)) {
                        para.startInput.val("");
                        para.endInput.val("");
                    }
                    else {
                        para.timeInput.val("");
                    }
                }
            },
            cols: [{ values: hours },
            { values: [':'] },
            { values: minutes },
            { values: ['-'] },
            { values: hours },
            { values: [':'] },
            { values: minutes }]
        });
        //虚拟按钮
        var pthis = this;
        var vid = this.parent().children(".visual_div");
        if (vid.length > 0) {
            vid.touchend(function () {
                pthis.click();
            });
            this.change(function () {
                vid.html(pthis.val());
            });
            if (pthis.val())
                vid.html(pthis.val());
        }
    }

})(Dom7, uni);


